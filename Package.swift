// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "VaporDemo",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.110.1"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        
        // OpenAPI Generator
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.7.2"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.8.2"),
        .package(url: "https://github.com/swift-server/swift-openapi-vapor", from: "1.0.1"),
        
        // DI
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.1"),
    ],
    targets: [
        .executableTarget(
            name: "VaporDemo",
            dependencies: [
                // Vapor
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                // OpenAPI
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIVapor", package: "swift-openapi-vapor"),
                
                // DI
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            swiftSettings: swiftSettings,
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator"),
            ]
        ),
        .testTarget(
            name: "VaporDemoTests",
            dependencies: [
                .target(name: "VaporDemo"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
