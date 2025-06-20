import Testing
import Combine
@testable import BoxBurnSuplements

@Test
@MainActor
func testViewModelFilterByCategory() async {
    let repository = MockSupplementRepository()
    let fetchUseCase = FetchSupplementsUseCase(repository: repository)
    let favUseCase = FavoritesUseCase(repository: repository)
    let cartUseCase = CartUseCase(repository: repository)
    let viewModel = SupplementListViewModel(fetchSupplementsUseCase: fetchUseCase, favoritesUseCase: favUseCase, cartUseCase: cartUseCase)
    try? await Task.sleep(nanoseconds: 200_000_000)
    let all = SupplementCategory.all
    let protein = SupplementCategory.protein
    let allSupps = viewModel.filteredSupplementsByCategory(category: all)
    let proteinSupps = viewModel.filteredSupplementsByCategory(category: protein)
    #expect(allSupps.count > 0)
    #expect(proteinSupps.allSatisfy { $0.category == "protein" })
}

@Test
@MainActor
func testViewModelToggleFavorite() async {
    let repository = MockSupplementRepository()
    let fetchUseCase = FetchSupplementsUseCase(repository: repository)
    let favUseCase = FavoritesUseCase(repository: repository)
    let cartUseCase = CartUseCase(repository: repository)
    let viewModel = SupplementListViewModel(fetchSupplementsUseCase: fetchUseCase, favoritesUseCase: favUseCase, cartUseCase: cartUseCase)
    try? await Task.sleep(nanoseconds: 200_000_000)
    let supplement = viewModel.supplements.first
    #expect(supplement != nil)
    guard let supplement = supplement else { return }
    viewModel.toggleFavorite(supplement)
    try? await Task.sleep(nanoseconds: 200_000_000)
    #expect(repository.favorites.contains(supplement.id))
}

@Test
@MainActor
func testViewModelAddToCart() async {
    let repository = MockSupplementRepository()
    let fetchUseCase = FetchSupplementsUseCase(repository: repository)
    let favUseCase = FavoritesUseCase(repository: repository)
    let cartUseCase = CartUseCase(repository: repository)
    let viewModel = SupplementListViewModel(fetchSupplementsUseCase: fetchUseCase, favoritesUseCase: favUseCase, cartUseCase: cartUseCase)
    try? await Task.sleep(nanoseconds: 200_000_000)
    let supplement = viewModel.supplements.first
    #expect(supplement != nil)
    guard let supplement = supplement else { return }
    viewModel.addToCart(supplement)
    try? await Task.sleep(nanoseconds: 200_000_000)
    #expect(repository.cart.first?.quantity == 1)
} 