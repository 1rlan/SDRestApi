import Fluent
import Vapor
import JWT

import UserJWT
import Tools

struct AuthenticationController: RouteCollection {
    let application: Application
    
    func boot(routes: RoutesBuilder) throws {
        let usersGroup = routes.grouped("user", "signIn")
        usersGroup.post(use: createHandler)
    }
    
    func createHandler(_ req: Request) async throws -> [String: String] {
        let auth = try req.content.decode(Authentication.self)
        try await auth.validate(application: application)
        
        let user = try await auth.getUser(in: req.db)!
        
        let payload = UserJWT(
            role: user.role,
            expiration: ExpirationClaim.oneDay(),
            userId: user.id!
        )
        
        let sessionToken = try req.jwt.sign(payload)
        
        let session = Session(
            user_id: user.id!,
            session_token: sessionToken,
            expires_at: payload.expiration.value
        )
        
        try await session.save(on: req.db)
        
        return [
            "token": sessionToken
        ]
    }
}
