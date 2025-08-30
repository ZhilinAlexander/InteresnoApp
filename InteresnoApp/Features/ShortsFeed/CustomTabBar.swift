import SwiftUI

enum Tab: Int {
    case home, bell, add, chat, profile
}

struct CustomTabBar: View {
    @Binding var selected: Tab
    @State private var animatePlus = false

    var body: some View {
        HStack(spacing: 24) {
            tabButton(image: "icon_home", tab: .home)
            tabButton(image: "icon_bell", tab: .bell)

            // MARK: Центральная кнопка "+"
            Image("icon_plus")
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)
                .rotationEffect(.degrees(animatePlus ? 45 : 0))
                .scaleEffect(animatePlus ? 1.2 : 1.0)
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        animatePlus.toggle()
                        selected = .add
                    }
                }
                .frame(width: 40, height: 40)

            tabButton(image: "icon_chat", tab: .chat)
            tabButton(image: "icon_profile", tab: .profile)
        }
        .frame(width: 314, height: 60)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Color(hex: "#555555").opacity(0.3)
                .blur(radius: 30)
        )
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 2)
    }

    private func tabButton(image: String, tab: Tab) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                selected = tab
            }
        } label: {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)
                .foregroundColor(selected == tab ? .white : .gray)
                .scaleEffect(selected == tab ? 1.2 : 1.0) // 🔥 анимация масштаба
                .padding(.vertical, 8)
                .padding(.horizontal, 18)
                .frame(width: 40, height: 40)
        }
        .buttonStyle(.plain) // убираем дефолтный клик-эффект
    }
}


