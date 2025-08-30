import Foundation
import Observation

@Observable
class FeedViewModel {
    var items: [VideoItem] = []
    var isLoading: Bool = false

    private var autoplayTimer: Timer?
    private var currentlyPlayingVideoID: Int?

    // MARK: - Автоплей
    func scheduleAutoplay(for id: Int, completion: @escaping () -> Void) {
        cancelAutoplay()
        currentlyPlayingVideoID = id
        autoplayTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            completion()
        }
    }

    func cancelAutoplay() {
        autoplayTimer?.invalidate()
        autoplayTimer = nil
        currentlyPlayingVideoID = nil
    }

    func isVideoPlaying(_ id: Int) -> Bool {
        return currentlyPlayingVideoID == id
    }

    // MARK: - Загрузка видео
    func loadInitial() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let url = URL(string: "https://interesnoitochka.ru/api/v1/videos/recommendations?offset=0&limit=10&category=shorts&date_filter_type=created&sort_by=date_created&sort_order=desc")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let videos = try decoder.decode([VideoItem].self, from: data)
            await MainActor.run {
                self.items = videos
            }
        } catch {
            print("❌ Ошибка загрузки видео: \(error)")
            // fallback: моковые данные
            let sampleVideos = (1...5).map { i in
                VideoItem(
                    id: i,
                    author: "User \(i)",
                    title: "Video \(i)",
                    description: "Описание видео \(i)",
                    isLive: Bool.random(),
                    createdAt: Date(),
                    previewURL: URL(string: "https://picsum.photos/id/\(i*10)/400/700"),
                    views: Int.random(in: 100...10000),
                    likes: Int.random(in: 10...500),
                    durationSec: Int.random(in: 10...60),
                    tags: ["fun", "travel"],
                    location: "City \(i)"
                )
            }
            await MainActor.run {
                self.items = sampleVideos
            }
        }
    }

    // MARK: - Мок для Preview
    static var mock: FeedViewModel {
        let vm = FeedViewModel()
        vm.items = [
            VideoItem(
                id: 101,
                author: "preview_user",
                title: "Превью видео",
                description: "Это мок для SwiftUI Preview",
                isLive: true,
                createdAt: Date(),
                previewURL: URL(string: "https://picsum.photos/id/242/400/700"),
                views: 1234,
                likes: 567,
                durationSec: 20,
                tags: ["лето", "путешествие"],
                location: "Сочи"
            )
        ]
        return vm
    }
}
