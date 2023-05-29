import Foundation
import JWT

import CommonModels

public struct UserJWT: Codable {
    public init(role: User.Role, expiration: ExpirationClaim, userId: UUID) {
        self.role = role
        self.expiration = expiration
        self.userId = userId
    }
    
    public let role: User.Role
    public let expiration: ExpirationClaim
    public let userId: UUID
    
    public enum CodingKeys: String, CodingKey {
        case expiration = "exp"
        case role = "rol"
        case userId = "uid"
    }
}
