import SwiftUI

struct FeaturedSupplementCard: View {
    let supplement: Supplement
    @ObservedObject var viewModel: SupplementListViewModel
    @State private var showAddedAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Product Image with Favorite Button Overlay
            ZStack(alignment: .topTrailing) {
                Image(systemName: supplement.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding()
                    .background(Color(.systemGray6))
                
                // Favorite Button in top-right corner
                Button(action: { viewModel.toggleFavorite(supplement) }) {
                    Image(systemName: viewModel.isFavorite(supplement) ? "heart.fill" : "heart")
                        .font(.caption)
                        .foregroundColor(viewModel.isFavorite(supplement) ? .red : .white)
                        .frame(width: 24, height: 24)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .offset(x: 8, y: -8)
            }
            
            // Product Info Section with Fixed Height
            VStack(alignment: .leading, spacing: 6) {
                Text(supplement.name)
                    .font(.headline)
                    .lineLimit(2)
                    .frame(height: 44, alignment: .top)
                
                Text(String(format: "R$ %.2f", supplement.price))
                    .font(.title3)
                    .foregroundColor(.green)
                    .frame(height: 24, alignment: .top)
            }
            .frame(height: 80)
            
            // Buy Button
            Button(action: {
                viewModel.addToCart(supplement)
                showAddedAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    showAddedAlert = false
                }
            }) {
                Text(NSLocalizedString("buy_now_button", comment: "Buy Now"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .frame(height: 36)
        }
        .frame(width: 160, height: 280)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        .overlay(
            Group {
                if showAddedAlert {
                    Text(NSLocalizedString("added_to_cart", comment: "Added to cart"))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.green.opacity(0.85))
                        .cornerRadius(8)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }, alignment: .topTrailing
        )
    }
} 