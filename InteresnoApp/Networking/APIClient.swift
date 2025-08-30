import Foundation


final class APIClient: APIClientProtocol {
    var token: String? = nil   // на случай, если API потребует ключ

    private var decoder: JSONDecoder {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }

    // Обёртка для JSON с ключом items
    private struct Envelope: Decodable {
        let items: [VideoItem]
    }

    func fetchRecommendations(offset: Int, limit: Int) async throws -> [VideoItem] {
        var request = URLRequest(url: API.recommendationsURL(offset: offset, limit: limit))
        request.httpMethod = "GET"
        if let token { request.addValue(token, forHTTPHeaderField: "Authorization") }

        let (data, resp) = try await URLSession.shared.data(for: request)

        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        // Сначала пробуем декодировать как объект с ключом items
        if let envelope = try? decoder.decode(Envelope.self, from: data) {
            return envelope.items
        }
        // Если вдруг сервер вернул массив напрямую — поддерживаем это
        if let items = try? decoder.decode([VideoItem].self, from: data) {
            return items
        }
        // Если не удалось ни то, ни другое — кидаем ошибку
        throw URLError(.cannotParseResponse)
    }
}
