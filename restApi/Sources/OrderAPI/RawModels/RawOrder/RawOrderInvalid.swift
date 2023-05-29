import DataValidation

public enum RawOrderInvalid: Invalidated {
    case invalidPosition
    case invalidNumberOfDishes
    case noDishes
    
    public var errorMessage: String {
        switch self {
        case .invalidPosition:
            return "Incorrect order position"
        case .invalidNumberOfDishes:
            return "There are not enough meals"
        case .noDishes:
            return "You order is empty"
        }
    }
}
