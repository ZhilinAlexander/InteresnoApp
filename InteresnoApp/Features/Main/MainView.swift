import SwiftUI

struct MainView: View {
    @Namespace private var ns
    @State private var goToFeed = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                RoundedRectangle(cornerRadius: 24)
                    .fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(Text("Интересно и Точка")
                        .font(.largeTitle).bold()
                        .foregroundStyle(.white))
                    .matchedGeometryEffect(id: "hero", in: ns)
                    .frame(height: 280)
                    .padding(.horizontal)
                Spacer()
                Button {
                    goToFeed = true
                } label: {
                    Text("Открыть ленту видео").font(.title3).bold()
                        .padding().frame(maxWidth: .infinity)
                        .background(.white).foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal)
                }
                Spacer(minLength: 48)
            }
            .navigationDestination(isPresented: $goToFeed) {
                FeedEntryWrapper(namespace: ns) // Обёртка: старт со звуком
                    .navigationTransition(.zoom(sourceID: "hero", in: ns))
                    .toolbar(.hidden, for: .navigationBar)
            }
            .background(LinearGradient(colors: [.black, .gray], startPoint: .top, endPoint: .bottom))
        }
    }
}

// MARK: Обёртка над лентой включает звук у текущего первого ролика после перехода
struct FeedEntryWrapper: View {
    let namespace: Namespace.ID
    var body: some View {
        FeedView()
            .onAppear {
            }
    }
}
