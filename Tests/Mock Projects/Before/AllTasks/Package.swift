// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/// A package with all tasks configured.
let package = Package(
    name: "AllTasks",
    products: [
        /// A library.
        .library(name: "AllTasks", targets: ["AllTasks"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        /// A module.
        .target(name: "AllTasks", dependencies: []),
        .testTarget(
            name: "AllTasksTests",
            dependencies: ["AllTasks"]),
    ]
)
