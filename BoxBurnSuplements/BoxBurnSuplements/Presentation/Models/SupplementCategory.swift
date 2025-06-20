import Foundation

public enum SupplementCategory: String, CaseIterable, Codable {
    case all
    case protein
    case vitamins
    case preworkout
    case recovery
    
    public var displayName: String {
        switch self {
        case .all: return NSLocalizedString("category_all", comment: "All")
        case .protein: return NSLocalizedString("category_protein", comment: "Protein")
        case .vitamins: return NSLocalizedString("category_vitamins", comment: "Vitamins")
        case .preworkout: return NSLocalizedString("category_preworkout", comment: "Pre-Workout")
        case .recovery: return NSLocalizedString("category_recovery", comment: "Recovery")
        }
    }
} 