// swift-tools-version:4.0

import PackageDescription

// @localization(🇨🇦EN)
/// A package.
let package = Package(
    name: "PartialReadMe",
    products: [
        /// A library.
        .library(name: "PartialReadMe", targets: ["PartialReadMe"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        /// A target.
        .target(name: "PartialReadMe", dependencies: []),
        .testTarget(
            name: "PartialReadMeTests",
            dependencies: ["PartialReadMe"])
    ]
)
