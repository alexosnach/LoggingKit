// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "LoggingKit",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "LoggingKit", targets: ["LoggingKit"]),
    ],
    targets: [
        // Logs from any thread: no default isolation, every type says its own.
        .target(name: "LoggingKit"),
        .testTarget(name: "LoggingKitTests", dependencies: ["LoggingKit"]),
    ]
)
