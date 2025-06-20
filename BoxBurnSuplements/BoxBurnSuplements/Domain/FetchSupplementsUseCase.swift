import Foundation
import Combine

class FetchSupplementsUseCase {
    private let repository: SupplementRepository
    
    init(repository: SupplementRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Supplement], Error> {
        return repository.fetchSupplements()
    }
} 