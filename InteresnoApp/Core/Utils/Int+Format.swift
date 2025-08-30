import Foundation

// MARK: Форматирование чисел под TikTok (850 → 850, 1200 → 1.2K, 2_400_000 → 2.4M, 3_000_000_000 → 3B)
extension Int {
    func formattedTikTokStyle() -> String {
        switch self {
        case 1_000..<1_000_000:
            return String(format: "%.1fK", Double(self) / 1_000)
                .replacingOccurrences(of: ".0", with: "")
        case 1_000_000..<1_000_000_000:
            return String(format: "%.1fM", Double(self) / 1_000_000)
                .replacingOccurrences(of: ".0", with: "")
        case 1_000_000_000...:
            return String(format: "%.1fB", Double(self) / 1_000_000_000)
                .replacingOccurrences(of: ".0", with: "")
        default:
            return "\(self)"
        }
    }
}

// MARK: Для Optional<Int>, чтобы не писать `?? 0` везде
extension Optional where Wrapped == Int {
    func formattedTikTokStyle() -> String {
        switch self {
        case .some(let value):
            return value.formattedTikTokStyle()
        case .none:
            return "0"
        }
    }
}
