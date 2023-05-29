import Vapor
import Fluent

import DataValidation
import CommonModels
import Tools

extension Order: DataValidation.Validatable {
    func validate(application: Application) async throws {
        let userDB = application.db.query(User.self)
        
        try await checkUsernameExists(in: userDB)
    }
    
    private func checkUsernameExists(in database: QueryBuilder<User>) async throws {
        guard try await User.find(userId, on: database.database) != nil else {
            let problem = OrderInvalid.noUser
            let invalidData = InvalidResponseData(with: problem)
            throw invalidData.abort
        }
    }
}
