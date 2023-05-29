import Vapor
import Fluent

import UserJWT

extension DishesController {
    func postDishRequest(_ req: Request) async throws -> Dish {
        let userJWT = try req.jwt.verify(as: UserJWT.self)
        try userJWT.verify(with: .chef)
        try userJWT.verifyDate()
        
        let dish = try req.content.decode(Dish.self)
        try dish.validate(application: application)
        
        try await dish.save(on: req.db)
        return dish
    }
}
