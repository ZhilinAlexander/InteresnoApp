import SwiftUI

struct FeedGridView: View {
    @Bindable var viewModel: FeedViewModel   // теперь получаем VM снаружи

    private let columns = [
        GridItem(.fixed(274), spacing: 16),
        GridItem(.fixed(274), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Загрузка...")
                    .padding()
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.items) { video in
                        VideoCardView(item: video)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .task {
            await viewModel.loadInitial()
        }
    }
}
