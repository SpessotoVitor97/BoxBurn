import SwiftUI

struct RootView: View {
    @State private var isMenuShowing = false
    @State private var selectedTab: SideMenuDestination = .home
    
    private let homeViewModel: SupplementListViewModel
    
    init(homeViewModel: SupplementListViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            MainTabViewWithHamburger(selectedTab: $selectedTab, isMenuShowing: $isMenuShowing, homeViewModel: homeViewModel)
                .disabled(isMenuShowing)
            if isMenuShowing {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { withAnimation { isMenuShowing = false } }
                SideMenuView(isShowing: $isMenuShowing) { destination in
                    selectedTab = destination
                    withAnimation { isMenuShowing = false }
                }
                .frame(width: 280)
                .transition(.move(edge: .leading))
            }
        }
    }
} 