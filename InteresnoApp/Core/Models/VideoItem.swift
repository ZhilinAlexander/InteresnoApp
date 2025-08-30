import Foundation

@Observable
class VideoItem: Identifiable, Decodable, Hashable {
    // MARK: - Identity / Hashable
    static func == (lhs: VideoItem, rhs: VideoItem) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }

    // MARK: - Props
    let id: Int
    var author: String?
    var title: String?
    var description: String?
    var isLive: Bool?
    var createdAt: Date?
    var previewURL: URL?
    var views: Int?
    var likes: Int?
    var durationSec: Int?
    var tags: [String]
    var location: String?
    var authorAvatarURL: URL?


    enum CodingKeys: String, CodingKey {
        case id = "video_id"
        case author = "author_username"
        case title, description
        case isLive = "is_live"
        case createdAt = "date_created"
        case previewURL = "thumb_url"
        case views, likes
        case durationSec = "duration"
        case tags, location
        case authorAvatarURL = "avatar_url"

    }

    // MARK: - Инициализатор для моков и ручного создания
    init(
        id: Int,
        author: String? = nil,
        title: String? = nil,
        description: String? = nil,
        isLive: Bool? = nil,
        createdAt: Date? = nil,
        previewURL: URL? = nil,
        views: Int? = nil,
        likes: Int? = nil,
        durationSec: Int? = nil,
        tags: [String] = [],
        location: String? = nil
    ) {
        self.id = id
        self.author = author
        self.title = title
        self.description = description
        self.isLive = isLive
        self.createdAt = createdAt
        self.previewURL = previewURL
        self.views = views
        self.likes = likes
        self.durationSec = durationSec
        self.tags = tags
        self.location = location
    }

    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            id: try c.decode(Int.self, forKey: .id),
            author: try c.decodeIfPresent(String.self, forKey: .author),
            title: try c.decodeIfPresent(String.self, forKey: .title),
            description: try c.decodeIfPresent(String.self, forKey: .description),
            isLive: try c.decodeIfPresent(Bool.self, forKey: .isLive),
            createdAt: try c.decodeIfPresent(Date.self, forKey: .createdAt),
            previewURL: try c.decodeIfPresent(URL.self, forKey: .previewURL),
            views: try c.decodeIfPresent(Int.self, forKey: .views),
            likes: try c.decodeIfPresent(Int.self, forKey: .likes),
            durationSec: try c.decodeIfPresent(Int.self, forKey: .durationSec),
            tags: try c.decodeIfPresent([String].self, forKey: .tags) ?? [],
            location: try c.decodeIfPresent(String.self, forKey: .location)
        )
    }
}
