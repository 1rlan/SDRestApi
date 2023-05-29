import DataValidation

enum UserJWTInvalid: Invalidated {
    case noAccess
    
    var errorMessage: String {
        switch self {
            case .noAccess: return "No access with you role"
        }
    }
}
