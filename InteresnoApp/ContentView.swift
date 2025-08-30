import SwiftUI
import Observation

struct ContentView: View {
    @State private var feed = FeedViewModel()
    @State private var playerStore = PlayerStore()

    var body: some View {
        MainTabView()
            .environment(feed)
            .environment(playerStore)
    }
}

#Preview {
    ContentView()
        .environment(FeedViewModel())
        .environment(PlayerStore())
}
