import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    private let feed = FeedViewModel()

    // 👇 @Observable-модель видимости таббара
    @State private var tabBarVisibility = TabBarVisibility()

    var body: some View {
        ZStack(alignment: .bottom) {
            // Контент вкладок
            ZStack {
                switch selectedTab {
                case 0:
                    ShortsFeedView()                 //  список
                        .environment(feed)
                        .environment(tabBarVisibility)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                case 1:
                    Text("Поиск")
                        .transition(.move(edge: .leading).combined(with: .opacity))
                case 2:
                    Text("Создание")
                        .transition(.scale.combined(with: .opacity))
                case 3:
                    Text("Уведомления")
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                case 4:
                    Text("Профиль")
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                default:
                    ShortsFeedView()
                        .environment(feed)
                        .environment(tabBarVisibility)
                }
            }
            .animation(.easeInOut(duration: 0.35), value: selectedTab)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()

            //  Кастомный таббар — показываем ТОЛЬКО если isVisible == true
            if tabBarVisibility.isVisible {
                HStack(spacing: 24) {
                    TabBarButton(icon: "icon_home", index: 0, selectedTab: $selectedTab)
                    TabBarButton(icon: "icon_bell", index: 1, selectedTab: $selectedTab)

                    Button {
                        Haptics.shared.play(.medium)
                        selectedTab = 2
                    } label: {
                        Image("icon_plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }

                    TabBarButton(icon: "icon_chat", index: 3, selectedTab: $selectedTab)
                    TabBarButton(icon: "icon_profile", index: 4, selectedTab: $selectedTab)
                }
                .frame(width: 282, height: 40)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Color(hex: "#555555").opacity(0.3) // фон #5555554D
                        .blur(radius: 30)
                )
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 2) 
                .frame(width: 314, height: 60)
                .padding(.bottom, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Кнопка таббара (без изменений)
private struct TabBarButton: View {
    let icon: String
    let index: Int
    @Binding var selectedTab: Int
    @State private var bounce: Bool = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                Haptics.shared.play(.light)
                selectedTab = index
                bounce.toggle()
            }
        } label: {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .scaleEffect(selectedTab == index ? (bounce ? 1.3 : 1.15) : 1.0)
                .foregroundColor(selectedTab == index ? .blue : .gray)
                .animation(.spring(response: 0.35, dampingFraction: 0.4), value: bounce)
        }
    }
}

// MARK: - Хелпер для hex-цвета (как было)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
