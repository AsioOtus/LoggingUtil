// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "LoggingUtil",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "LoggingUtil",
            targets: ["LoggingUtil"]
		),
    ],
    targets: [
        .target(
            name: "LoggingUtil"
		),
        .testTarget(
            name: "LoggingUtilTests",
            dependencies: ["LoggingUtil"]
		),
    ]
)
