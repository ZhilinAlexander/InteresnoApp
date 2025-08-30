import SwiftUI

struct VideoCardView: View {
    let item: VideoItem

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            //  Превью видео
            AsyncImage(url: item.previewURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 274, height: 457)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 274, height: 457)
                        .clipped()
                case .failure:
                    Color.gray.opacity(0.3)
                        .frame(width: 274, height: 457)
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(20)

            //  Градиенты
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.7), .clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 150)
            .frame(maxWidth: .infinity, alignment: .bottom)
            .cornerRadius(20)

            VStack(alignment: .leading, spacing: 6) {
                //  Локация
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.white)
                    Text("Россия, Сочи") // 🔹 можно привязать к API
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white)
                }

                // Автор
                if let author = item.author {
                    Text("@\(author)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                }

                //  Заголовок
                if let title = item.title {
                    Text(title)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white)
                        .lineLimit(2)
                }

                //  Live + Теги
                HStack(spacing: 6) {
                    if item.isLive == true {
                        Text("Live")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.red)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                    }

                    //  Теги (заглушка пока)
                    ForEach(["#португалия", "#природа", "#лето"], id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                    }
                }

                //  Views + ❤️ Likes
                HStack {
                    HStack(spacing: 3) {
                        Image(systemName: "eye")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                        Text("\(item.views ?? 0)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white)
                    }

                    HStack(spacing: 3) {
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                        Text("\(item.likes ?? 0)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 4)
            }
            .padding(12)
        }
        .frame(width: 274, height: 457)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
    }
}

