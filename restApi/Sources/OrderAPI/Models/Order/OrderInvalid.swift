import DataValidation

public enum OrderInvalid: Invalidated {
    case noUser
    
    public var errorMessage: String {
        switch self {
        case .noUser:
            return "Cant find user with this uuid"
        }
    }
}
