import Foundation

final class VideoRepositoryMock: VideoRepositoryProtocol {
    private var storage: [VideoItem] = []

    func save(items: [VideoItem]) async throws {
        storage.append(contentsOf: items)
    }

    func fetchAll() async throws -> [VideoItem] {
        storage
    }

    func clear() async throws {
        storage.removeAll()
    }
}
