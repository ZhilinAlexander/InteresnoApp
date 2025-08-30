import Foundation
import AVFoundation
import Observation

@Observable
class PlayerStore {
    var players: [Int: AVPlayer] = [:]

    func player(for id: Int, url: URL) -> AVPlayer {
        if let existing = players[id] {
            return existing
        } else {
            let newPlayer = AVPlayer(url: url)
            players[id] = newPlayer
            return newPlayer
        }
    }

    func stopAll() {
        for player in players.values {
            player.pause()
        }
    }
}
