import Fluent
import Vapor

final class Dish: Model, Content {
    static var schema: String = "dishes"
    
    @ID(custom: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "price")
    var price: Int
    
    @Field(key: "quantity")
    var quantity: Int
    
    init() {}
    
    internal init(id: UUID? = nil, name: String, description: String, price: Int, quantity: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.quantity = quantity
    }
    
    func quantityReduction(for number: Int, database: Database) async throws {
        quantity -= number
        try await save(on: database)
    }
}
