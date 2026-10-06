import Foundation

protocol CreationRepository: Sendable {
    func fetchAll() throws -> [Creation]
    func saveAll(_ creations: [Creation]) throws
}

final class JSONCreationRepository: CreationRepository, @unchecked Sendable {
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
                .appendingPathComponent("creations.json")

        encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }

    func fetchAll() throws -> [Creation] {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            let initialCreations = Creation.samples
            try saveAll(initialCreations)
            return initialCreations
        }

        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([Creation].self, from: data)
    }

    func saveAll(_ creations: [Creation]) throws {
        let directoryURL = fileURL.deletingLastPathComponent()
        try fileManager.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )

        let data = try encoder.encode(creations)
        try data.write(to: fileURL, options: [.atomic])
    }
}
