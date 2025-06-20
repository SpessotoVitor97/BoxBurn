import SwiftUI

// Add this View extension for conditional modifier
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// Helper extension to check if a Binding<Bool> is a constant false
extension Binding where Value == Bool {
    var isConstantFalse: Bool {
        // Simple check - if the binding is created with .constant(false), it will always be false
        // This is a simplified approach for our use case
        return false // We'll use a different approach
    }
} 