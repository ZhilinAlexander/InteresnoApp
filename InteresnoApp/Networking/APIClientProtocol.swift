import Foundation

protocol APIClientProtocol {
    func fetchRecommendations(offset: Int, limit: Int) async throws -> [VideoItem]
}
