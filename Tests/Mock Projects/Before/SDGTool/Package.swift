// swift-tools-version:5.0

import PackageDescription

// @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(🇫🇷FR) @localization(🇬🇷ΕΛ) @localization(🇮🇱עב) @localization(zxx)
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
        // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(🇫🇷FR) @localization(🇬🇷ΕΛ) @localization(🇮🇱עב) @localization(zxx)
        /// A library.
        .library(name: "Library", targets: ["Library"]),
        .executable(name: "tool", targets: ["tool"]),
        .executable(name: "werkzeug", targets: ["tool"])
        ],
    dependencies: [
        .package(url: "file:///tmp/Developer/Dependency", from: Version(1, 0, 0))
    ],
    targets: [
        // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(🇫🇷FR) @localization(🇬🇷ΕΛ) @localization(🇮🇱עב) @localization(zxx)
        /// A module.
        .target(name: "Library", dependencies: [
            .product(name: "Dependency", package: "Dependency")
            ]),
        .target(name: "tool", dependencies: [.target(name: "Library")]),
        .testTarget(name: "SDGTests", dependencies: [.target(name: "Library")]),
        .target(name: "test‐tool", path: "Tests/test‐tool")
    ]
)
