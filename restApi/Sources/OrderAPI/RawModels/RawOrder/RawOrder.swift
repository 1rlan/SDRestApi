import Foundation

final class RawOrder: Codable {
    var specialRequests: String?
    var dishes: [RawDish]
    
    func makeOrder(with userId: UUID) -> Order {
        Order(userId: userId, status: .waiting, specialRequests: specialRequests)
    }
}

