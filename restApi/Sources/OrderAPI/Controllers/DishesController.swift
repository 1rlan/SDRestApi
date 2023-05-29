import Vapor
import Fluent

struct DishesController: RouteCollection {
    let application: Application
    let decoder = JSONDecoder()
    
    func boot(routes: RoutesBuilder) throws {
        let getMenu = routes.grouped("menu")
        
        let postDish = routes.grouped("dish", "post")
        let deleteDish = routes.grouped("dish", "delete")
        let postPrice = routes.grouped("dish", "price")
        let postQuantity = routes.grouped("dish", "quantity")
        
        getMenu.get(use: getMenuRequest)
        postDish.post(use: postDishRequest)
        deleteDish.delete(use: deleteDishRequest)
        postPrice.post(use: postPriceRequest)
        postQuantity.post(use: postQuantityRequest)
    }
}
