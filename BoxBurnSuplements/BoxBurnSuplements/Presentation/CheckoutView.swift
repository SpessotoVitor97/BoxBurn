import SwiftUI

struct CheckoutView: View {
    @ObservedObject var viewModel: SupplementListViewModel
    @Binding var isMenuShowing: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.cartItems.isEmpty {
                // Empty Cart State
                VStack(spacing: 24) {
                    Spacer()
                    
                    Image(systemName: "cart")
                        .font(.system(size: 80))
                        .foregroundColor(.gray.opacity(0.6))
                    
                    VStack(spacing: 12) {
                        Text(NSLocalizedString("cart_empty_title", comment: "Your cart is empty"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(NSLocalizedString("cart_empty_subtitle", comment: "Add some supplements to get started!"))
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: {}) {
                        Text(NSLocalizedString("cart_start_shopping", comment: "Start Shopping"))
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
                .padding()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Cart Items Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text(NSLocalizedString("cart_items_title", comment: "Items in your cart"))
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(viewModel.cartItems) { cartItem in
                                    CheckoutItemCard(
                                        cartItem: cartItem,
                                        viewModel: viewModel
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Order Summary Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text(NSLocalizedString("cart_order_summary_title", comment: "Order Summary"))
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 0) {
                                OrderSummaryRow(label: "Subtotal", value: String(format: "R$ %.2f", viewModel.cartTotal))
                                OrderSummaryRow(label: "Shipping", value: NSLocalizedString("cart_shipping_free", comment: "Free"))
                                
                                Divider()
                                    .padding(.vertical, 8)
                                
                                OrderSummaryRow(
                                    label: "Total",
                                    value: String(format: "R$ %.2f", viewModel.cartTotal),
                                    isTotal: true
                                )
                            }
                            .padding(20)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                        }
                        
                        // Checkout Button
                        VStack(spacing: 16) {
                            NavigationLink(destination: PaymentView(viewModel: viewModel)) {
                                HStack {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text(NSLocalizedString("cart_proceed_to_checkout", comment: "Proceed to Checkout"))
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationTitle(NSLocalizedString("cart_title", comment: "Cart"))
        .navigationBarItems(leading: HamburgerButton(isMenuShowing: $isMenuShowing))
        .onAppear {
            viewModel.refreshData()
        }
    }
} 