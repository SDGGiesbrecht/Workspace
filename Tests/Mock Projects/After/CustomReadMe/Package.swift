// swift-tools-version:4.0

/*
 Package.swift

 This source file is part of the CustomReadMe open source project.

 Copyright ©[Current Date] the CustomReadMe project contributors.

 Dedicated to the public domain.
 See http://unlicense.org/ for more information.
 */

import PackageDescription

/// > [Blah blah blah...](http://somewhere.com)
///
/// ## Example Usage
///
/// ```swift
/// let x = something()
/// ```
let package = Package(
    name: "CustomReadMe",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "CustomReadMe",
            targets: ["CustomReadMe"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "CustomReadMe",
            dependencies: []),
        .testTarget(
            name: "CustomReadMeTests",
            dependencies: ["CustomReadMe"])
    ]
)
