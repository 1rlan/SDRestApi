import Vapor
import Fluent

import DataValidation

extension User: DataValidation.Validatable {
    public func validate(application: Application) async throws {
        let userDB = application.db.query(User.self)
        try checkEmail()
        try checkPassword()
        try await checkEmailExists(in: userDB)
        try await checkUsernameExists(in: userDB)
    }
    
    private func checkEmail() throws {
        guard email.isEmail() else {
            let problem = UserInvalid.invalidEmail
            let invalidData = InvalidResponseData(with: problem)
            throw invalidData.abort
        }
    }
    
    private func checkPassword() throws {
        let passwordErrors = password.getMissingValidation()
        guard passwordErrors.isEmpty else {
            let problem = UserInvalid.invalidPassword
            let invalidData = InvalidResponseData(with: problem)
            throw invalidData.abort
        }
    }
    
    private func checkEmailExists(in userDB: QueryBuilder<User>) async throws {
        guard try await userDB
            .filter(\.$email == email)
            .first() == nil else {
            let problem = UserInvalid.emailExists
            let invalidData = InvalidResponseData(with: problem)
            throw invalidData.abort
        }
    }
    
    private func checkUsernameExists(in userDB: QueryBuilder<User>) async throws {
        guard try await userDB
            .filter(\.$username == username)
            .first() == nil else {
            let problem = UserInvalid.usernameExists
            let invalidData = InvalidResponseData(with: problem)
            throw invalidData.abort
        }
    }
}

