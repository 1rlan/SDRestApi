import Vapor

public protocol Validatable {
    func validate(application: Application) async throws
}
