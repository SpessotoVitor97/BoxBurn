import Testing
import Combine
@testable import BoxBurnSuplements

@Test
@MainActor
func testFetchSupplementsUseCaseFetchSupplements() async {
    let repository = MockSupplementRepository()
    let useCase = FetchSupplementsUseCase(repository: repository)
    let supplements = try? await useCase.execute().values.first(where: { _ in true })
    #expect((supplements?.isEmpty == false))
} 