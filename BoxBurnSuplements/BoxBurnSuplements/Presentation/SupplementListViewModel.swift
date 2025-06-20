import Foundation
import Combine
import SwiftData

final class SupplementListViewModel: ObservableObject {
    @Published var supplements: [Supplement] = []
    @Published var searchText: String = ""
    @Published private(set) var filteredSupplements: [Supplement] = []
    @Published var cartItems: [CartItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let fetchSupplementsUseCase: FetchSupplementsUseCase
    private let favoritesUseCase: FavoritesUseCase
    private let cartUseCase: CartUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // Computed properties
    var cartTotal: Double {
        cartItems.reduce(0) { $0 + ($1.supplement?.price ?? 0) * Double($1.quantity) }
    }
    
    var cartItemCount: Int {
        cartItems.count
    }
    
    var favoritesCount: Int {
        supplements.filter { $0.isFavorite }.count
    }
    
    var favorites: [Supplement] {
        supplements.filter { $0.isFavorite }
    }
    
    var featuredSupplements: [Supplement] {
        Array(supplements.prefix(5))
    }
    
    init(
        fetchSupplementsUseCase: FetchSupplementsUseCase,
        favoritesUseCase: FavoritesUseCase,
        cartUseCase: CartUseCase
    ) {
        self.fetchSupplementsUseCase = fetchSupplementsUseCase
        self.favoritesUseCase = favoritesUseCase
        self.cartUseCase = cartUseCase
        setupBindings()
        loadData()
    }
    
    private func setupBindings() {
        Publishers.CombineLatest($supplements, $searchText)
            .map { supplements, searchText in
                let filtered = searchText.isEmpty ? supplements : supplements.filter {
                    $0.name.localizedCaseInsensitiveContains(searchText) ||
                    $0.productDescription.localizedCaseInsensitiveContains(searchText)
                }
                return filtered
            }
            .assign(to: &$filteredSupplements)
    }
    
    private func loadData() {
        isLoading = true
        errorMessage = nil
        
        // Load supplements
        fetchSupplementsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] supplements in
                    self?.supplements = supplements
                }
            )
            .store(in: &cancellables)
        
        // Load cart items
        cartUseCase.getCartItems()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] cartItems in
                    self?.cartItems = cartItems
                }
            )
            .store(in: &cancellables)
    }
    
    func filteredSupplementsByCategory(category: SupplementCategory) -> [Supplement] {
        let filtered = filteredSupplements
        if category == .all {
            return filtered
        }
        
        switch category {
        case .protein:
            return filtered.filter { $0.category == "protein" }
        case .vitamins:
            return filtered.filter { $0.category == "vitamins" }
        case .preworkout:
            return filtered.filter { $0.category == "preworkout" }
        case .recovery:
            return filtered.filter { $0.category == "recovery" }
        case .all:
            return filtered
        }
    }
    
    func isFavorite(_ supplement: Supplement) -> Bool {
        supplement.isFavorite
    }
    
    func toggleFavorite(_ supplement: Supplement) {
        favoritesUseCase.toggleFavorite(supplement)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
    
    func addToCart(_ supplement: Supplement) {
        cartUseCase.addToCart(supplement, quantity: 1)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] _ in
                    // Refresh cart data after adding item
                    self?.refreshCartData()
                }
            )
            .store(in: &cancellables)
    }
    
    func removeFromCart(_ supplement: Supplement) {
        cartUseCase.removeFromCart(supplement)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] _ in
                    // Refresh cart data after removing item
                    self?.refreshCartData()
                }
            )
            .store(in: &cancellables)
    }
    
    func updateQuantity(for supplement: Supplement, quantity: Int) {
        cartUseCase.updateQuantity(supplement, quantity: quantity)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] _ in
                    // Refresh cart data after updating quantity
                    self?.refreshCartData()
                }
            )
            .store(in: &cancellables)
    }
    
    func getQuantity(for supplement: Supplement) -> Int {
        return cartItems.first { $0.supplementId == supplement.id }?.quantity ?? 0
    }
    
    func clearCart() {
        cartUseCase.clearCart()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] _ in
                    // Refresh cart data after clearing cart
                    self?.refreshCartData()
                }
            )
            .store(in: &cancellables)
    }
    
    private func refreshCartData() {
        cartUseCase.getCartItems()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] cartItems in
                    self?.cartItems = cartItems
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshData() {
        isLoading = true
        errorMessage = nil
        fetchSupplementsUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] supplements in
                    self?.supplements = supplements
                }
            )
            .store(in: &cancellables)
        cartUseCase.getCartItems()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] cartItems in
                    self?.cartItems = cartItems
                }
            )
            .store(in: &cancellables)
        favoritesUseCase.getFavorites()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] favorites in
                    // Update isFavorite for each supplement
                    for fav in favorites {
                        if let idx = self?.supplements.firstIndex(where: { $0.id == fav.id }) {
                            self?.supplements[idx].isFavorite = true
                        }
                    }
                }
            )
            .store(in: &cancellables)
    }
} 
