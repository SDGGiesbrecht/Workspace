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

let packageName = "SDG"
let library = "Library"
let tests = packageName + "Tests"

let developer = "file:///tmp/Developer/"
let dependency = "Dependency"

let package = Package(
    name: packageName,
    products: [
        .library(name: library, targets: [library])
        ],
    dependencies: [
        .package(url: developer + dependency, from: Version(1, 0, 0))
    ],
    targets: [
        .target(name: library, dependencies: [
            .productItem(name: dependency, package: dependency)
            ]),
        .testTarget(name: tests, dependencies: [.targetItem(name: library)])
    ]
)
