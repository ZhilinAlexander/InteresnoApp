import Foundation

protocol VideoRepositoryProtocol {
    func save(items: [VideoItem]) async throws
    func fetchAll() async throws -> [VideoItem]
    func clear() async throws
}
