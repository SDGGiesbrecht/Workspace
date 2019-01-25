// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/// A package.
let package = Package(
    name: "CheckedInDocumentation",
    products: [
        /// A library.
        .library(name: "CheckedInDocumentation", targets: ["CheckedInDocumentation"]),
        /// Extensions.
        .library(name: "Extensions", targets: ["Extensions"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        /// A module.
        .target(name: "CheckedInDocumentation", dependencies: []),
        .target(name: "Extensions", dependencies: ["CheckedInDocumentation"]),
        .testTarget(
            name: "CheckedInDocumentationTests",
            dependencies: ["CheckedInDocumentation"]),
    ]
)
