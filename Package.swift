// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "fugle-realtime-swift",
    platforms: [
        .macOS(.v10_15), .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FugleRealtime",
            targets: ["FugleRealtime"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.10.0"),
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", from: "4.2.0"),
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.3.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FugleRealtime",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "ObjectMapper", package: "ObjectMapper"),
                .product(name: "WebSocketKit", package: "websocket-kit"),
            ]),
        .testTarget(
            name: "FugleRealtimeTests",
            dependencies: ["FugleRealtime"]),
    ]
)
