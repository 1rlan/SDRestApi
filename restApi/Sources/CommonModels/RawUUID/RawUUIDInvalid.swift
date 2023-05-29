import DataValidation

public enum RawUUIDInvalid: Invalidated {
    case noUUID
    case invalidValue
    
    public var errorMessage: String {
        switch self {
        case .noUUID:
            return "Nothing with such UUID"
        case .invalidValue:
            return "Value cant be negative or too big"
        }
    }
}
