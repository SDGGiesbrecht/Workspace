// swift-tools-version:4.0

/*
 Package.swift

 This source file is part of the SDG open source project.
 https://example.github.io/SDG/SDG

 Copyright ©2018 John Doe and the SDG project contributors.

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
