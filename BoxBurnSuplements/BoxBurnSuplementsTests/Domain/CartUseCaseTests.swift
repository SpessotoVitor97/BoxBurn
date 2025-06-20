import Testing
import Combine
@testable import BoxBurnSuplements

@Test
@MainActor
func testCartUseCaseAddToCart() async {
    let repository = MockSupplementRepository()
    let useCase = CartUseCase(repository: repository)
    let supplement = repository.supplements.first!
    _ = try? await useCase.addToCart(supplement, quantity: 2).values.first(where: { _ in true })
    #expect(repository.cart.first?.quantity == 2)
}

@Test
@MainActor
func testCartUseCaseRemoveFromCart() async {
    let repository = MockSupplementRepository()
    let useCase = CartUseCase(repository: repository)
    let supplement = repository.supplements.first!
    _ = try? await useCase.addToCart(supplement, quantity: 1).values.first(where: { _ in true })
    _ = try? await useCase.removeFromCart(supplement).values.first(where: { _ in true })
    #expect(repository.cart.isEmpty)
}

@Test
@MainActor
func testCartUseCaseUpdateQuantity() async {
    let repository = MockSupplementRepository()
    let useCase = CartUseCase(repository: repository)
    let supplement = repository.supplements.first!
    _ = try? await useCase.addToCart(supplement, quantity: 1).values.first(where: { _ in true })
    _ = try? await useCase.updateQuantity(supplement, quantity: 5).values.first(where: { _ in true })
    #expect(repository.cart.first?.quantity == 5)
}

@Test
@MainActor
func testCartUseCaseClearCart() async {
    let repository = MockSupplementRepository()
    let useCase = CartUseCase(repository: repository)
    let supplement = repository.supplements.first!
    _ = try? await useCase.addToCart(supplement, quantity: 1).values.first(where: { _ in true })
    _ = try? await useCase.clearCart().values.first(where: { _ in true })
    #expect(repository.cart.isEmpty)
} 