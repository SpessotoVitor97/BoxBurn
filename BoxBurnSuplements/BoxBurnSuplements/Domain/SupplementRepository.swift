import Foundation
import Combine
import SwiftData

protocol SupplementRepository {
    func fetchSupplements() -> AnyPublisher<[Supplement], Error>
    func toggleFavorite(_ supplement: Supplement) -> AnyPublisher<Void, Error>
    func getFavorites() -> AnyPublisher<[Supplement], Error>
    func addToCart(_ supplement: Supplement, quantity: Int) -> AnyPublisher<Void, Error>
    func removeFromCart(_ supplement: Supplement) -> AnyPublisher<Void, Error>
    func updateCartQuantity(_ supplement: Supplement, quantity: Int) -> AnyPublisher<Void, Error>
    func getCartItems() -> AnyPublisher<[CartItem], Error>
    func clearCart() -> AnyPublisher<Void, Error>
    func syncWithBackend() -> AnyPublisher<Void, Error>
} 