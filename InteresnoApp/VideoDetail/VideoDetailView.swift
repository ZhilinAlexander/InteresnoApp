import SwiftUI
import AVKit

struct VideoDetailView: View {
    let item: VideoItem
    let namespace: Namespace.ID
    let onClose: () -> Void

    @State private var player: AVPlayer? = nil
    @State private var footerModel = VideoFooterViewModel()

    var body: some View {
        ZStack {
            // MARK: Видео фон
            VideoPlayerView(player: player)
                .ignoresSafeArea()

            VStack {
                // MARK: Верхние кнопки
                HStack {
                    // Назад
                    Button(action: onClose) {
                        Image("back")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 20, height: 20)
                            .padding(12)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }

                    Spacer()

                    // Далее
                    Button(action: goToNextVideo) {
                        Image("share")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 20, height: 20)
                            .padding(12)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 40)

                Spacer()

                // MARK: Градиент + футер
                ZStack(alignment: .bottom) {
                    //  Полупрозрачный градиент снизу
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.0)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .frame(height: 300) // высота затемнения
                    .ignoresSafeArea(edges: .bottom)

                    // MARK: Футер
                    VideoFooterView(item: item, model: footerModel)
                        .padding(.bottom, 16)
                }
            }
        }
        .onAppear {
            player = AVPlayer(url: API.hlsPlaylistURL(videoID: item.id))
            player?.play()
        }
        .onDisappear {
            player?.pause()
        }
    }

    private func goToNextVideo() {
        // TODO: реализовать переключение на следующее видео
        print("Go to next video")
    }
}
