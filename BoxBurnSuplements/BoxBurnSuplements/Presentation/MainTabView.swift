import SwiftUI

struct MainTabViewWithHamburger: View {
    @Binding var selectedTab: SideMenuDestination
    @Binding var isMenuShowing: Bool
    @ObservedObject var homeViewModel: SupplementListViewModel
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                SupplementListView(viewModel: homeViewModel, isMenuShowing: $isMenuShowing)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text(NSLocalizedString("tab_home", comment: "Home"))
            }
            .tag(SideMenuDestination.home)
            
            NavigationView {
                FavoritesView(viewModel: homeViewModel, isMenuShowing: $isMenuShowing)
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text(NSLocalizedString("tab_favorites", comment: "Favorites"))
            }
            .tag(SideMenuDestination.favorites)
            
            NavigationView {
                CheckoutView(viewModel: homeViewModel, isMenuShowing: $isMenuShowing)
                    .navigationBarItems(leading: HamburgerButton(isMenuShowing: $isMenuShowing))
            }
            .tabItem {
                Image(systemName: "cart.fill")
                Text(NSLocalizedString("tab_checkout", comment: "Checkout"))
            }
            .tag(SideMenuDestination.checkout)
            .badge(homeViewModel.cartItems.reduce(0) { $0 + $1.quantity })
            
            NavigationView {
                SettingsView(isMenuShowing: $isMenuShowing)
                    .navigationBarItems(leading: HamburgerButton(isMenuShowing: $isMenuShowing))
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text(NSLocalizedString("tab_settings", comment: "Settings"))
            }
            .tag(SideMenuDestination.settings)
        }
    }
} 