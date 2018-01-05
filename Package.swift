// swift-tools-version:4.0

/*
 Package.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import PackageDescription

let packageName = "Workspace"
let tool = "workspace"
let werkzeug = "arbeitsbereich"

let library = packageName + "Library"
let tests = packageName + "Tests"

let sdgGiesbrecht = "https://github.com/SDGGiesbrecht/"
let sdgCornerstone = "SDGCornerstone"
let sdgCommandLine = "SDGCommandLine"

let package = Package(
    name: packageName,
    products: [
        .executable(name: tool, targets: [tool]),
        .executable(name: werkzeug, targets: [tool])
    ],
    dependencies: [
    .package(url: sdgGiesbrecht + sdgCornerstone, .exact(Version(0, 7, 3))),
        .package(url: sdgGiesbrecht + sdgCommandLine, .exact(Version(0, 1, 4)))
    ],
    targets: [
        .target(name: tool, dependencies: [.targetItem(name: library)]),

        .target(name: library, dependencies: [
            .productItem(name: sdgCornerstone, package: sdgCornerstone),
            .productItem(name: sdgCommandLine, package: sdgCommandLine)
            ]),
        .testTarget(name: tests, dependencies: [.targetItem(name: library)])
    ]
)
