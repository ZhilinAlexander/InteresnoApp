import Foundation

final class APIClientMock: APIClientProtocol {
    func fetchRecommendations(offset: Int, limit: Int) async throws -> [VideoItem] {
        return [
            VideoItem(
                id: 101,
                author: "mock_user",
                title: "Моковое видео",
                description: "Описание для SwiftUI Preview",
                isLive: false,
                createdAt: Date(),
                previewURL: URL(string: "https://picsum.photos/400/700"),
                views: 123,
                likes: 45,
                durationSec: 20,
                tags: ["mock", "preview"],
                location: "Москва"
            ),
            VideoItem(
                id: 102,
                author: "another_user",
                title: "Второе видео",
                description: "Тоже мок",
                isLive: true,
                createdAt: Date(),
                previewURL: URL(string: "https://picsum.photos/400/701"),
                views: 456,
                likes: 78,
                durationSec: 15,
                tags: ["fun", "shorts"],
                location: "Сочи"
            )
        ]
    }
}
