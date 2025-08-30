import SwiftUI

struct FeedView: View {
    @Environment(FeedViewModel.self) private var feed
    @Namespace private var namespace
    @State private var selected: VideoItem? = nil
    @State private var currentlyPlayingID: Int? = nil

    var body: some View {
        ZStack {
            if let selectedItem = selected {
                VideoDetailView(
                    item: selectedItem,
                    namespace: namespace,
                    onClose: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selected = nil
                        }
                    }
                )
                .zIndex(1)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(feed.items) { item in
                            VideoCellView(
                                item: item,
                                namespace: namespace,
                                onOpen: { tapped in
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        selected = tapped
                                    }
                                },
                                currentlyPlayingID: $currentlyPlayingID
                            )
                            .frame(width: UIScreen.main.bounds.width - 40, height: 457)
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
        }
        .task { await feed.loadInitial() }
        .ignoresSafeArea()
    }
}

#Preview {
    FeedView()
        .environment(FeedViewModel.mock)
}
