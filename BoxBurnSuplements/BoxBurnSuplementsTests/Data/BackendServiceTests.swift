import Testing
import Combine
@testable import BoxBurnSuplements
// Use shared MockBackendService

@Test
@MainActor
func testSyncFavorites() async {
    let backend = MockBackendService()
    let supplements: [Supplement] = []
    let result = try? await backend.syncFavorites(supplements).values.first(where: { _ in true })
    #expect(result != nil)
}

@Test
@MainActor
func testFetchFavorites() async {
    let backend = MockBackendService()
    let result = try? await backend.fetchFavorites().values.first(where: { _ in true })
    #expect(result != nil)
}

@Test
@MainActor
func testFetchCart() async {
    let backend = MockBackendService()
    let result = try? await backend.fetchCart().values.first(where: { _ in true })
    #expect(result != nil)
} 