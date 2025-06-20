import SwiftUI

struct SupplementsSection: View {
    @ObservedObject var viewModel: SupplementListViewModel
    var selectedCategory: SupplementCategory
    @Binding var isMenuShowing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(selectedCategory == .all ? NSLocalizedString("home_all_supplements", comment: "All Supplements") : selectedCategory.displayName)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal, 20)
            
            let filteredSupplements = viewModel.filteredSupplements.filter { supplement in
                selectedCategory == .all || supplement.category == selectedCategory.rawValue
            }
            ForEach(filteredSupplements) { supplement in
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
    }
} 