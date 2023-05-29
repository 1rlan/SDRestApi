import Fluent
import Vapor

final class OrderDish: Model, Content {
    static var schema: String = "order_dish"
    
    @ID(custom: .id)
    var id: UUID?

    @Field(key: "order_id")
    var orderId: UUID
    
    @Field(key: "dish_id")
    var dishId: UUID
    
    @Field(key: "quantity")
    var quantity: Int
    
    @Field(key: "price")
    var price: Int

    init() {}

    internal init(
        id: UUID? = nil,
        orderId: UUID,
        dishId: UUID,
        quantity: Int,
        price: Int
    ) {
        self.id = id
        self.orderId = orderId
        self.dishId = dishId
        self.quantity = quantity
        self.price = price
    }
}


