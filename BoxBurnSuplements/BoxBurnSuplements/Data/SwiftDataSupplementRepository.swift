import Foundation
import Combine
import SwiftData

class SwiftDataSupplementRepository: SupplementRepository {
    private let modelContext: ModelContext
    private let backendService: BackendService
    private var cancellables = Set<AnyCancellable>()
    
    init(modelContext: ModelContext, backendService: BackendService) {
        self.modelContext = modelContext
        self.backendService = backendService
    }
    
    // MARK: - Supplements
    func fetchSupplements() -> AnyPublisher<[Supplement], Error> {
        let descriptor = FetchDescriptor<Supplement>()
        
        do {
            let supplements = try modelContext.fetch(descriptor)
            if supplements.isEmpty {
                // Load mock data if no supplements exist
                return loadMockData()
            }
            return Just(supplements)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    private func loadMockData() -> AnyPublisher<[Supplement], Error> {
        let mockSupplements = [
            Supplement(name: "Whey Protein Isolate", description: "High-quality protein powder for muscle building and recovery", price: 49.99, imageName: "protein1", category: "protein"),
            Supplement(name: "Creatine Monohydrate", description: "Pure creatine for strength and power gains", price: 24.99, imageName: "creatine1", category: "preworkout"),
            Supplement(name: "Vitamin D3", description: "Essential vitamin for bone health and immune support", price: 19.99, imageName: "vitamin1", category: "vitamins"),
            Supplement(name: "BCAA Powder", description: "Branched-chain amino acids for muscle recovery", price: 34.99, imageName: "bcaa1", category: "recovery"),
            Supplement(name: "Pre-Workout Formula", description: "Energy and focus blend for intense workouts", price: 39.99, imageName: "preworkout1", category: "preworkout"),
            Supplement(name: "Omega-3 Fish Oil", description: "Essential fatty acids for heart and brain health", price: 29.99, imageName: "omega1", category: "vitamins"),
            Supplement(name: "Casein Protein", description: "Slow-digesting protein for overnight muscle repair", price: 44.99, imageName: "protein2", category: "protein"),
            Supplement(name: "Glutamine Powder", description: "Amino acid for gut health and recovery", price: 27.99, imageName: "glutamine1", category: "recovery"),
            Supplement(name: "Multivitamin Complex", description: "Complete daily vitamin and mineral support", price: 22.99, imageName: "multivitamin1", category: "vitamins"),
            Supplement(name: "Beta-Alanine", description: "Carnosine precursor for endurance and performance", price: 18.99, imageName: "beta1", category: "preworkout")
        ]
        
        // Save to SwiftData
        for supplement in mockSupplements {
            modelContext.insert(supplement)
        }
        
        do {
            try modelContext.save()
            return Just(mockSupplements)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    // MARK: - Favorites
    func toggleFavorite(_ supplement: Supplement) -> AnyPublisher<Void, Error> {
        supplement.isFavorite.toggle()
        supplement.updatedAt = Date()
        
        do {
            try modelContext.save()
            
            // Sync with backend
            return backendService.syncFavorites([supplement])
                .map { _ in () }
                .mapError { error in
                    // Log error but don't fail the operation
                    print("Failed to sync favorite with backend: \(error)")
                    return error
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func getFavorites() -> AnyPublisher<[Supplement], Error> {
        let descriptor = FetchDescriptor<Supplement>(
            predicate: #Predicate<Supplement> { $0.isFavorite == true }
        )
        
        do {
            let favorites = try modelContext.fetch(descriptor)
            return Just(favorites)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    // MARK: - Cart
    func addToCart(_ supplement: Supplement, quantity: Int) -> AnyPublisher<Void, Error> {
        let supplementId = supplement.id
        let descriptor = FetchDescriptor<CartItem>(
            predicate: #Predicate<CartItem> { $0.supplementId == supplementId }
        )
        
        do {
            let existingItems = try modelContext.fetch(descriptor)
            
            if let existingItem = existingItems.first {
                existingItem.quantity += quantity
                existingItem.updatedAt = Date()
            } else {
                let cartItem = CartItem(
                    supplementId: supplementId,
                    quantity: quantity
                )
                cartItem.supplement = supplement
                modelContext.insert(cartItem)
            }
            
            try modelContext.save()
            
            // Sync with backend
            return syncCartWithBackend()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func removeFromCart(_ supplement: Supplement) -> AnyPublisher<Void, Error> {
        let supplementId = supplement.id
        let descriptor = FetchDescriptor<CartItem>(
            predicate: #Predicate<CartItem> { $0.supplementId == supplementId }
        )
        
        do {
            let items = try modelContext.fetch(descriptor)
            for item in items {
                modelContext.delete(item)
            }
            
            try modelContext.save()
            
            // Sync with backend
            return syncCartWithBackend()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func updateCartQuantity(_ supplement: Supplement, quantity: Int) -> AnyPublisher<Void, Error> {
        let supplementId = supplement.id
        let descriptor = FetchDescriptor<CartItem>(
            predicate: #Predicate<CartItem> { $0.supplementId == supplementId }
        )
        
        do {
            let items = try modelContext.fetch(descriptor)
            
            if let item = items.first {
                if quantity <= 0 {
                    modelContext.delete(item)
                } else {
                    item.quantity = quantity
                    item.updatedAt = Date()
                }
            }
            
            try modelContext.save()
            
            // Sync with backend
            return syncCartWithBackend()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func getCartItems() -> AnyPublisher<[CartItem], Error> {
        let descriptor = FetchDescriptor<CartItem>()
        
        do {
            let cartItems = try modelContext.fetch(descriptor)
            return Just(cartItems)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    func clearCart() -> AnyPublisher<Void, Error> {
        let descriptor = FetchDescriptor<CartItem>()
        
        do {
            let cartItems = try modelContext.fetch(descriptor)
            for item in cartItems {
                modelContext.delete(item)
            }
            
            try modelContext.save()
            
            // Sync with backend
            return syncCartWithBackend()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    // MARK: - Backend Sync
    func syncWithBackend() -> AnyPublisher<Void, Error> {
        return Publishers.Merge(
            syncFavoritesWithBackend(),
            syncCartWithBackend()
        )
        .collect()
        .map { _ in () }
        .eraseToAnyPublisher()
    }
    
    private func syncFavoritesWithBackend() -> AnyPublisher<Void, Error> {
        let descriptor = FetchDescriptor<Supplement>(
            predicate: #Predicate<Supplement> { $0.isFavorite == true }
        )
        
        do {
            let favorites = try modelContext.fetch(descriptor)
            return backendService.syncFavorites(favorites)
                .map { _ in () }
                .mapError { error in
                    print("Failed to sync favorites with backend: \(error)")
                    return error
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
    
    private func syncCartWithBackend() -> AnyPublisher<Void, Error> {
        let descriptor = FetchDescriptor<CartItem>()
        
        do {
            let cartItems = try modelContext.fetch(descriptor)
            return backendService.syncCart(cartItems)
                .map { _ in () }
                .mapError { error in
                    print("Failed to sync cart with backend: \(error)")
                    return error
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
} 