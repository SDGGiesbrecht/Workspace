// swift-tools-version:4.2

/*
 Package.swift

 This source file is part of the SDG open source project.
 https://example.github.io/SDG/SDG

 Copyright ©2019 John Doe and the SDG project contributors.
 ©2019

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import PackageDescription

/// A package.
let package = Package(
    name: "SDG",
    products: [
        /// A library.
        .library(name: "Library", targets: ["Library"]),
        .executable(name: "tool", targets: ["tool"])
        ],
    dependencies: [
        .package(url: "file:///tmp/Developer/Dependency", from: Version(1, 0, 0))
    ],
    targets: [
        /// A module.
        .target(name: "Library", dependencies: [
            .product(name: "Dependency", package: "Dependency")
            ]),
        .target(name: "tool", dependencies: [.target(name: "Library")]),
        .testTarget(name: "SDGTests", dependencies: [.target(name: "Library")]),
        .target(name: "test‐tool", path: "Tests/test‐tool")
    ]
)
