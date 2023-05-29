import DataValidation

enum AuthenticationInvalid: Invalidated {
    case noUser
    
    var errorMessage: String {
        switch self {
        case .noUser:
            return "Invalid email or username"
        }
    }
}
