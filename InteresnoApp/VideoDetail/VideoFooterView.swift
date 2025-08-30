import SwiftUI
import Observation

struct VideoFooterView: View {
    let item: VideoItem
    @Bindable var model: VideoFooterViewModel

    private let reactionOrder = ["😍", "❤️", "🙈", "👍", "☺️"]

    @State private var showLive = false
    @State private var showTimer = false
    @State private var showTopBlock = false

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                // MARK: Нижний футер
                VStack(alignment: .leading, spacing: 16) {
                    // Друзья
                    HStack(spacing: 8) {
                        Image(systemName: "person.2.fill")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                        Text("Друзья смотрят: @dasha @anna @pavel")
                            .font(.custom("Roboto-Regular", size: 11))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    // Views
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                        Text("\(model.formattedCount(item.views)) смотрят эфир")
                            .font(.custom("Roboto-Regular", size: 11))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    // Title + stats
                    HStack(spacing: 6) {
                        Text(item.title ?? "RA'MEN")
                            .font(.custom("Roboto-Medium", size: 13))
                            .foregroundColor(.white)
                        Text("(12)")
                            .font(.custom("Roboto-Medium", size: 11))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    // Tags
                    HStack(spacing: 8) {
                        ForEach(item.tags.isEmpty ? ["#португалия", "#природа", "#лето"] : item.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.custom("Roboto-Regular", size: 11))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.clear)
                                .clipShape(Capsule())
                        }
                    }

                    // Reactions
                    HStack(spacing: 12) {
                        ForEach(reactionOrder, id: \.self) { emoji in
                            let count = model.reactions[emoji, default: 0]
                            let isActive = model.userReactions.contains(emoji)

                            Button {
                                model.toggleReaction(emoji)
                            } label: {
                                HStack(spacing: 6) {
                                    Text(emoji)
                                    Text(model.formattedCount(count))
                                        .font(.custom("Roboto-Regular", size: 11))
                                }
                                .foregroundColor(isActive ? .red : .white)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // MARK: Comment field (Figma style)
                    ZStack {
                        // фон: blur + серый слой
                        RoundedRectangle(cornerRadius: 100)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(Color(hex: "#5555554D"))
                            )
                            .frame(width: 341, height: 48)

                        HStack {
                            TextField("Добавить комментарий", text: $model.messageText)
                                .font(.custom("Roboto-Regular", size: 12))
                                .padding(.leading, 16)

                            Spacer()

                            Button {
                                model.messageText = ""
                            } label: {
                                Image("paper_airplane")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 16)
                            }
                        }
                        .frame(width: 341, height: 48)
                    }
                }
                .padding(16)
                .frame(width: 343, height: 234)
                .background(Color.clear)
            }

            // MARK: Верхний блок с аватаром
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 12) {
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: item.authorAvatarURL) { phase in
                            switch phase {
                            case .empty:
                                Color.gray.opacity(0.3)
                                    .frame(width: 84, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 84, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            case .failure(_):
                                Image("avatar_placeholder")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 84, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white, lineWidth: 2))
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.5)) {
                                showLive = true
                                showTimer = true
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

                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 4) {
                            Text(item.author ?? "@kristina")
                                .font(.custom("Roboto-Medium", size: 14))
                                .foregroundColor(.white)
                            Image(systemName: "checkmark.seal.fill")
                                .resizable()
                                .frame(width: 14, height: 14)
                                .foregroundColor(.blue)
                        }

                        HStack(spacing: 4) {
                            Image(systemName: "mappin.and.ellipse")
                                .resizable()
                                .frame(width: 14, height: 14)
                                .foregroundColor(.white)
                            Text(item.location ?? "Россия, Сочи")
                                .font(.custom("Roboto-Regular", size: 12))
                                .foregroundColor(.white.opacity(0.8))
                        }

                        if !model.messageText.isEmpty {
                            Text(model.messageText)
                                .font(.custom("Roboto-Regular", size: 14))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .frame(width: 247, alignment: .topLeading)
                        } else {
                            Text(makeCommentText(
                                comment: item.description ?? "Водные просторы также впечатляют своей красотой...",
                                friends: ["@anna","@oleg","@dasha"]
                            ))
                            .font(.custom("Roboto-Regular", size: 14))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .frame(width: 247, height: 64, alignment: .topLeading)
                        }
                    }
                }
                .frame(width: 343, height: 112)

                if showTimer {
                    Text(model.liveTimer)
                        .font(.custom("Roboto-Regular", size: 11).monospacedDigit())
                        .foregroundColor(.white)
                        .frame(width: 44, height: 21)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Capsule())
                        .padding(.leading, 20)
                        .padding(.top, 2)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                Spacer()
            }
            .padding(.top, 16)
            .opacity(showTopBlock ? 1 : 0)
            .offset(y: showTopBlock ? 0 : -40)
            .animation(.easeOut(duration: 0.5), value: showTopBlock)
        }
    }

    private func makeCommentText(comment: String, friends: [String]) -> AttributedString {
        var attributed = AttributedString(comment)
        for friend in friends {
            if let range = attributed.range(of: friend) {
                attributed[range].font = .custom("Roboto-Bold", size: 14)
                attributed[range].underlineStyle = .single
            }
        }
        return attributed
    }
}
