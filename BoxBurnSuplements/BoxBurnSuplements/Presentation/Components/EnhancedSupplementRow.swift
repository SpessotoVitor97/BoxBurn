import SwiftUI

struct EnhancedSupplementRow: View {
    let supplement: Supplement
    let isFavorite: Bool
    let onFavoriteTapped: () -> Void
    let onAddToCart: () -> Void
    @State private var showAddedAlert = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Product Image with Favorite Button Overlay
            ZStack(alignment: .topTrailing) {
                Image(systemName: supplement.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .padding(12)
                    .background(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Favorite Button in top-right corner
                Button(action: onFavoriteTapped) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.caption)
                        .foregroundColor(isFavorite ? .red : .white)
                        .frame(width: 20, height: 20)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .offset(x: 5, y: -5)
            }
            
            // Product Info
            VStack(alignment: .leading, spacing: 6) {
                Text(supplement.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(supplement.productDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text(String(format: "R$ %.2f", supplement.price))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Spacer()
                }
            }
            
            // Buy Button
            Button(action: {
                onAddToCart()
                showAddedAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    showAddedAlert = false
                }
            }) {
                Text(NSLocalizedString("buy_button", comment: "Buy"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 32)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
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