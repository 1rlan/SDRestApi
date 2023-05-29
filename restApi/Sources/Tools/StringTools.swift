import Foundation

extension String {
    public func isEmail() -> Bool {
        return emailPredicate.evaluate(with: self)
    }
    
    public func getMissingValidation() -> [String] {
        var errors = [String]() 
        if (!NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: self)) {
            errors.append("Least one uppercase")
        }
        
        if (!NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: self)) {
            errors.append("Least one digit")
        }

        if (!NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: self)) {
            errors.append("Least one symbol")
        }
        
        if (!NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: self)){
            errors.append("Least one lowercase")
        }
        
        if (count < 8) {
            errors.append("Min 8 characters total")
        }
        
        return errors
    }
}
        
private let leftPart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
private let serverPart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
private let emailRegex = leftPart + "@" + serverPart + "[A-Za-z]{2,8}"
private let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
