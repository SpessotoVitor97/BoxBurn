import SwiftUI

struct MenuButton: View {
    @Binding var isMenuShowing: Bool
    
    var body: some View {
        Button(action: {
            print("Menu tapped, toggling menu. Current state: \(isMenuShowing)")
            withAnimation { isMenuShowing.toggle() }
        }) {
            Image(systemName: "line.horizontal.3")
                .imageScale(.large)
                .padding(8)
        }
    }
} 