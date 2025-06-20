import Foundation
import Combine

class FavoritesUseCase {
    private let repository: SupplementRepository
    
    init(repository: SupplementRepository) {
        self.repository = repository
    }
    
    func toggleFavorite(_ supplement: Supplement) -> AnyPublisher<Void, Error> {
        return repository.toggleFavorite(supplement)
    }
    
    func getFavorites() -> AnyPublisher<[Supplement], Error> {
        return repository.getFavorites()
    }
} 