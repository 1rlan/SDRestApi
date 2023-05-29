import Fluent
import Vapor

final class Order: Model, Content {
    static var schema: String = "orders"
    
    enum Status: String, Codable {
        case waiting, inProgress, declined, ready
        
        var interval: Int {
            switch self {
            case .inProgress:
                return 10
            case .ready:
                return Int.random(in: 10...60)
            default:
                return 0
            }
        }
    }
    
    @ID(custom: .id)
    var id: UUID?

    @Field(key: "user_id")
    var userId: UUID
    
    @Field(key: "status")
    var status: Status
    
    @Field(key: "special_requests")
    var specialRequests: String?

    init() {}

    internal init(
        id: UUID = UUID(),
        userId: UUID,
        status: Status,
        specialRequests: String?
    ) {
        self.id = id
        self.userId = userId
        self.status = status
        self.specialRequests = specialRequests
    }
}
