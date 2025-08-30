import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext

        // MARK: 🎬 Моковые данные для SwiftUI Preview
        let mockVideos: [VideoItem] = [
            VideoItem(
                id: 1,
                author: "nika",
                title: "Прогулка по Сочи",
                description: "Водные просторы также впечатляют своей красотой. Вода успокаивает.",
                isLive: false,
                createdAt: Date(),
                previewURL: URL(string: "https://picsum.photos/id/237/400/700"),
                views: 2500,
                likes: 345,
                durationSec: 15,
                tags: ["природа", "лето"],
                location: "Сочи"
            ),
            VideoItem(
                id: 2,
                author: "maxim",
                title: "Горы зимой",
                description: "Зимняя прогулка по заснеженным горам.",
                isLive: false,
                createdAt: Date(),
                previewURL: URL(string: "https://picsum.photos/id/238/400/700"),
                views: 1500,
                likes: 567,
                durationSec: 30,
                tags: ["зима", "горы"],
                location: "Кавказ"
            )
        ]

        // MARK: Преобразуем VideoItem → VideoEntity
        for item in mockVideos {
            let entity = VideoEntity(context: context)
            entity.id = Int64(item.id)
            entity.author = item.author
            entity.title = item.title
            entity.videoDesc = item.description
            entity.isLive = item.isLive ?? false
            entity.createdAt = item.createdAt
            entity.previewURL = item.previewURL?.absoluteString
            entity.views = Int64(item.views ?? 0)
            entity.likes = Int64(item.likes ?? 0)
            entity.durationSec = Int64(item.durationSec ?? 0)
            entity.tags = item.tags.joined(separator: ",") // храним как CSV
            entity.location = item.location
        }

        do {
            try context.save()
        } catch {
            fatalError("❌ Failed to create preview data: \(error)")
        }

        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "InteresnoApp")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Unresolved error \(error)")
            }
        }
    }
}
