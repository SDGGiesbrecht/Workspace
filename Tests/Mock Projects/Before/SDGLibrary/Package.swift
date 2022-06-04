// swift-tools-version:5.6

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
        .library(name: "Library", targets: ["Library"])
        ],
    dependencies: [
        .package(url: "file:///tmp/Developer/Dependency", from: Version(1, 0, 0))
    ],
    targets: [
        // @localization(🇨🇦EN) @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇩🇪DE) @localization(🇫🇷FR) @localization(🇬🇷ΕΛ) @localization(🇮🇱עב) @localization(zxx)
        /// A module.
        .target(name: "Library", dependencies: [
            .product(name: "Dependency", package: "Dependency")
            ],
                resources: [
                  .copy("(Named with) Punctuation!.txt"),
                  .copy("2001‐01‐01 (Named with Numbers).txt"),
                  .copy("Namespace/Data Resource"),
                  .copy("Text Resource.txt")
                ]
        ),
        .testTarget(name: "SDGTests", dependencies: [.target(name: "Library")],
                    resources: [
                      .copy("Text Resource.txt")
                    ]
                   )
    ]
)

import Foundation
if ProcessInfo.processInfo.environment["TARGETING_WATCHOS"] == "true" {
  package.targets.removeAll(where: { $0.isTest })
}
