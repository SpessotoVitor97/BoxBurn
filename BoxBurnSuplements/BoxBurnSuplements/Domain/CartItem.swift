import Foundation
import SwiftData

@Model
public final class CartItem {
    @Attribute(.unique) public var id: UUID
    public var supplementId: UUID
    public var quantity: Int
    public var backendId: String?
    public var lastSynced: Date?
    public var createdAt: Date
    public var updatedAt: Date
    
    // Relationship to Supplement
    @Relationship(deleteRule: .cascade) public var supplement: Supplement?
    
    public init(
        id: UUID = UUID(),
        supplementId: UUID,
        quantity: Int = 1,
        backendId: String? = nil,
        lastSynced: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.supplementId = supplementId
        self.quantity = quantity
        self.backendId = backendId
        self.lastSynced = lastSynced
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Identifiable
extension CartItem: Identifiable {}

// MARK: - Equatable
extension CartItem: Equatable {
    public static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        lhs.id == rhs.id
    }
} 