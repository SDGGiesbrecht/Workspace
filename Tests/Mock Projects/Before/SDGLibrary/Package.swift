// swift-tools-version:4.0

import PackageDescription

/// A package.
let package = Package(name: "SDG",
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
            .productItem(name: "Dependency", package: "Dependency")
            ]),
        .testTarget(name: "SDGTests", dependencies: [.targetItem(name: "Library")])
    ]
)
