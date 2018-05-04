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
        .executable(name: "workspace", targets: ["WorkspaceTool"]),
        .executable(name: "arbeitsbereich", targets: ["WorkspaceTool"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .exact(Version(0, 9, 3))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGCommandLine", .exact(Version(0, 3, 0))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGSwift", .exact(Version(0, 1, 1)))
    ],
    targets: [
        .target(name: "WorkspaceTool", dependencies: [.targetItem(name: "WorkspaceLibrary")]),

        .target(name: "WorkspaceLibrary", dependencies: [
            //.productItem(name: "SDGControlFlow", package: "SDGCornerstone"),
            //.productItem(name: "SDGLogic", package: "SDGCornerstone"),
            //.productItem(name: "SDGCollections", package: "SDGCornerstone"),
            //.productItem(name: "SDGPersistence", package: "SDGCornerstone"),
            //.productItem(name: "SDGLocalization", package: "SDGCornerstone"),
            .productItem(name: "SDGCommandLine", package: "SDGCommandLine"),
            //.productItem(name: "SDGSwift", package: "SDGSwift"),
            //.productItem(name: "SDGSwiftPackageManager", package: "SDGSwift"),
            //.productItem(name: "SDGXcode", package: "SDGSwift")
            ]),

        .testTarget(name: "WorkspaceLibraryTests", dependencies: [.targetItem(name: "WorkspaceLibrary")]),
        .target(name: "test‐ios‐simulator", dependencies: [
            .targetItem(name: "WorkspaceLibrary"),
            .productItem(name: "SDGCommandLine", package: "SDGCommandLine"),
            ], path: "Tests/test‐ios‐simulator"),
        .target(name: "test‐tvos‐simulator", dependencies: [
            .targetItem(name: "WorkspaceLibrary"),
            .productItem(name: "SDGCommandLine", package: "SDGCommandLine"),
            ], path: "Tests/test‐tvos‐simulator")
    ]
)
