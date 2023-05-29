import DataValidation

public enum UserInvalid: Invalidated {
    case invalidEmail
    case emailExists
    case usernameExists
    case noId
    case invalidPassword
    
    
    public var errorMessage: String {
        switch self {
        case .invalidEmail:
            return "Invalid email"
        case .emailExists:
            return "Email exists"
        case .usernameExists:
            return "Username exists"
        case .noId:
            return "No user with this id"
        case .invalidPassword:
            return passwordWrong
        }
    }
}

fileprivate let passwordWrong = """
The password is wrong.
It must contain at least 8 characters, a number, a special character, a small uppercase letter
"""
