import Vapor
import Fluent
import JWT

import CommonModels
import DataValidation
import UserJWT

extension DishesController {
    private enum DishValue {
        case price, quantity
         
        func validate(for value: Int) -> Bool {
            value > 0 && value < maxValue
        }
        
        private var maxValue: Int {
            switch self {
            case .price:
                return 5000
            case .quantity:
                return 200
            }
        }
    }
    
    func postPriceRequest(_ req: Request) async throws -> Dish {
        let (dish, newValue) = try await validateRequest(request: req, for: .price)
        dish.price = newValue
        try await dish.save(on: req.db)
        return dish
    }
    
    func postQuantityRequest(_ req: Request) async throws -> Dish {
        let (dish, newValue) = try await validateRequest(request: req, for: .quantity)
        dish.quantity = newValue
        try await dish.save(on: req.db)
        return dish
    }
    
    
    private func validateRequest(request: Request, for value: DishValue) async throws -> (Dish, Int) {
        try validateJWT(jwt: request.jwt)
        
        let rawUUID = try request.content.decode(RawUUIDWithValue.self, using: decoder)
        
        guard let dish = try await Dish.find(rawUUID.id, on: request.db) else {
            throw rawUUID.abort(with: .noUUID)
        }
        
        guard value.validate(for: rawUUID.newValue) else {
            throw rawUUID.abort(with: .invalidValue)
        }
        
        return (dish, rawUUID.newValue)
    }
    
    private func validateJWT(jwt: Request.JWT) throws {
        let userJWT = try jwt.verify(as: UserJWT.self)
        try userJWT.verify(with: .manager)
        try userJWT.verifyDate()
    }
}
