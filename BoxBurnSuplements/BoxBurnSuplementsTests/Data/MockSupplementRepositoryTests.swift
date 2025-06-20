import Testing
import Combine
@testable import BoxBurnSuplements

@Test
@MainActor
func testMockSupplementRepositoryFetchSupplements() async {
    let repository = MockSupplementRepository()
    let supplements = try? await repository.fetchSupplements().values.first(where: { _ in true })
    #expect((supplements?.isEmpty == false))
}

@Test
@MainActor
func testMockSupplementRepositoryFetchCategories() async {
    let repository = MockSupplementRepository()
    let categories = try? await repository.fetchCategories().values.first(where: { _ in true })
    #expect((categories?.count ?? 0) > 1)
}

@Test
@MainActor
func testMockSupplementRepositoryToggleFavorite() async {
    let repository = MockSupplementRepository()
    let supplement = repository.supplements.first!
    _ = try? await repository.toggleFavorite(supplement).values.first(where: { _ in true })
    #expect(repository.favorites.contains(supplement.id))
}

@Test
@MainActor
func testMockSupplementRepositoryAddToCart() async {
    let repository = MockSupplementRepository()
    let supplement = repository.supplements.first!
    _ = try? await repository.addToCart(supplement, quantity: 2).values.first(where: { _ in true })
    #expect(repository.cart.first?.quantity == 2)
}

@Test
@MainActor
func testMockSupplementRepositoryClearCart() async {
    let repository = MockSupplementRepository()
    let supplement = repository.supplements.first!
    _ = try? await repository.addToCart(supplement, quantity: 1).values.first(where: { _ in true })
    _ = try? await repository.clearCart().values.first(where: { _ in true })
    #expect(repository.cart.isEmpty)
} 