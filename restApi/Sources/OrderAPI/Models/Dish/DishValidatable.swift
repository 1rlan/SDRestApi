import Vapor
import Fluent

import DataValidation

extension Dish: DataValidation.Validatable {
    func validate(application: Vapor.Application) throws {
        try checkPrice()
        try checkQuanity()
        try checkName()
        try checkDescription()
    }
    
    private func checkPrice() throws {
        guard price > 0 && price < 5000 else {
            let problem = DishInvalid.invalidPrice
            let invalidData = InvalidResponseData(with: problem)
            throw invalidData.abort
        }
    }
    
    private func checkQuanity() throws {
        guard quantity > 0 && quantity < 200 else {
            let problem = DishInvalid.ivalidQuanity
            let invalidData = InvalidResponseData(with: problem)
            throw invalidData.abort
        }
    }
    
    private func checkName() throws {
        guard !name.isEmpty else {
            let problem = DishInvalid.invalidName
            let invalidData = InvalidResponseData(with: problem)
            throw invalidData.abort
        }
    }
    
    private func checkDescription() throws {
        guard !description.isEmpty else {
            let problem = DishInvalid.invalidDescription
            let invalidData = InvalidResponseData(with: problem)
            throw invalidData.abort
        }
    }
}
