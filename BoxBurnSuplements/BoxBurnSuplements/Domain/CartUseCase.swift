import Foundation
import Combine

class CartUseCase {
    private let repository: SupplementRepository
    
    init(repository: SupplementRepository) {
        self.repository = repository
    }
    
    func addToCart(_ supplement: Supplement, quantity: Int = 1) -> AnyPublisher<Void, Error> {
        return repository.addToCart(supplement, quantity: quantity)
    }
    
    func removeFromCart(_ supplement: Supplement) -> AnyPublisher<Void, Error> {
        return repository.removeFromCart(supplement)
    }
    
    func updateQuantity(_ supplement: Supplement, quantity: Int) -> AnyPublisher<Void, Error> {
        return repository.updateCartQuantity(supplement, quantity: quantity)
    }
    
    func getCartItems() -> AnyPublisher<[CartItem], Error> {
        return repository.getCartItems()
    }
    
    func clearCart() -> AnyPublisher<Void, Error> {
        return repository.clearCart()
    }
} 