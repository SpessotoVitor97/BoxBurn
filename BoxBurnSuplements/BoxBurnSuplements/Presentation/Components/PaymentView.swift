import SwiftUI

struct PaymentView: View {
    @ObservedObject var viewModel: SupplementListViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "creditcard.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text(NSLocalizedString("payment_title", comment: "Payment"))
                .font(.title)
                .fontWeight(.bold)
            
            Text(NSLocalizedString("payment_processing_soon", comment: "Payment processing coming soon..."))
                .foregroundColor(.secondary)
            
            Button(NSLocalizedString("payment_back_to_cart", comment: "Back to Cart")) {
                dismiss()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.blue)
            .cornerRadius(12)
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(NSLocalizedString("payment_title", comment: "Payment"))
    }
} 