import Foundation

protocol StyleRepository: Sendable {
    func fetchAll() throws -> [SavedStyle]
    func saveAll(_ styles: [SavedStyle]) throws
}

final class JSONStyleRepository: StyleRepository, @unchecked Sendable {
    private let fileURL: URL
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        fileURL: URL? = nil,
        fileManager: FileManager = .default
    ) {
        self.fileManager = fileManager
        self.fileURL = fileURL
            ?? fileManager
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("VisualKit", isDirectory: true)
                .appendingPathComponent("styles.json")

        encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }

    func fetchAll() throws -> [SavedStyle] {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            let initialStyles = SavedStyle.samples
            try saveAll(initialStyles)
            return initialStyles
        }

        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([SavedStyle].self, from: data)
    }

    func saveAll(_ styles: [SavedStyle]) throws {
        let directoryURL = fileURL.deletingLastPathComponent()
        try fileManager.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )

        let data = try encoder.encode(styles)
        try data.write(to: fileURL, options: [.atomic])
    }
}
