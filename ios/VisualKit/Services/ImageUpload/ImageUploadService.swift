import Foundation
import UIKit
import UniformTypeIdentifiers

struct ImportedImage: Sendable {
    let filename: String
    let data: Data
}

enum ImageUploadError: LocalizedError {
    case unreadableImage
    case unsupportedFormat
    case fileTooLarge(Int)
    case compressionFailed

    var errorDescription: String? {
        switch self {
        case .unreadableImage:
            return "The selected image could not be read."
        case .unsupportedFormat:
            return "That image format is not supported."
        case .fileTooLarge(let maxBytes):
            return "The image is larger than the \(ByteCountFormatter.string(fromByteCount: Int64(maxBytes), countStyle: .file)) upload limit."
        case .compressionFailed:
            return "The image could not be prepared for upload."
        }
    }
}

struct ImageUploadConfiguration: Hashable, Sendable {
    let maximumPixelDimension: CGFloat
    let maximumByteCount: Int
    let preferredMIMEType: String

    static let production = ImageUploadConfiguration()

    init(
        maximumPixelDimension: CGFloat = 2048,
        maximumByteCount: Int = 8 * 1024 * 1024,
        preferredMIMEType: String = "image/jpeg"
    ) {
        self.maximumPixelDimension = maximumPixelDimension
        self.maximumByteCount = maximumByteCount
        self.preferredMIMEType = preferredMIMEType
    }
}

protocol ImageUploadService: Sendable {
    func importImage(data: Data, filename: String) async throws -> ImportedImage
    func upload(image: SelectedImage) async throws -> SelectedImage
}

protocol ProgressReportingImageUploadService: ImageUploadService {
    func upload(
        image: SelectedImage,
        progress: @escaping @Sendable (Double) -> Void
    ) async throws -> SelectedImage
}

struct MockImageUploadService: ImageUploadService {
    func importImage(data: Data, filename: String) async throws -> ImportedImage {
        ImportedImage(filename: filename, data: data)
    }

    func upload(image: SelectedImage) async throws -> SelectedImage {
        var image = image
        image.assetID = UUID()
        return image
    }
}

struct RemoteImageUploadService: ProgressReportingImageUploadService {
    let api: any ImageAPI
    let session: URLSession
    let retryPolicy: APIRetryPolicy
    let uploadConfiguration: ImageUploadConfiguration

    init(
        api: any ImageAPI,
        session: URLSession = .shared,
        retryPolicy: APIRetryPolicy = .production,
        uploadConfiguration: ImageUploadConfiguration = .production
    ) {
        self.api = api
        self.session = session
        self.retryPolicy = retryPolicy
        self.uploadConfiguration = uploadConfiguration
    }

    func importImage(data: Data, filename: String) async throws -> ImportedImage {
        ImportedImage(filename: filename, data: data)
    }

    func upload(image: SelectedImage) async throws -> SelectedImage {
        try await upload(image: image, progress: { _ in })
    }

    func upload(
        image: SelectedImage,
        progress: @escaping @Sendable (Double) -> Void
    ) async throws -> SelectedImage {
        do {
            try Task.checkCancellation()
            let preparedImage = try prepareForUpload(image)

            let authorization = try await api.requestUploadURL(
                filename: preparedImage.filename,
                contentType: preparedImage.mimeType,
                sizeBytes: preparedImage.data.count
            )

            var request = URLRequest(url: authorization.uploadURL)
            request.httpMethod = "PUT"
            request.setValue(preparedImage.mimeType, forHTTPHeaderField: "Content-Type")
            request.setValue(String(preparedImage.data.count), forHTTPHeaderField: "Content-Length")
            let response = try await uploadWithRetry(request: request, data: preparedImage.data, progress: progress)
            guard (200..<300).contains(response.statusCode) else {
                throw APIError.uploadFailed("The storage service rejected the upload.")
            }

            let record = try await api.completeUpload(
                assetID: authorization.assetID,
                objectKey: authorization.objectKey,
                sizeBytes: preparedImage.data.count,
                contentType: preparedImage.mimeType,
                pixelWidth: preparedImage.pixelWidth,
                pixelHeight: preparedImage.pixelHeight
            )
            guard record.status == "ready" || record.status == "uploaded" else {
                throw APIError.uploadFailed("The uploaded image is not ready.")
            }

            var uploaded = preparedImage
            uploaded.assetID = authorization.assetID
            return uploaded
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw APIError.map(error, operation: .upload)
        }
    }

    private func prepareForUpload(_ image: SelectedImage) throws -> SelectedImage {
        guard !image.data.isEmpty,
              let decodedImage = UIImage(data: image.data) else {
            throw ImageUploadError.unreadableImage
        }

        let normalizedType = normalizedMIMEType(image.mimeType)
        let canUploadWithoutReencoding = normalizedType != nil &&
            image.data.count <= uploadConfiguration.maximumByteCount &&
            max(image.pixelWidth, image.pixelHeight) <= Int(uploadConfiguration.maximumPixelDimension)

        if canUploadWithoutReencoding {
            return image
        }

        guard let prepared = compressedJPEG(from: decodedImage) else {
            throw ImageUploadError.compressionFailed
        }
        guard prepared.data.count <= uploadConfiguration.maximumByteCount else {
            throw ImageUploadError.fileTooLarge(uploadConfiguration.maximumByteCount)
        }

        return SelectedImage(
            assetID: image.assetID,
            data: prepared.data,
            filename: safeFilename(for: image.filename, mimeType: uploadConfiguration.preferredMIMEType),
            mimeType: uploadConfiguration.preferredMIMEType,
            sourceTypeIdentifier: UTType.jpeg.identifier,
            pixelWidth: prepared.pixelWidth,
            pixelHeight: prepared.pixelHeight,
            originalByteCount: image.originalByteCount,
            byteCount: prepared.data.count,
            remoteURL: image.remoteURL
        )
    }

    private func compressedJPEG(from image: UIImage) -> (data: Data, pixelWidth: Int, pixelHeight: Int)? {
        var resized = image.resizedForUpload(maximumPixelDimension: uploadConfiguration.maximumPixelDimension)
        let qualities: [CGFloat] = [0.86, 0.78, 0.70, 0.62, 0.54]

        for _ in 0..<5 {
            for quality in qualities {
                guard let data = resized.jpegData(compressionQuality: quality) else {
                    continue
                }
                if data.count <= uploadConfiguration.maximumByteCount {
                    return (
                        data,
                        Int(resized.size.width * resized.scale),
                        Int(resized.size.height * resized.scale)
                    )
                }
            }

            let currentLargestDimension = max(resized.size.width * resized.scale, resized.size.height * resized.scale)
            let nextLargestDimension = max(512, floor(currentLargestDimension * 0.72))
            guard nextLargestDimension < currentLargestDimension else {
                break
            }
            resized = resized.resizedForUpload(maximumPixelDimension: nextLargestDimension)
        }

        return nil
    }

    private func normalizedMIMEType(_ value: String) -> String? {
        let mimeType = value
            .split(separator: ";", maxSplits: 1)
            .first
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        guard let mimeType else { return nil }
        switch mimeType {
        case "image/jpeg", "image/png", "image/heic", "image/heif", "image/webp":
            return mimeType
        default:
            return nil
        }
    }

    private func safeFilename(for filename: String, mimeType: String) -> String {
        let base = filename
            .split(separator: ".")
            .dropLast()
            .joined(separator: "-")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let stem = base.isEmpty ? "reference-image" : base
        switch mimeType {
        case "image/png":
            return "\(stem).png"
        case "image/heic":
            return "\(stem).heic"
        case "image/heif":
            return "\(stem).heif"
        case "image/webp":
            return "\(stem).webp"
        default:
            return "\(stem).jpg"
        }
    }

    private func uploadWithRetry(
        request: URLRequest,
        data: Data,
        progress: @escaping @Sendable (Double) -> Void
    ) async throws -> HTTPURLResponse {
        var attempt = 0
        var lastError: Error?

        while attempt < retryPolicy.maxAttempts {
            try Task.checkCancellation()
            attempt += 1

            do {
                let response = try await upload(request: request, data: data, progress: progress)
                if shouldRetry(statusCode: response.statusCode), attempt < retryPolicy.maxAttempts {
                    try await sleepBeforeRetry(attempt: attempt)
                    continue
                }
                return response
            } catch is CancellationError {
                throw CancellationError()
            } catch {
                lastError = error
                guard shouldRetry(error), attempt < retryPolicy.maxAttempts else {
                    throw error
                }
                try await sleepBeforeRetry(attempt: attempt)
            }
        }

        throw lastError ?? APIError.uploadFailed("The image could not be uploaded.")
    }

    private func upload(
        request: URLRequest,
        data: Data,
        progress: @escaping @Sendable (Double) -> Void
    ) async throws -> HTTPURLResponse {
        let delegate = UploadProgressDelegate(progress: progress)
        let session = URLSession(configuration: .ephemeral, delegate: delegate, delegateQueue: nil)
        defer {
            session.invalidateAndCancel()
        }

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                delegate.completion = { result in
                    continuation.resume(with: result)
                }
                let task = session.uploadTask(with: request, from: data)
                delegate.setTask(task)
                task.resume()
            }
        } onCancel: {
            delegate.cancel()
        }
    }

    private func sleepBeforeRetry(attempt: Int) async throws {
        let delay = min(
            retryPolicy.maxDelay,
            retryPolicy.baseDelay * pow(2, Double(max(0, attempt - 1)))
        )
        try await Task.sleep(for: .seconds(delay))
    }

    private func shouldRetry(statusCode: Int) -> Bool {
        statusCode == 408 || statusCode == 429 || (500..<600).contains(statusCode)
    }

    private func shouldRetry(_ error: Error) -> Bool {
        guard let urlError = error as? URLError else { return false }
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost, .cannotFindHost,
             .cannotConnectToHost, .dnsLookupFailed, .timedOut:
            return true
        default:
            return false
        }
    }
}

private final class UploadProgressDelegate: NSObject, URLSessionTaskDelegate, @unchecked Sendable {
    let progress: @Sendable (Double) -> Void
    var completion: ((Result<HTTPURLResponse, Error>) -> Void)?
    private let lock = NSLock()
    private var task: URLSessionUploadTask?
    private var cancelled = false

    init(progress: @escaping @Sendable (Double) -> Void) {
        self.progress = progress
    }

    func setTask(_ task: URLSessionUploadTask) {
        lock.lock()
        self.task = task
        let shouldCancel = cancelled
        lock.unlock()

        if shouldCancel {
            task.cancel()
        }
    }

    func cancel() {
        lock.lock()
        cancelled = true
        let task = task
        lock.unlock()

        task?.cancel()
    }

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        guard totalBytesExpectedToSend > 0 else { return }
        progress(min(1, max(0, Double(totalBytesSent) / Double(totalBytesExpectedToSend))))
    }

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        if let error {
            completion?(.failure(error))
            return
        }
        guard let response = task.response as? HTTPURLResponse else {
            completion?(.failure(APIError.invalidResponse))
            return
        }
        progress(1)
        completion?(.success(response))
    }
}

private extension UIImage {
    func resizedForUpload(maximumPixelDimension: CGFloat) -> UIImage {
        let pixelWidth = size.width * scale
        let pixelHeight = size.height * scale
        let largestDimension = max(pixelWidth, pixelHeight)

        guard largestDimension > maximumPixelDimension else {
            return normalizedForUpload()
        }

        let ratio = maximumPixelDimension / largestDimension
        let targetSize = CGSize(
            width: max(1, floor(pixelWidth * ratio)),
            height: max(1, floor(pixelHeight * ratio))
        )

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            UIColor.white.setFill()
            UIBezierPath(rect: CGRect(origin: .zero, size: targetSize)).fill()
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    func normalizedForUpload() -> UIImage {
        guard imageOrientation != .up else { return self }

        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            UIColor.white.setFill()
            UIBezierPath(rect: CGRect(origin: .zero, size: size)).fill()
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
