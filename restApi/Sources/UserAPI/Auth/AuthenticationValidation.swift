import Vapor
import Fluent

import CommonModels
import DataValidation

extension Authentication: DataValidation.Validatable {
    func validate(application: Application) async throws {
        let userDB = application.db.query(User.self).database

        try await checkForUser(in: userDB)
    }
    
    private func checkForUser(in userDB: Database) async throws {
        guard try await getUser(in: userDB) != nil else {
            let problem = AuthenticationInvalid.noUser
            let invalidData = InvalidResponseData(with: problem)
            throw invalidData.abort
        }
    }
}
