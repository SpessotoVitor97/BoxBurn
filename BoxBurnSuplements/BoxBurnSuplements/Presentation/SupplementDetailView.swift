import SwiftUI

struct SupplementDetailView: View {
    let supplement: Supplement
    @ObservedObject var viewModel: SupplementListViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var isMenuShowing: Bool
    
    init(supplement: Supplement, viewModel: SupplementListViewModel, isMenuShowing: Binding<Bool>) {
        self.supplement = supplement
        self.viewModel = viewModel
        _isMenuShowing = isMenuShowing
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Product Image
                Image(systemName: supplement.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 20) {
                    // Product Info
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(supplement.name)
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                            Button(action: {
                                viewModel.toggleFavorite(supplement)
                            }) {
                                Image(systemName: viewModel.isFavorite(supplement) ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .foregroundColor(viewModel.isFavorite(supplement) ? .red : .gray)
                            }
                        }
                        
                        Text(supplement.productDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                        
                        HStack {
                            Text("R$ \(String(format: "%.2f", supplement.price))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            Spacer()
                            Text(supplement.category.capitalized)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                        }
                        
                        // Rating Section
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(NSLocalizedString("detail_rating", comment: "Rating"))
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("4.2 out of 5")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack(spacing: 4) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < 4 ? "star.fill" : "star")
                                        .font(.title3)
                                        .foregroundColor(.yellow)
                                }
                                Text("(24 reviews)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 8)
                            }
                        }
                        .padding(.top, 8)
                    }
                    
                    // Add to Cart Section
                    VStack(spacing: 16) {
                        Button(action: {
                            viewModel.addToCart(supplement)
                        }) {
                            HStack {
                                Image(systemName: "cart.badge.plus")
                                    .font(.system(size: 18, weight: .semibold))
                                Text(NSLocalizedString("detail_add_to_cart", comment: "Add to Cart"))
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            viewModel.addToCart(supplement)
                        }) {
                            HStack {
                                Image(systemName: "cart.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                Text(NSLocalizedString("detail_buy_now", comment: "Buy Now"))
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: isMenuShowing ? HamburgerButton(isMenuShowing: $isMenuShowing) : nil)
    }
} 