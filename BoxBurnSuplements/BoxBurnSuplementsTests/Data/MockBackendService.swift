import Combine
@testable import BoxBurnSuplements

class MockBackendService: BackendService {
    override func syncCart(_ cartItems: [CartItem]) -> AnyPublisher<[CartItem], Error> {
        return Just(cartItems)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    override func fetchFavorites() -> AnyPublisher<[String], Error> {
        return Just(["mock-supplement-id"])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    override func fetchCart() -> AnyPublisher<[CartItemResponse], Error> {
        let mockCart = [
            CartItemResponse(
                id: "mock-cart-id",
                supplementId: "mock-supplement-id",
                quantity: 1,
                userId: "user_123",
                createdAt: "",
                updatedAt: ""
            )
        ]
        return Just(mockCart)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
} 