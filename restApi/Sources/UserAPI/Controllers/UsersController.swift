import Fluent
import Vapor

import CommonModels
import DataValidation
import UserJWT

struct UsersController: RouteCollection {
    let application: Application
    let decoder = JSONDecoder()
    
    func boot(routes: RoutesBuilder) throws {
        let signGroup = routes.grouped("user", "signUp")
        let userDataGroup = routes.grouped("user", "data")
        
        signGroup.post(use: createHandler)
        userDataGroup.get(use: getHandler)
    }
    
    func createHandler(_ req: Request) async throws -> User {
        let user = try req.content.decode(User.self)
        try await user.validate(application: application)
        
        user.hashPassword()
        
        try await user.save(on: req.db)
        return user
    }
    
    func getHandler(_ req: Request) async throws -> [String: String] {
        let userJWT = try req.jwt.verify(as: UserJWT.self)
        try userJWT.verifyDate()
        
        guard let user = try await User.find(userJWT.userId, on: req.db) else {
            let problem = UserInvalid.noId
            let invalidData = InvalidResponseData(with: problem, status: 403)
            throw invalidData.abort
        }
        
        return [
            "username": user.username,
            "email": user.email,
            "role": user.role.rawValue
        ]
    }
}
