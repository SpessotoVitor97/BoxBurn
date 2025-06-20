import SwiftUI

struct HamburgerButton: View {
    @Binding var isMenuShowing: Bool
    
    var body: some View {
        Button(action: { withAnimation { isMenuShowing.toggle() } }) {
            Image(systemName: "line.horizontal.3")
                .imageScale(.large)
                .padding(8)
        }
    }
} 