import UIKit

final class Haptics {
    static let shared = Haptics()

    enum Style {
        case light, medium, heavy
    }

    func play(_ style: Style) {
        let generator: UIImpactFeedbackGenerator
        switch style {
        case .light: generator = UIImpactFeedbackGenerator(style: .light)
        case .medium: generator = UIImpactFeedbackGenerator(style: .medium)
        case .heavy: generator = UIImpactFeedbackGenerator(style: .heavy)
        }
        generator.prepare()
        generator.impactOccurred()
    }
}
