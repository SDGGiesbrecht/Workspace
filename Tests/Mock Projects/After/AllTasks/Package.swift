// swift-tools-version:4.0

/*
 Package.swift

 This source file is part of the AllTasks open source project.

 Copyright ©2018 the AllTasks project contributors.

 This software is subject to copyright law.
 It may not be used, copied, distributed or modified without first obtaining a private licence from the copyright holder(s).
 */

import PackageDescription

let package = Package(
    name: "AllTasks",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "AllTasks",
            targets: ["AllTasks"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "AllTasks",
            dependencies: []),
        .testTarget(
            name: "AllTasksTests",
            dependencies: ["AllTasks"]),
    ]
)
