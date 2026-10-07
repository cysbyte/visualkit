import SwiftUI
import UIKit

actor RemoteImageCache {
    static let shared = RemoteImageCache()

    private struct Entry {
        let image: UIImage
        let expiresAt: Date
    }

    private let cache = NSCache<NSURL, UIImage>()
    private var expiry: [URL: Date] = [:]

    func image(for url: URL) -> UIImage? {
        guard let expiresAt = expiry[url], expiresAt > Date(),
              let image = cache.object(forKey: url as NSURL) else {
            cache.removeObject(forKey: url as NSURL)
            expiry[url] = nil
            return nil
        }
        return image
    }

    func insert(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
        expiry[url] = Date().addingTimeInterval(Self.ttl(for: url))
    }

    private static func ttl(for url: URL) -> TimeInterval {
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
        let expires = queryItems.first(where: {
            $0.name.caseInsensitiveCompare("X-Amz-Expires") == .orderedSame
        })?.value.flatMap(TimeInterval.init)
        guard let expires else { return 300 }

        let signedAt = queryItems.first(where: {
            $0.name.caseInsensitiveCompare("X-Amz-Date") == .orderedSame
        })?.value.flatMap { value -> Date? in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
            return formatter.date(from: value)
        }
        guard let signedAt else {
            return min(expires, 900)
        }
        return max(1, min(signedAt.addingTimeInterval(expires).timeIntervalSinceNow, 900))
    }
}

struct RemoteImageView: View {
    let url: URL?
    var contentMode: ContentMode = .fill
    var refreshURL: (() async throws -> URL)?

    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var didFail = false

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if isLoading {
                ProgressView()
                    .tint(VisualKitTheme.coral)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(VisualKitTheme.surface)
            } else if didFail {
                VStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise.circle")
                        .font(.title2)
                        .foregroundStyle(VisualKitTheme.coral)
                    Text("Image unavailable")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Button("Retry") {
                        Task { await load(forceRefresh: true) }
                    }
                    .font(.caption.weight(.semibold))
                    .buttonStyle(.bordered)
                    .tint(VisualKitTheme.coral)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(VisualKitTheme.surface)
            } else {
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(VisualKitTheme.surface)
            }
        }
        .task(id: url) {
            await load(forceRefresh: false)
        }
    }

    private func load(forceRefresh: Bool) async {
        guard let url else {
            image = nil
            didFail = false
            return
        }

        if !forceRefresh, let cached = await RemoteImageCache.shared.image(for: url) {
            image = cached
            didFail = false
            return
        }

        isLoading = true
        didFail = false
        defer { isLoading = false }

        do {
            let (data, response) = try await fetch(url: url)
            if let httpResponse = response as? HTTPURLResponse,
               [401, 403].contains(httpResponse.statusCode),
               let refreshURL {
                let renewedURL = try await refreshURL()
                let (renewedData, renewedResponse) = try await fetch(url: renewedURL)
                guard let renewedHTTPResponse = renewedResponse as? HTTPURLResponse,
                      (200..<300).contains(renewedHTTPResponse.statusCode),
                      let decoded = UIImage(data: renewedData) else {
                    throw RemoteImageLoadError.invalidResponse
                }
                await RemoteImageCache.shared.insert(decoded, for: renewedURL)
                image = decoded
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode),
                  let decoded = UIImage(data: data) else {
                throw RemoteImageLoadError.invalidResponse
            }
            await RemoteImageCache.shared.insert(decoded, for: url)
            image = decoded
            didFail = false
        } catch is CancellationError {
            return
        } catch {
            image = nil
            didFail = true
        }
    }

    private func fetch(url: URL) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)
        if let configuration = APIConfiguration.fromEnvironment(),
           sameOrigin(url, configuration.baseURL) {
            if let bearerToken = configuration.bearerToken, !bearerToken.isEmpty {
                request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
            } else if let developmentUserID = configuration.developmentUserID {
                request.setValue(developmentUserID.uuidString, forHTTPHeaderField: "X-User-ID")
            }
        }
        return try await URLSession.shared.data(for: request)
    }

    private func sameOrigin(_ first: URL, _ second: URL) -> Bool {
        first.scheme?.lowercased() == second.scheme?.lowercased()
            && first.host?.lowercased() == second.host?.lowercased()
            && (first.port ?? defaultPort(for: first.scheme)) == (second.port ?? defaultPort(for: second.scheme))
    }

    private func defaultPort(for scheme: String?) -> Int? {
        switch scheme?.lowercased() {
        case "http": return 80
        case "https": return 443
        default: return nil
        }
    }
}

private enum RemoteImageLoadError: Error {
    case invalidResponse
}
