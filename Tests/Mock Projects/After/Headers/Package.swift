// swift-tools-version:4.0

/*
 Package.swift

 This source file is part of the Headers open source project.

 Copyright ©2020 the Headers project contributors.
 */

import PackageDescription

let package = Package(
    name: "Headers",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Headers",
            targets: ["Headers"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Headers",
            dependencies: []),
        .testTarget(
            name: "HeadersTests",
            dependencies: ["Headers"]),
    ]
)
