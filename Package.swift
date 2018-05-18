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
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .exact(Version(0, 9, 4))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGCommandLine", .exact(Version(0, 3, 0))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGSwift", .exact(Version(0, 1, 6))),
        .package(url: "https://github.com/apple/swift\u{2D}package\u{2D}manager", .exact(Version(0, 2, 0)))
    ],
    targets: [
        // The executable. (Multiple products duplicate this with localized names.)
        .target(name: "WorkspaceTool", dependencies: [.targetItem(name: "WorkspaceLibrary")]),
        // The umbrella library. (Shared by the various localized executables.)
        .target(name: "WorkspaceLibrary", dependencies: [
            "GeneralImports",
            "Interface"
            ]),

        // Components

        // Defines the public command line interface.
        .target(name: "Interface", dependencies: [
            "GeneralImports",
            // [_Workaround: This module and its dependency list needs refactoring._]
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone"),
            .productItem(name: "SDGSwiftPackageManager", package: "SDGSwift"),
            .productItem(name: "SDGXcode", package: "SDGSwift"),
            .productItem(name: "SwiftPM", package: "swift\u{2D}package\u{2D}manager")
            ]),

        // Defines the lists of supported localizations.
        .target(name: "Localizations", dependencies: [
            .productItem(name: "SDGLocalization", package: "SDGCornerstone")
            ]),
        // Centralizes imports needed almost everywhere.
        .target(name: "GeneralImports", dependencies: [
            "Localizations",

            .productItem(name: "SDGControlFlow", package: "SDGCornerstone"),
            .productItem(name: "SDGLogic", package: "SDGCornerstone"),
            .productItem(name: "SDGMathematics", package: "SDGCornerstone"),
            .productItem(name: "SDGCollections", package: "SDGCornerstone"),
            .productItem(name: "SDGText", package: "SDGCornerstone"),
            .productItem(name: "SDGPersistence", package: "SDGCornerstone"),
            .productItem(name: "SDGLocalization", package: "SDGCornerstone"),

            .productItem(name: "SDGCommandLine", package: "SDGCommandLine"),

            .productItem(name: "SDGSwift", package: "SDGSwift")
            ]),

        // Tests

        .target(name: "GeneralTestImports", dependencies: [
            "GeneralImports",
            "Interface",
            .productItem(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone"),
            .productItem(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
            .productItem(name: "SDGCommandLineTestUtilities", package: "SDGCommandLine")
            ]),
        .testTarget(name: "WorkspaceLibraryTests", dependencies: [
            "GeneralTestImports",
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone")
            ]),
        .target(name: "test‐ios‐simulator", dependencies: [
            "GeneralImports",
            "Interface",
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone")
            ], path: "Tests/test‐ios‐simulator"),
        .target(name: "test‐tvos‐simulator", dependencies: [
            "GeneralImports",
            "Interface",
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone")
            ], path: "Tests/test‐tvos‐simulator")
    ]
)
