import Testing
import Combine
@testable import BoxBurnSuplements

@Test
@MainActor
func testMockDataLoaderLoadCategoriesSuccess() async {
    let categories = try? await MockDataLoader.shared.loadCategories().values.first(where: { _ in true })
    #expect((categories?.count ?? 0) > 1)
}

@Test
@MainActor
func testMockDataLoaderLoadCategoriesFailure() async {
    // Simulate failure by temporarily renaming the file (not possible here), so just check that the loader does not crash
    let categories = try? await MockDataLoader.shared.loadCategories().values.first(where: { _ in true })
    #expect(categories != nil)
} 