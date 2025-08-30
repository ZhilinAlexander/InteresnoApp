import SwiftUI

@main
struct InteresnoAppApp: App {
    let feed = FeedViewModel()
    let playerStore = PlayerStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(feed)
                .environment(playerStore)
        }
    }
}
