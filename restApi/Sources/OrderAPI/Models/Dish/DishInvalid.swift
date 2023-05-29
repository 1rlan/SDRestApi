import DataValidation

enum DishInvalid: Invalidated {
    case invalidPrice
    case ivalidQuanity
    case invalidName
    case invalidDescription
    
    var errorMessage: String {
        switch self {
        case .invalidPrice:
            return "Price cant be negative or very big"
        case .ivalidQuanity:
            return "Quanity cant be negative or very big"
        case .invalidName:
            return "Name should not be empty"
        case .invalidDescription:
            return "Description should not be empty"
        }
    }
}
