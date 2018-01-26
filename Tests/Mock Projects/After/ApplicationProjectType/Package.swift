// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "ApplicationProjectType",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ApplicationProjectType",
            targets: ["ApplicationProjectType"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ApplicationProjectType",
            dependencies: []),
        .testTarget(
            name: "ApplicationProjectTypeTests",
            dependencies: ["ApplicationProjectType"])
    ]
)
