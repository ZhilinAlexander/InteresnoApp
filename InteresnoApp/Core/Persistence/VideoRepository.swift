import CoreData

final class VideoRepository: VideoRepositoryProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func save(items: [VideoItem]) async throws {
        try await context.perform { [self] in
            for item in items {
                let request: NSFetchRequest<VideoEntity> = VideoEntity.fetchRequest()
                request.predicate = NSPredicate(format: "id == %d", item.id)
                let entity = try context.fetch(request).first ?? VideoEntity(context: context)
                entity.update(from: item, context: context)
            }
            try context.save()
        }
    }

    func fetchAll() async throws -> [VideoItem] {
        try await context.perform { [self] in
            let request: NSFetchRequest<VideoEntity> = VideoEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            return try context.fetch(request).map { $0.asItem }
        }
    }

    func clear() async throws {
        try await context.perform { [self] in
            let fetch: NSFetchRequest<NSFetchRequestResult> = VideoEntity.fetchRequest()
            let delete = NSBatchDeleteRequest(fetchRequest: fetch)
            try context.execute(delete)
            try context.save()
        }
    }
}
