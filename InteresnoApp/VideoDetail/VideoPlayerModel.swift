import AVFoundation
import Observation
import Foundation

@Observable
class VideoPlayerModel {
    var player: AVPlayer?
    private var wasPlayingBeforeBackground: Bool = false

    func startPlayer(url: URL?) {
        guard let url = url else { return }

        // Если уже тот же URL — просто play
        if let current = player,
           let currentAsset = (current.currentItem?.asset as? AVURLAsset),
           currentAsset.url == url {
            current.play()
            wasPlayingBeforeBackground = true
            return
        }

        stopPlayer()
        let p = AVPlayer(url: url)
        p.automaticallyWaitsToMinimizeStalling = true
        p.isMuted = false
        player = p
        player?.play()
        wasPlayingBeforeBackground = true
    }

    func togglePlayPause() {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
            wasPlayingBeforeBackground = false
        } else {
            player.play()
            wasPlayingBeforeBackground = true
        }
    }

    func stopPlayer() {
        player?.pause()
        player = nil
        wasPlayingBeforeBackground = false
    }

    func pauseForBackground() {
        guard let player = player else { return }
        wasPlayingBeforeBackground = (player.timeControlStatus == .playing)
        player.pause()
    }

    func resumeIfNeeded(url: URL?) {
        guard let player = player else {
            startPlayer(url: url)
            return
        }
        if wasPlayingBeforeBackground {
            player.play()
        }
    }
}
