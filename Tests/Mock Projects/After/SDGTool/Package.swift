// swift-tools-version:5.6

/*
 Package.swift

 This source file is part of the SDG open source project.
 Diese Quelldatei ist Teil des quelloffenen SDG‐Projekt.
 https://example.github.io/SDG/SDG

 Copyright ©[Current Date] John Doe and the SDG project contributors.
 Urheberrecht ©[Current Date] John Doe und die Mitwirkenden des SDG‐Projekts.
 ©[Current Date]

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

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
            ],
                resources: [
                  .copy("(Named with) Punctuation!.txt"),
                  .copy("2001‐01‐01 (Named with Numbers).txt"),
                  .copy("Namespace/Data Resource"),
                  .copy("Text Resource.txt")
                ]
        ),
        .executableTarget(name: "tool", dependencies: [.target(name: "Library")]),
        .testTarget(name: "SDGTests", dependencies: [.target(name: "Library")]),
        .executableTarget(name: "test‐tool", path: "Tests/test‐tool",
                resources: [
                  .copy("Text Resource.txt")
                ]
               )
    ]
)
