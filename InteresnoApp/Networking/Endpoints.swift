import Foundation

enum API {
    static let base = URL(string: "https://interesnoitochka.ru/api/v1")!

    static func recommendationsURL(offset: Int, limit: Int) -> URL {
        var comps = URLComponents(url: base.appendingPathComponent("/videos/recommendations"), resolvingAgainstBaseURL: false)!
        comps.queryItems = [
            .init(name: "offset", value: String(offset)),
            .init(name: "limit", value: String(limit)),
            .init(name: "category", value: "shorts"),
            .init(name: "date_filter_type", value: "created"),
            .init(name: "sort_by", value: "date_created"),
            .init(name: "sort_order", value: "desc")
        ]
        return comps.url!
    }

    static func hlsPlaylistURL(videoID: Int) -> URL {
        base.appendingPathComponent("/videos/video/\(videoID)/hls/playlist.m3u8")
    }
}
