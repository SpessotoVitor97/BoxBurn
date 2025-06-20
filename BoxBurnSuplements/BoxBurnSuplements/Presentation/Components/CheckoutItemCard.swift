import SwiftUI

struct CheckoutItemCard: View {
    let cartItem: CartItem
    @ObservedObject var viewModel: SupplementListViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            // Product Image
            Image(systemName: cartItem.supplement?.imageName ?? "pills")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            // Product Info
            VStack(alignment: .leading, spacing: 6) {
                Text(cartItem.supplement?.name ?? "Unknown Product")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(cartItem.supplement?.productDescription ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(format: "R$ %.2f", cartItem.supplement?.price ?? 0))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        // Quantity Controls
                        HStack(spacing: 12) {
                            Button(action: {
                                let newQuantity = max(1, cartItem.quantity - 1)
                                viewModel.updateQuantity(for: cartItem.supplement!, quantity: newQuantity)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    .accessibilityLabel(NSLocalizedString("cart_decrement", comment: "Decrease quantity"))
                            }
                            
                            Text("\(cartItem.quantity)")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(minWidth: 30)
                                .accessibilityLabel(String(format: NSLocalizedString("cart_quantity", comment: "Quantity: %d"), cartItem.quantity))
                            
                            Button(action: {
                                let newQuantity = cartItem.quantity + 1
                                viewModel.updateQuantity(for: cartItem.supplement!, quantity: newQuantity)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                    .accessibilityLabel(NSLocalizedString("cart_increment", comment: "Increase quantity"))
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Remove Button
                    Button(action: {
                        viewModel.removeFromCart(cartItem.supplement!)
                    }) {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.red)
                            .accessibilityLabel(NSLocalizedString("cart_remove", comment: "Remove from cart"))
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
    }
} 