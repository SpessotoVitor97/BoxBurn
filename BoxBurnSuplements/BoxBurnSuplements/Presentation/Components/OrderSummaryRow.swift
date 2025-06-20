import SwiftUI

struct OrderSummaryRow: View {
    let label: String
    let value: String
    var isTotal: Bool = false
    
    var body: some View {
        HStack {
            Text(NSLocalizedString(label, comment: label))
                .font(isTotal ? .headline : .body)
                .fontWeight(isTotal ? .bold : .medium)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .font(isTotal ? .headline : .body)
                .fontWeight(isTotal ? .bold : .semibold)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 8)
    }
} 