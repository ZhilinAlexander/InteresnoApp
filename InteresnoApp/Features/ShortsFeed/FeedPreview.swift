import SwiftUI

struct FeedPreview: View {
    @Environment(FeedViewModel.self) private var feed
    @Environment(PlayerStore.self) private var playerStore
    @Namespace private var namespace

    var body: some View {
        ShortsFeedView()
            .environment(feed)
            .environment(playerStore)
    }
}

#Preview {
    FeedPreview()
        .environment(FeedViewModel.mock)   // моковые данные
        .environment(PlayerStore())        // плеер
}
