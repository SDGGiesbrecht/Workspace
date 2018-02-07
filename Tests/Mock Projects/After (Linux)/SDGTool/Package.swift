// swift-tools-version:4.0

import PackageDescription

let packageName = "SDG"
let library = "Library"
let tool = "tool"
let tests = packageName + "Tests"

let developer = "file:///tmp/Developer/"
let dependency = "Dependency"

let package = Package(
    name: packageName,
    products: [
        .library(name: library, targets: [library]),
        .executable(name: tool, targets: [tool])
        ],
    dependencies: [
        .package(url: developer + dependency, from: Version(1, 0, 0))
    ],
    targets: [
        .target(name: library, dependencies: [
            .productItem(name: dependency, package: dependency)
            ]),
        .target(name: tool, dependencies: [.targetItem(name: library)]),
        .testTarget(name: tests, dependencies: [.targetItem(name: library)])
    ]
)
