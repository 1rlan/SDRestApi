import Fluent
import Vapor

final class Session: Model, Content {
    static var schema: String = "sessions"
    
    @ID(custom: .id)
    var id: UUID?

    @Field(key: "user_id")
    var user_id: UUID
    
    @Field(key: "session_token")
    var session_token: String
    
    @Field(key: "expires_at")
    var expires_at: Date
    
    init() {}
    
    internal init(id: UUID? = nil, user_id: UUID, session_token: String, expires_at: Date) {
        self.id = id
        self.user_id = user_id
        self.session_token = session_token
        self.expires_at = expires_at
    }
}
