// swift-tools-version:4.0

import PackageDescription

/// > Blah blah blah...
let package = Package(
    name: "Executable",
    products: [
        .executable(name: "Executable", targets: ["Executable"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Executable",
            dependencies: [])
    ]
)
