import Fluent
import Vapor

import Tools

public final class User: Model, Content, PasswordHashable {
    public static let schema = "users"
    
    public enum Role: String, Codable {
        case customer, manager, chef
        
        public func verify(to role: Role) -> Bool {
            access >= role.access
        }
        
        private var access: Int {
            switch self {
                case .customer: return 0
                case .manager: return 1
                case .chef: return 2
            }
        }
    }
    
    @ID(custom: .id)
    public var id: UUID?

    @Field(key: "username")
    public var username: String
    
    @Field(key: "email")
    public var email: String
    
    @Field(key: "password_hash")
    public var password: String
    
    @Field(key: "role")
    public var role: Role
    
    public func hashPassword() {
        password.hashPassword()
    }
    
    public init() { }

    public init(id: UUID? = nil, username: String, email: String, password: String, role: User.Role) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.role = role
    }
}
