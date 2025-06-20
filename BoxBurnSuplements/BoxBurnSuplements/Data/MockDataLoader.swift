import Foundation
import Combine

public class MockDataLoader {
    public static let shared = MockDataLoader()
    private init() {}
    
    public func loadCategories() -> AnyPublisher<[SupplementCategory], Error> {
        Future { [self] promise in
            let bundle = self.resourceBundle()
            print("[MockDataLoader] Using bundle: \(bundle.bundlePath)")
            guard let url = bundle.url(forResource: "mock_data", withExtension: "json") else {
                print("[MockDataLoader] mock_data.json not found in bundle: \(bundle.bundlePath)")
                promise(.failure(MockDataLoaderError.fileNotFound))
                return
            }
            print("[MockDataLoader] Found mock_data.json at: \(url.path)")
            do {
                let decoder = JSONDecoder()
                let mockData = try decoder.decode(MockData.self, from: Data(contentsOf: url))
                print("[MockDataLoader] Successfully decoded mock_data.json")
                promise(.success(mockData.categories))
            } catch {
                print("[MockDataLoader] Failed to decode mock_data.json: \(error)")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    private func resourceBundle() -> Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        let testBundle = Bundle.allBundles.first(where: { $0.bundlePath.hasSuffix(".xctest") })
        return testBundle ?? Bundle.main
        #endif
    }
}

public enum MockDataLoaderError: Error {
    case fileNotFound
}

struct MockData: Decodable {
    let categories: [SupplementCategory]
    let supplements: [SupplementJSON]
}

struct SupplementJSON: Decodable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let imageName: String
    let category: String
} 