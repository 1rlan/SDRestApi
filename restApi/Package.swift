// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "restApi",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.76.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.2.0"),
        .package(url: "https://github.com/dejanskledar/SerializedSwift/", from: "0.2.0")
    ],
    targets: [
        .executableTarget(
            name: "UserAPI",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "JWT", package: "jwt"),
                .product(name: "SerializedSwift", package: "SerializedSwift"),
                "Tools",
                "CommonModels",
                "UserJWT",
            ],
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(
            name: "OrderAPI",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                "Tools",
                "CommonModels",
                "UserJWT"
            ],
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .target(name: "Tools",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWT", package: "jwt"),
            ]
        ),
        .target(name: "CommonModels",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                "SerializedSwift",
                "DataValidation",
                "Tools",
            ]
        ),
        .target(name: "DataValidation",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
        .target(name: "UserJWT",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                "CommonModels"
            ]
        ),
    ]
)
