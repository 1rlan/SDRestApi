import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: DishesController(application: app))
    try app.register(collection: OrdersController(application: app))
}
