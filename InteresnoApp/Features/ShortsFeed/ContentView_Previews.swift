import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(FeedViewModel())
            .environment(PlayerStore())
    }
}
