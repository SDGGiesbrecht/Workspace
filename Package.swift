// swift-tools-version:4.1

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

let package = Package(
    name: "Workspace",
    products: [
        .executable(name: "workspace", targets: ["workspace"]),
        .executable(name: "arbeitsbereich", targets: ["workspace"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .exact(Version(0, 8, 0))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGCommandLine", .exact(Version(0, 2, 0)))
    ],
    targets: [
        .target(name: "workspace", dependencies: [.targetItem(name: "WorkspaceLibrary")]),

        .target(name: "WorkspaceLibrary", dependencies: [
            .productItem(name: "SDGCornerstone", package: "SDGCornerstone"),
            .productItem(name: "SDGCommandLine", package: "SDGCommandLine")
            ]),

        .testTarget(name: "WorkspaceTests", dependencies: [.targetItem(name: "WorkspaceLibrary")]),
        .target(name: "test‐ios‐simulator", dependencies: [.targetItem(name: "WorkspaceLibrary")],
                path: "Tests/test‐ios‐simulator"),
        .target(name: "test‐tvos‐simulator", dependencies: [.targetItem(name: "WorkspaceLibrary")],
                path: "Tests/test‐tvos‐simulator")
    ]
)
