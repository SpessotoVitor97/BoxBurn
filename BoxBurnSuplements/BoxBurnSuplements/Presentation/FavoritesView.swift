import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: SupplementListViewModel
    @Binding var isMenuShowing: Bool
    
    var body: some View {
        VStack {
            if viewModel.supplements.filter({ viewModel.isFavorite($0) }).isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text(NSLocalizedString("favorites_empty_title", comment: "No favorites yet"))
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(NSLocalizedString("favorites_empty_subtitle", comment: "Your favorite supplements will appear here."))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.supplements.filter({ viewModel.isFavorite($0) })) { supplement in
                            NavigationLink(destination: SupplementDetailView(supplement: supplement, viewModel: viewModel, isMenuShowing: $isMenuShowing)) {
                                EnhancedSupplementRow(
                                    supplement: supplement,
                                    isFavorite: viewModel.isFavorite(supplement),
                                    onFavoriteTapped: { viewModel.toggleFavorite(supplement) },
                                    onAddToCart: { viewModel.addToCart(supplement) }
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(NSLocalizedString("favorites_title", comment: "Favorites"))
        .navigationBarItems(leading: HamburgerButton(isMenuShowing: $isMenuShowing))
        .onAppear {
            viewModel.refreshData()
        }
    }
} 