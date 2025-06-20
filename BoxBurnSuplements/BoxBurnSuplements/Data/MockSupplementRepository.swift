import Foundation
import Combine

// Import MockDataLoader for shared types and loader
// (No explicit import needed if in same module, but clarify usage)

public class MockSupplementRepository: SupplementRepository {
    public internal(set) var supplements: [Supplement] = []
    private var categories: [SupplementCategory] = []
    public internal(set) var favorites: Set<UUID> = []
    public internal(set) var cart: [CartItem] = []
    
    public init() {
        do {
            let mockData = try loadMockData()
            self.categories = mockData.categories
            self.supplements = mockData.supplements.map { s in
                Supplement(
                    name: s.name,
                    description: s.description,
                    price: s.price,
                    imageName: s.imageName,
                    category: s.category
                )
            }
        } catch {
            print("[MockSupplementRepository] Error loading mock data: \(error)")
            self.categories = []
            self.supplements = []
        }
    }
    
    public func fetchSupplements() -> AnyPublisher<[Supplement], Error> {
        Just(supplements)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    func fetchCategories() -> AnyPublisher<[SupplementCategory], Error> {
        Just([SupplementCategory.all] + categories)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    public func toggleFavorite(_ supplement: Supplement) -> AnyPublisher<Void, Error> {
        if favorites.contains(supplement.id) {
            favorites.remove(supplement.id)
        } else {
            favorites.insert(supplement.id)
        }
        if let idx = supplements.firstIndex(where: { $0.id == supplement.id }) {
            supplements[idx].isFavorite.toggle()
        }
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    public func getFavorites() -> AnyPublisher<[Supplement], Error> {
        let favs = supplements.filter { favorites.contains($0.id) || $0.isFavorite }
        return Just(favs)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    public func addToCart(_ supplement: Supplement, quantity: Int) -> AnyPublisher<Void, Error> {
        if let idx = cart.firstIndex(where: { $0.supplementId == supplement.id }) {
            cart[idx].quantity += quantity
        } else {
            let item = CartItem(supplementId: supplement.id, quantity: quantity)
            item.supplement = supplement
            cart.append(item)
        }
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    public func removeFromCart(_ supplement: Supplement) -> AnyPublisher<Void, Error> {
        cart.removeAll { $0.supplementId == supplement.id }
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    public func updateCartQuantity(_ supplement: Supplement, quantity: Int) -> AnyPublisher<Void, Error> {
        if let idx = cart.firstIndex(where: { $0.supplementId == supplement.id }) {
            cart[idx].quantity = quantity
        }
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    public func getCartItems() -> AnyPublisher<[CartItem], Error> {
        Just(cart)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    public func clearCart() -> AnyPublisher<Void, Error> {
        cart.removeAll()
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    public func syncWithBackend() -> AnyPublisher<Void, Error> {
        // No-op for mock
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    // New for categories
    func fetchAllCategories() -> [SupplementCategory] {
        [SupplementCategory.all] + categories
    }
}

// Use the loader from MockDataLoader
private func loadMockData() throws -> MockData {
    let bundle = resourceBundle()
    print("[MockSupplementRepository] Using bundle: \(bundle.bundlePath)")
    guard let url = bundle.url(forResource: "mock_data", withExtension: "json") else {
        print("[MockSupplementRepository] mock_data.json not found in bundle: \(bundle.bundlePath)")
        throw MockDataError.fileNotFound
    }
    print("[MockSupplementRepository] Found mock_data.json at: \(url.path)")
    let data = try Data(contentsOf: url)
    do {
        let mockData = try JSONDecoder().decode(MockData.self, from: data)
        print("[MockSupplementRepository] Successfully decoded mock_data.json")
        return mockData
    } catch {
        print("[MockSupplementRepository] Failed to decode mock_data.json: \(error)")
        throw MockDataError.decodingError(error)
    }
}

private func resourceBundle() -> Bundle {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    // Try test bundle first, then main
    let testBundle = Bundle.allBundles.first(where: { $0.bundlePath.hasSuffix(".xctest") })
    return testBundle ?? Bundle.main
    #endif
}

enum MockDataError: Error, CustomStringConvertible {
    case fileNotFound
    case decodingError(Error)
    
    var description: String {
        switch self {
        case .fileNotFound:
            return "mock_data.json not found in bundle."
        case .decodingError(let error):
            return "Failed to decode mock_data.json: \(error)"
        }
    }
} 