import Foundation

struct SelectedImage: Codable, Hashable, Sendable {
    var assetID: UUID?
    let data: Data
    let filename: String
    let mimeType: String
    let sourceTypeIdentifier: String
    let pixelWidth: Int
    let pixelHeight: Int
    let originalByteCount: Int
    let byteCount: Int
    var remoteURL: URL?

    init(
        assetID: UUID? = nil,
        data: Data,
        filename: String,
        mimeType: String,
        sourceTypeIdentifier: String,
        pixelWidth: Int,
        pixelHeight: Int,
        originalByteCount: Int,
        byteCount: Int,
        remoteURL: URL? = nil
    ) {
        self.assetID = assetID
        self.data = data
        self.filename = filename
        self.mimeType = mimeType
        self.sourceTypeIdentifier = sourceTypeIdentifier
        self.pixelWidth = pixelWidth
        self.pixelHeight = pixelHeight
        self.originalByteCount = originalByteCount
        self.byteCount = byteCount
        self.remoteURL = remoteURL
    }

    var aspectRatio: Double {
        guard pixelHeight > 0 else { return 1 }
        return Double(pixelWidth) / Double(pixelHeight)
    }
}
