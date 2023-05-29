import Vapor
import Fluent

import DataValidation

extension RawOrder: DataValidation.Validatable {
    func validate(application: Application) async throws {
        let dishDB = application.db.query(Dish.self)
        
        try checkDishesCount()
        try await checkDishesComposition(in: dishDB)
    }
    
    private func checkDishesCount() throws {
        guard !dishes.isEmpty else {
            let problem = RawOrderInvalid.noDishes
            let invalidData = InvalidResponseData(with: problem)
            throw invalidData.abort
        }
    }
    
    private func checkDishesComposition(in database: QueryBuilder<Dish>) async throws {
        let dishesDB = try await database.all()
        
        for dish in dishes {
            guard let dishInDB = dishesDB.first(where: { dbDish in
                dbDish.name == dish.name
            }) else {
                let problem = RawOrderInvalid.invalidPosition
                let invalidData = InvalidResponseData(with: problem)
                throw invalidData.abort
            }

            try checkForNumberOfDishes(dishInDB: dishInDB, toOrder: dish.count)
        }
    }
    
    private func checkForNumberOfDishes(dishInDB: Dish, toOrder: Int) throws {
        guard dishInDB.quantity - toOrder >= 0 else {
            let problem = RawOrderInvalid.invalidNumberOfDishes
            let invalidData = InvalidResponseData(with: problem)
            throw invalidData.abort
        }
    }
}
