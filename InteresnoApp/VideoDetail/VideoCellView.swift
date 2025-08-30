import SwiftUI
import AVFoundation

struct VideoCellView: View {
    @Bindable var item: VideoItem
    let namespace: Namespace.ID
    let onOpen: (VideoItem) -> Void
    @Binding var currentlyPlayingID: Int?

    @Environment(PlayerStore.self) private var playerStore
    @State private var player: AVPlayer?
    @State private var playerProgress: Double = 0
    @State private var timeObserver: Any?
    @State private var autoplayWorkItem: DispatchWorkItem?

    // MARK: Верхний блок состояния
    @State private var showLive = false
    @State private var showTopBlock = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            //  Видео или превью
            if let player, currentlyPlayingID == item.id {
                PlayerView(player: player)
                    .matchedGeometryEffect(id: item.id, in: namespace)
                    .clipped()
            } else {
                AsyncImage(url: item.previewURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.3))
                }
                .matchedGeometryEffect(id: item.id, in: namespace)
                .clipped()
            }

            // Градиент для читаемости текста
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 140)
            .cornerRadius(20)

            VStack {
                Spacer()

        // MARK: Нижний блок: теги, просмотры, лайки
                VStack(alignment: .leading, spacing: 8) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(item.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(4)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .frame(height: 25)
                    .padding(.bottom, 8)

                    HStack(alignment: .center, spacing: 8) {
                        if let title = item.title {
                            Text(title)
                                .font(.headline)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }

                        Spacer()

                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image("eye")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                Text("\(item.views ?? 0)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }

                            HStack(spacing: 4) {
                                Image("heart")
                                    .resizable()
                                    .frame(width: 14, height: 14)
                                Text("\(item.likes ?? 0)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }
                        }
                    }
                    .padding(.bottom, 12)
                    .padding(.horizontal, 10)
                }
            }
            // MARK: Верхний блок: аватар, имя автора и комментарий
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    //  Аватар автора
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: item.authorAvatarURL) { phase in
                            switch phase {
                            case .empty:
                                Color.gray.opacity(0.3)
                                    .frame(width: 70, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            case .failure(_):
                                Image("avatar_placeholder")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2))
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showLive = item.isLive ?? false
                                showTopBlock = true
                            }
                        }

                        if showLive {
                            Text("LIVE")
                                .font(.custom("Roboto-Bold", size: 11))
                                .foregroundColor(.white)
                                .frame(width: 37, height: 17)
                                .background(Color.red)
                                .clipShape(Capsule())
                                .padding(.bottom, -8)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        // Имя автора
                        if let author = item.author {
                            Text("@\(author)")
                                .font(.custom("Roboto-Medium", size: 14))
                                .foregroundColor(.white)
                        }

                        // Комментарий под именем
                        if let description = item.description {
                            Text(description)
                                .font(.custom("Roboto-Regular", size: 13))
                                .foregroundColor(.white)
                                .lineLimit(2) // максимум 2 
                                .multilineTextAlignment(.leading)
                        }
                    }

                    Spacer()
                }

                Spacer()
            }
            .padding(.leading, 5)
            .opacity(showTopBlock ? 1 : 0)
            .offset(y: showTopBlock ? 0 : -40)
            .animation(.easeOut(duration: 0.5), value: showTopBlock)
            .padding(.top, 16)

        }
        .frame(width: 274, height: 457)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
        .onTapGesture { onOpen(item) }
        .onAppear { scheduleAutoplay() }
        .onDisappear { cleanupPlayer() }
    }

    // MARK: - Автоплей
    private func scheduleAutoplay() {
        autoplayWorkItem?.cancel()
        autoplayWorkItem = DispatchWorkItem {
            currentlyPlayingID = item.id
            preparePlayer()
            player?.seek(to: .zero)
            player?.play()
        }
        if let work = autoplayWorkItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: work)
        }
    }

    private func preparePlayer() {
        guard player == nil else { return }
        let url = API.hlsPlaylistURL(videoID: item.id)
        let p = playerStore.player(for: item.id, url: url)
        p.isMuted = true
        player = p

        timeObserver = p.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.2, preferredTimescale: 600),
            queue: .main
        ) { time in
            guard let duration = p.currentItem?.duration.seconds, duration > 0 else { return }
            playerProgress = time.seconds / duration
        }

        if currentlyPlayingID == item.id {
            player?.play()
        }
    }

    private func cleanupPlayer() {
        autoplayWorkItem?.cancel()
        autoplayWorkItem = nil
        player?.pause()
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        player = nil
    }
}
