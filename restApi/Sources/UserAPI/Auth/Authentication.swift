import Vapor
import Fluent

import CommonModels

struct Authentication: Content {
    let email: String
    let password: String
    var authUser: User?
    
    internal init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func getUser(in userDB: Database) async throws -> User? {
        let hashedPassword = password.getPasswordHash()
        let findedUser = try await User.query(on: userDB)
            .filter(\.$email == email)
            .filter(\.$password == hashedPassword)
            .first()
        
        return findedUser
    }
}
