import Foundation
import SwiftData

@Model
public final class Supplement {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var productDescription: String
    public var price: Double
    public var imageName: String
    public var category: String
    public var isFavorite: Bool
    public var backendId: String?
    public var lastSynced: Date?
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        price: Double,
        imageName: String,
        category: String = "all",
        isFavorite: Bool = false,
        backendId: String? = nil,
        lastSynced: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.productDescription = description
        self.price = price
        self.imageName = imageName
        self.category = category
        self.isFavorite = isFavorite
        self.backendId = backendId
        self.lastSynced = lastSynced
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Equatable
extension Supplement: Equatable {
    public static func == (lhs: Supplement, rhs: Supplement) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Identifiable
extension Supplement: Identifiable {}

// MARK: - Hashable
extension Supplement: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
} 