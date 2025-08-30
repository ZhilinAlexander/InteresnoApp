import CoreData

extension VideoEntity {
    func update(from item: VideoItem, context: NSManagedObjectContext) {
        id = Int64(item.id)
        author = item.author
        title = item.title
        videoDesc = item.description
        isLive = item.isLive ?? false
        createdAt = item.createdAt
        previewURL = item.previewURL?.absoluteString
        views = Int64(item.views ?? 0)
        likes = Int64(item.likes ?? 0)
        durationSec = Int64(item.durationSec ?? 0)
        tags = item.tags.joined(separator: ",")
        location = item.location                 
    }

    var asItem: VideoItem {
        VideoItem(
            id: Int(id),
            author: author,
            title: title,
            description: videoDesc,
            isLive: isLive,
            createdAt: createdAt,
            previewURL: previewURL.flatMap { URL(string: $0) },
            views: Int(views),
            likes: Int(likes),
            durationSec: Int(durationSec),
            tags: tags?.components(separatedBy: ",") ?? [],
            location: location
        )
    }
}
