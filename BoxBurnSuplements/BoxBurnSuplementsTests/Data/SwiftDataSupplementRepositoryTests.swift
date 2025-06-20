import Testing
import Combine
import SwiftData
import Foundation
@testable import BoxBurnSuplements
// Use shared MockBackendService

func makeInMemoryContext() -> ModelContext {
    let container = try! ModelContainer(for: Supplement.self, CartItem.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    return ModelContext(container)
}

@Test
@MainActor
func testFetchSupplementsReturnsSupplements() async {
    let context = makeInMemoryContext()
    let backend = MockBackendService()
    let repo = SwiftDataSupplementRepository(modelContext: context, backendService: backend)
    let result = try? await repo.fetchSupplements().values.first(where: { _ in true })
    #expect(result != nil)
}

@Test
@MainActor
func testAddToCart() async {
    let context = makeInMemoryContext()
    let backend = MockBackendService()
    let repo = SwiftDataSupplementRepository(modelContext: context, backendService: backend)
    let supplement = Supplement(name: "Test", description: "", price: 1, imageName: "", category: "protein")
    let result = try? await repo.addToCart(supplement, quantity: 1).values.first(where: { _ in true })
    #expect(result != nil)
}

@Test
@MainActor
func testRemoveFromCart() async {
    let context = makeInMemoryContext()
    let backend = MockBackendService()
    let repo = SwiftDataSupplementRepository(modelContext: context, backendService: backend)
    let supplement = Supplement(name: "Test", description: "", price: 1, imageName: "", category: "protein")
    let result = try? await repo.removeFromCart(supplement).values.first(where: { _ in true })
    #expect(result != nil)
}

@Test
@MainActor
func testUpdateCartQuantity() async {
    let context = makeInMemoryContext()
    let backend = MockBackendService()
    let repo = SwiftDataSupplementRepository(modelContext: context, backendService: backend)
    let supplement = Supplement(name: "Test", description: "", price: 1, imageName: "", category: "protein")
    let result = try? await repo.updateCartQuantity(supplement, quantity: 2).values.first(where: { _ in true })
    #expect(result != nil)
}

@Test
@MainActor
func testGetCartItems() async {
    let context = makeInMemoryContext()
    let backend = MockBackendService()
    let repo = SwiftDataSupplementRepository(modelContext: context, backendService: backend)
    let result = try? await repo.getCartItems().values.first(where: { _ in true })
    #expect(result != nil)
}

@Test
@MainActor
func testClearCart() async {
    let context = makeInMemoryContext()
    let backend = MockBackendService()
    let repo = SwiftDataSupplementRepository(modelContext: context, backendService: backend)
    let result = try? await repo.clearCart().values.first(where: { _ in true })
    #expect(result != nil)
} 