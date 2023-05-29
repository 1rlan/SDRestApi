import Fluent
import Vapor
import JWT

import CommonModels
import UserJWT

struct OrdersController: RouteCollection {
    let decoder = JSONDecoder()
    let application: Application
    
    func boot(routes: RoutesBuilder) throws {
        let makeOrder = routes.grouped("order", "make")
        let orderDate = routes.grouped("order")
        
        makeOrder.post(use: postOrder)
        orderDate.get(use: getOrder)
    }
    
    func postOrder(_ req: Request) async throws -> Order {
        let userJWT = try req.jwt.verify(as: UserJWT.self)
        try userJWT.verifyDate()
        
        let rawOrder = try req.content.decode(RawOrder.self, using: decoder)
        try await rawOrder.validate(application: application)
        
        let order = rawOrder.makeOrder(with: userJWT.userId)
        try await order.validate(application: application)
        
        try await order.save(on: req.db)
        
        for dish in rawOrder.dishes {
            guard let dishDB = try await Dish.query(on: req.db).filter(\.$name == dish.name).first() else {
                continue
            }
            
            let dishOrder = OrderDish(
                orderId: order.id!,
                dishId: dishDB.id!,
                quantity: dish.count,
                price: dishDB.price * dish.count
            )
            
            try await dishDB.quantityReduction(for: dish.count, database: req.db)
            try await dishOrder.save(on: req.db)
        }
        
        order.startProcessing(database: req.db)
        
        return order
    }
    
    func getOrder(_ req: Request) async throws -> [String: String] {
        let userJWT = try req.jwt.verify(as: UserJWT.self)
        try userJWT.verifyDate()
        
        
        let rawUUID = try req.content.decode(RawUUID.self, using: decoder)
        guard let order = try await Order.find(rawUUID.id, on: req.db) else {
            throw rawUUID.abort(with: .noUUID)
        }
        
        guard userJWT.userId == order.userId else {
            throw Abort(.forbidden, reason: "It is not your order")
        }
        
        let user = try await User.find(order.userId, on: req.db)
        let orderDishes = try await OrderDish.query(on: req.db).filter(\.$orderId == order.id!).all()
        
        var dishesNames = [String]()
        var orderValue = 0
    
        for orderDish in orderDishes {
            if let dish = try await Dish.find(orderDish.dishId, on: req.db) {
                dishesNames.append("\(dish.name) x\(orderDish.quantity)")
                orderValue += orderDish.price
            }
        }
        
        return [
            "status": order.status.rawValue,
            "specialRequests": order.specialRequests ?? "-",
            "user": user?.username ?? "username",
            "orderValue": String(orderValue),
            "dishes": dishesNames.joined(separator: ", ")
        ]
    }
}
