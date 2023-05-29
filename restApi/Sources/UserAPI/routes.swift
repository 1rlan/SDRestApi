import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: UsersController(application: app))
    try app.register(collection: AuthenticationController(application: app))
}
