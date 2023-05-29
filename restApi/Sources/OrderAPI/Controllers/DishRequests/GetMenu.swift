import Vapor
import Fluent
import JWT

import UserJWT

extension DishesController {
    func getMenuRequest(_ req: Request) async throws -> [Dish] {
        let userJWT = try req.jwt.verify(as: UserJWT.self)
        try userJWT.verifyDate()
        
        let dishes = try await Dish.query(on: req.db)
            .filter(\.$quantity > 0)
            .all()
   
        return dishes
    }
}
