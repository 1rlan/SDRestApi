import Vapor
import Fluent
import JWT

import CommonModels
import UserJWT

extension DishesController {
    func deleteDishRequest(_ req: Request) async throws -> Dish {
        let userJWT = try req.jwt.verify(as: UserJWT.self)
        try userJWT.verifyDate()
        try userJWT.verify(with: .chef)
        
        let rawUUID = try req.content.decode(RawUUID.self, using: decoder)
        guard let dish = try await Dish.find(rawUUID.id, on: req.db) else {
            throw rawUUID.abort(with: .noUUID)
        }
        
        try await dish.delete(on: req.db)
        return dish
    }
}
