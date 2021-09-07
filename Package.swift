// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoggingUtil",
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
