import SwiftUI
import AVKit
import Observation

struct DetailVideoView: View {
    let item: VideoItem
    let namespace: Namespace.ID
    let onClose: () -> Void

    @Bindable private var playerModel = VideoPlayerModel()
    @Bindable private var footerModel = VideoFooterViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // MARK: Header
                HStack {
                    Button { onClose() } label: {
                        Image("back")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 24, height: 24)
                    }
                    Spacer()
                    Button { } label: {
                        Image("share")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)

                // MARK: Автор + описание
                HStack(spacing: 12) {
                    Image("avatar_placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text(item.author ?? "@user")
                            .font(.custom("Roboto-Medium", size: 14))
                            .foregroundColor(.white)
                        Text("12 мин назад")
                            .font(.custom("Roboto-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)

                Text(item.title ?? "Название видео")
                    .font(.custom("Roboto-Bold", size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal)

                // MARK: Теги
                HStack {
                    ForEach(item.tags, id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.custom("Roboto-Regular", size: 12))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)

    // MARK: Видео
                if let player = playerModel.player {
                    PlayerContainerView(player: player)
                        .frame(height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                        .onTapGesture { playerModel.togglePlayPause() }
                } else {
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }

    // MARK:Панель действий
                HStack(spacing: 24) {
                    Button { footerModel.toggleReaction("❤️") } label: {
                        Label(
                            footerModel.formattedCount(footerModel.reactions["❤️"]),
                            systemImage: "heart.fill"
                        )
                        .foregroundColor(footerModel.userReactions.contains("❤️") ? .red : .white)
                    }

                    Button { } label: {
                        Label("234", systemImage: "message.fill")
                    }

                    Button { } label: {
                        Label("89", systemImage: "arrowshape.turn.up.forward.fill")
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .font(.custom("Roboto-Regular", size: 14))
                .foregroundColor(.white)

                Divider()
                    .background(Color.gray)

                // MARK:Комментарии + футер
                VStack(alignment: .leading, spacing: 16) {
                    Text("Комментарии")
                        .font(.custom("Roboto-Bold", size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    ForEach(0..<5, id: \.self) { i in
                        HStack(alignment: .top, spacing: 12) {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 32, height: 32)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("@user\(i)")
                                    .font(.custom("Roboto-Medium", size: 13))
                                    .foregroundColor(.white)
                                Text("Очень крутое видео 🔥🔥🔥")
                                    .font(.custom("Roboto-Regular", size: 12))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }

                    VideoFooterView(item: item, model: footerModel)
                        .padding(.bottom, 20)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, 40)
        }
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            let url = API.hlsPlaylistURL(videoID: item.id)
            playerModel.startPlayer(url: url)
            footerModel.startLiveTimer()
        }
        .onDisappear { playerModel.stopPlayer() }
    }
}

