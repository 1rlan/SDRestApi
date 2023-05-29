import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.http.server.configuration.hostname = "127.0.0.1"
    app.http.server.configuration.port = 8000
    
    app.jwt.signers.use(.hs256(key: "secret"), kid: "a")

    app.databases.use(.postgres(configuration: SQLPostgresConfiguration(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "sdhw",
        password: Environment.get("DATABASE_PASSWORD") ?? "1234",
        database: Environment.get("DATABASE_NAME") ?? "sdhw",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    try await app.autoMigrate()

    // register routes
    try routes(app)
}
