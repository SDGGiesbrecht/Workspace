// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Default",
    products: [
        .library(
            name: "Default",
            targets: ["Default"]),
    ],
    targets: [
        .target(
            name: "Default",
            dependencies: []),
        .testTarget(
            name: "DefaultTests",
            dependencies: ["Default"]),
    ]
)
