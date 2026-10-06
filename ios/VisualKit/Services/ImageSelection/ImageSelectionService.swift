import Foundation
import ImageIO
import PhotosUI
import UniformTypeIdentifiers
import UIKit

enum ImageSelectionError: LocalizedError {
    case unsupportedFormat
    case unavailableData
    case unreadableImage
    case processingFailed
    case photoLibrary(Error)

    var errorDescription: String? {
        switch self {
        case .unsupportedFormat:
            return "That file format is not supported. Choose a standard photo such as JPEG, PNG, or HEIF."
        case .unavailableData:
            return "The selected photo could not be read. Please try another image."
        case .unreadableImage:
            return "The selected file is not a readable image."
        case .processingFailed:
            return "The image could not be prepared for VisualKit."
        case .photoLibrary(let error):
            return error.localizedDescription
        }
    }
}

protocol ImageSelectionService: Sendable {
    func prepareImage(from result: PHPickerResult) async throws -> SelectedImage
}

struct NativeImageSelectionService: ImageSelectionService {
    let maximumPixelDimension: Int
    let maximumByteCount: Int

    init(
        maximumPixelDimension: Int = 2048,
        maximumByteCount: Int = 8 * 1024 * 1024
    ) {
        self.maximumPixelDimension = maximumPixelDimension
        self.maximumByteCount = maximumByteCount
    }

    func prepareImage(from result: PHPickerResult) async throws -> SelectedImage {
        let provider = result.itemProvider
        guard let typeIdentifier = imageTypeIdentifier(from: provider) else {
            throw ImageSelectionError.unsupportedFormat
        }

        let sourceData: Data
        do {
            sourceData = try await loadData(from: provider, typeIdentifier: typeIdentifier)
        } catch {
            throw ImageSelectionError.photoLibrary(error)
        }

        guard !sourceData.isEmpty else {
            throw ImageSelectionError.unavailableData
        }

        guard let source = CGImageSourceCreateWithData(sourceData as CFData, nil) else {
            throw ImageSelectionError.unreadableImage
        }

        let thumbnailOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maximumPixelDimension
        ]

        guard let thumbnail = CGImageSourceCreateThumbnailAtIndex(
            source,
            0,
            thumbnailOptions as CFDictionary
        ) else {
            throw ImageSelectionError.processingFailed
        }

        let image = UIImage(cgImage: thumbnail)
        guard let outputData = jpegDataWithinLimit(for: image) else {
            throw ImageSelectionError.processingFailed
        }

        return SelectedImage(
            data: outputData,
            filename: "reference-image.jpg",
            mimeType: UTType.jpeg.preferredMIMEType ?? "image/jpeg",
            sourceTypeIdentifier: typeIdentifier,
            pixelWidth: thumbnail.width,
            pixelHeight: thumbnail.height,
            originalByteCount: sourceData.count,
            byteCount: outputData.count
        )
    }

    private func imageTypeIdentifier(from provider: NSItemProvider) -> String? {
        provider.registeredTypeIdentifiers.first { identifier in
            guard let type = UTType(identifier) else { return false }
            return type.conforms(to: .image)
        }
    }

    private func loadData(
        from provider: NSItemProvider,
        typeIdentifier: String
    ) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            provider.loadDataRepresentation(forTypeIdentifier: typeIdentifier) { data, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: ImageSelectionError.unavailableData)
                }
            }
        }
    }

    private func jpegDataWithinLimit(for image: UIImage) -> Data? {
        var candidate = image
        let qualities: [CGFloat] = [0.82, 0.68, 0.54, 0.40, 0.28]

        for _ in 0..<5 {
            for quality in qualities {
                guard let data = candidate.jpegData(compressionQuality: quality) else {
                    continue
                }
                if data.count <= maximumByteCount {
                    return data
                }
            }

            let nextSize = CGSize(
                width: max(candidate.size.width * 0.72, 512),
                height: max(candidate.size.height * 0.72, 512)
            )
            guard nextSize != candidate.size else { break }
            candidate = resizedImage(candidate, to: nextSize)
        }

        return nil
    }

    private func resizedImage(_ image: UIImage, to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
