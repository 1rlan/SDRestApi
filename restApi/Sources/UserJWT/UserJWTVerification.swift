import Vapor
import JWT

import CommonModels
import DataValidation

extension UserJWT: JWTPayload {
    public func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
    
    public func verifyDate() throws {
        try self.expiration.verifyNotExpired()
    }
    
    public func verify(with accessRole: User.Role) throws {
        guard role.verify(to: accessRole) else {
            let problem = UserJWTInvalid.noAccess
            let invalidData = InvalidResponseData(with: problem, status: 403)
            throw invalidData.abort
        }
    }
}
