// swift-tools-version:4.2

import PackageDescription

// @example(1, Read‐Me 🇨🇦EN)
/// A package.
///
/// ### Example Usage
///
/// ```swift
/// // 🇨🇦EN
/// ```
let package = Package(
    name: "SDG",
    products: [
        /// A library.
        .library(name: "Library", targets: ["Library"])
        ],
    dependencies: [
        .package(url: "file:///tmp/Developer/Dependency", from: Version(1, 0, 0))
    ],
    targets: [
        /// A module.
        .target(name: "Library", dependencies: [
            .product(name: "Dependency", package: "Dependency")
            ]),
        .testTarget(name: "SDGTests", dependencies: [.target(name: "Library")])
    ]
)
