
import SwiftUI

struct VideoOverlays: View {
    let item: VideoItem
    @State private var likeCount: Int
    @State private var liked: Bool = false
    @State private var reactionScale: CGFloat = 1.0

    init(item: VideoItem) {
        self.item = item
        _likeCount = State(initialValue: item.likes ?? 0)
    }

    var body: some View {
        HStack(alignment: .bottom) {
            // Левая часть — текстовые элементы (сверху вниз)
            VStack(alignment: .leading, spacing: 8) {
                // Автор
                Text(item.author.map { "@\($0)" } ?? "@unknown")
                    .font(.headline)
                    .foregroundStyle(.white)

                // Заголовок
                if let title = item.title, !title.isEmpty {
                    Text(title)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(2)
                }

                // Описание
                if let desc = item.description, !desc.isEmpty {
                    Text(desc)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(2)
                }

                // Хэштеги
                if let desc = item.description {
                    let tags = desc.split(separator: " ")
                        .filter { $0.hasPrefix("#") }
                    if !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(tags, id: \.self) { tag in
                                    Text(String(tag))
                                        .font(.caption2.bold())
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.white.opacity(0.2))
                                        .clipShape(Capsule())
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                }

                // Локация
                if let location = item.location {
                    Text(location)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // Правая часть — кнопки действий 
            VStack(spacing: 24) {
                // Лайк
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    liked.toggle()
                    likeCount += liked ? 1 : -1
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                        reactionScale = 1.5
                    }
                    withAnimation(.easeOut(duration: 0.2).delay(0.2)) {
                        reactionScale = 1.0
                    }
                } label: {
                    VStack {
                        Image(systemName: liked ? "heart.fill" : "heart")
                            .font(.title)
                            .foregroundStyle(liked ? .red : .white)
                            .scaleEffect(reactionScale)
                        Text("\(likeCount)")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                }

                // Просмотры
                VStack {
                    Image(systemName: "eye.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                    Text("\(item.views ?? 0)")
                        .font(.caption)
                        .foregroundStyle(.white)
                }

                // Поделиться
                Button {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    // TODO: добавить логику share
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title)
                        .foregroundStyle(.white)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }
}
