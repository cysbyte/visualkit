import Foundation

protocol PersistenceService: Sendable {
    func loadCreations() -> [Creation]
    func saveCreations(_ creations: [Creation])
}

final class InMemoryPersistenceService: PersistenceService, @unchecked Sendable {
    private var creations: [Creation] = Creation.samples

    func loadCreations() -> [Creation] {
        creations
    }

    func saveCreations(_ creations: [Creation]) {
        self.creations = creations
    }
}
