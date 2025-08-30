import Foundation
import Observation

@Observable
class VideoFooterViewModel {
    var messageText: String = ""

    // Счётчики реакций
    var reactions: [String: Int] = [
        "😍": 10_000,
        "❤️": 100_000,
        "🙈": 5_000,
        "👍": 300_000,
        "☺️": 567
    ]

    // Уже лайкнутые реакции
    var userReactions: Set<String> = []

    // Rotation / timer state
    private var elapsedSeconds: Int = 0
    var liveTimer: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private var liveTimerRef: Timer?
    var rotationAngle: Double = 0
    private var rotationTimerRef: Timer?

    func startLiveTimer() {
        DispatchQueue.main.async {
            self.liveTimerRef?.invalidate()
            self.elapsedSeconds = 0
            self.liveTimerRef = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.elapsedSeconds += 1
            }
        }
    }

    func startRotation() {
        DispatchQueue.main.async {
            self.rotationTimerRef?.invalidate()
            self.rotationTimerRef = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.rotationAngle += 3
                if self.rotationAngle >= 360 { self.rotationAngle -= 360 }
            }
        }
    }

    func stopTimers() {
        liveTimerRef?.invalidate()
        liveTimerRef = nil
        rotationTimerRef?.invalidate()
        rotationTimerRef = nil
    }

    func toggleReaction(_ emoji: String) {
        if userReactions.contains(emoji) {
            reactions[emoji, default: 0] = max(0, reactions[emoji, default: 0] - 1)
            userReactions.remove(emoji)
        } else {
            reactions[emoji, default: 0] += 1
            userReactions.insert(emoji)
        }
    }

    func formattedCount(_ count: Int?) -> String {
        guard let count = count else { return "0" }
        switch count {
        case 1_000..<1_000_000: return String(format: "%.1fK", Double(count)/1_000).replacingOccurrences(of: ".0", with: "")
        case 1_000_000..<1_000_000_000: return String(format: "%.1fM", Double(count)/1_000_000).replacingOccurrences(of: ".0", with: "")
        case 1_000_000_000...: return String(format: "%.1fB", Double(count)/1_000_000_000).replacingOccurrences(of: ".0", with: "")
        default: return "\(count)"
        }
    }
}
