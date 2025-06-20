import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    var onSelect: (SideMenuDestination) -> Void
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 24) {
                // User Info
                HStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("side_menu_welcome", comment: "Welcome!"))
                            .font(.headline)
                        Text(NSLocalizedString("side_menu_guest_user", comment: "Guest User"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 32)
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField(NSLocalizedString("side_menu_search_placeholder", comment: "Search supplements..."), text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                // Navigation Links
                VStack(alignment: .leading, spacing: 20) {
                    SideMenuButton(icon: "house.fill", title: NSLocalizedString("tab_home", comment: "Home")) { onSelect(.home) }
                    SideMenuButton(icon: "star.fill", title: NSLocalizedString("tab_favorites", comment: "Favorites")) { onSelect(.favorites) }
                    SideMenuButton(icon: "cart.fill", title: NSLocalizedString("tab_checkout", comment: "Checkout")) { onSelect(.checkout) }
                    SideMenuButton(icon: "gearshape.fill", title: NSLocalizedString("tab_settings", comment: "Settings")) { onSelect(.settings) }
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: 280, alignment: .leading)
            .background(Color(.systemBackground))
            .edgesIgnoringSafeArea(.all)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .transition(.move(edge: .leading))
        .animation(.easeInOut, value: isShowing)
    }
}

enum SideMenuDestination {
    case home, favorites, checkout, settings
}

struct SideMenuButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.headline)
            }
            .foregroundColor(.primary)
            .padding(.vertical, 8)
        }
    }
} 