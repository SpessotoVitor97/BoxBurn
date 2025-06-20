import Testing
import Combine
@testable import BoxBurnSuplements

@Test
@MainActor
func testFavoritesUseCaseToggleFavorite() async {
    let repository = MockSupplementRepository()
    let useCase = FavoritesUseCase(repository: repository)
    let supplement = repository.supplements.first!
    _ = try? await useCase.toggleFavorite(supplement).values.first(where: { _ in true })
    #expect(repository.favorites.contains(supplement.id))
}

@Test
@MainActor
func testFavoritesUseCaseGetFavorites() async {
    let repository = MockSupplementRepository()
    let useCase = FavoritesUseCase(repository: repository)
    let supplement = repository.supplements.first!
    _ = try? await useCase.toggleFavorite(supplement).values.first(where: { _ in true })
    let favorites = try? await useCase.getFavorites().values.first(where: { _ in true })
    #expect(favorites?.contains(where: { $0.id == supplement.id }) == true)
} 