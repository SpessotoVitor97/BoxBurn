import Foundation
import Combine

// MARK: - API Models
struct FavoriteRequest: Codable {
    let supplementId: String
    let userId: String
    let isFavorite: Bool
}

struct CartItemRequest: Codable {
    let supplementId: String
    let quantity: Int
    let userId: String
}

struct CartItemResponse: Codable {
    let id: String
    let supplementId: String
    let quantity: Int
    let userId: String
    let createdAt: String
    let updatedAt: String
}

struct FavoriteResponse: Codable {
    let id: String
    let supplementId: String
    let userId: String
    let isFavorite: Bool
    let createdAt: String
    let updatedAt: String
}

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let message: String?
    let error: String?
}

// MARK: - Backend Service
class BackendService: ObservableObject {
    private let baseURL = "https://api.boxburn.com/v1" // Replace with your actual API URL
    private let session = URLSession.shared
    private var cancellables = Set<AnyCancellable>()
    
    // In a real app, you'd get this from authentication
    private let userId = "user_123"
    
    // MARK: - Favorites API
    func syncFavorites(_ supplements: [Supplement]) -> AnyPublisher<[Supplement], Error> {
        let favoriteSupplements = supplements.filter { $0.isFavorite }
        
        let requests = favoriteSupplements.map { supplement in
            FavoriteRequest(
                supplementId: supplement.backendId ?? supplement.id.uuidString,
                userId: userId,
                isFavorite: true
            )
        }
        
        return Publishers.MergeMany(
            requests.map { request in
                syncFavorite(request)
            }
        )
        .collect()
        .map { _ in supplements }
        .eraseToAnyPublisher()
    }
    
    private func syncFavorite(_ request: FavoriteRequest) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "\(baseURL)/favorites") else {
            return Fail(error: BackendError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            return Fail(error: BackendError.encodingError)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: APIResponse<FavoriteResponse>.self, decoder: JSONDecoder())
            .map { _ in () }
            .mapError { error in
                if error is DecodingError {
                    return BackendError.decodingError
                }
                return BackendError.networkError(error)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Cart API
    func syncCart(_ cartItems: [CartItem]) -> AnyPublisher<[CartItem], Error> {
        let requests = cartItems.map { cartItem in
            CartItemRequest(
                supplementId: cartItem.supplement?.backendId ?? cartItem.supplementId.uuidString,
                quantity: cartItem.quantity,
                userId: userId
            )
        }
        
        return Publishers.MergeMany(
            requests.map { request in
                syncCartItem(request)
            }
        )
        .collect()
        .map { responses in
            // Update cart items with backend IDs
            zip(cartItems, responses).map { cartItem, response in
                cartItem.backendId = response.id
                cartItem.lastSynced = Date()
                return cartItem
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func syncCartItem(_ request: CartItemRequest) -> AnyPublisher<CartItemResponse, Error> {
        guard let url = URL(string: "\(baseURL)/cart") else {
            return Fail(error: BackendError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            return Fail(error: BackendError.encodingError)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: APIResponse<CartItemResponse>.self, decoder: JSONDecoder())
            .compactMap { $0.data }
            .mapError { error in
                if error is DecodingError {
                    return BackendError.decodingError
                }
                return BackendError.networkError(error)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Favorites from Backend
    func fetchFavorites() -> AnyPublisher<[String], Error> {
        guard let url = URL(string: "\(baseURL)/favorites?userId=\(userId)") else {
            return Fail(error: BackendError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: APIResponse<[FavoriteResponse]>.self, decoder: JSONDecoder())
            .compactMap { $0.data }
            .map { favorites in
                favorites.filter { $0.isFavorite }.map { $0.supplementId }
            }
            .mapError { error in
                if error is DecodingError {
                    return BackendError.decodingError
                }
                return BackendError.networkError(error)
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Cart from Backend
    func fetchCart() -> AnyPublisher<[CartItemResponse], Error> {
        guard let url = URL(string: "\(baseURL)/cart?userId=\(userId)") else {
            return Fail(error: BackendError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: APIResponse<[CartItemResponse]>.self, decoder: JSONDecoder())
            .compactMap { $0.data }
            .mapError { error in
                if error is DecodingError {
                    return BackendError.decodingError
                }
                return BackendError.networkError(error)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Backend Errors
enum BackendError: LocalizedError {
    case invalidURL
    case encodingError
    case decodingError
    case networkError(Error)
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .encodingError:
            return "Failed to encode request"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        }
    }
} 