// swift-tools-version:4.0

import PackageDescription

let library = "SDG"
let tests = library + "Tests"

let developer = "file:///tmp/Developer/"
let dependency = "Dependency"

let package = Package(
    name: library,
    products: [
        .library(name: library, targets: [library]),
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
