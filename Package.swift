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
        /// The API used in configuration files.
        .library(name: "WorkspaceConfiguration", targets: ["WorkspaceConfiguration"]),

        /// Workspace.
        .executable(name: "workspace", targets: ["WorkspaceTool"]),
        /// Arbeitsbereich.
        .executable(name: "arbeitsbereich", targets: ["WorkspaceTool"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .exact(Version(0, 10, 0))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGCommandLine", .exact(Version(0, 3, 3))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGSwift", .exact(Version(0, 2, 0))),
        .package(url: "https://github.com/apple/swift\u{2D}package\u{2D}manager", .exact(Version(0, 2, 0)))
    ],
    targets: [
        // The executable. (Multiple products duplicate this with localized names.)
        .target(name: "WorkspaceTool", dependencies: [.targetItem(name: "WorkspaceLibrary")]),
        // The umbrella library. (Shared by the various localized executables.)
        .target(name: "WorkspaceLibrary", dependencies: [
            "WSGeneralImports",
            "WorkspaceProjectConfiguration",
            "WSInterface"
            ]),

        // Components

        // Defines the public command line interface.
        .target(name: "WSInterface", dependencies: [
            "WSGeneralImports",
            "WorkspaceProjectConfiguration",
            "WSProject",
            "WSValidation",
            "WSGit",
            "WSGitHub",
            "WSContinuousIntegration",
            "WSExamples",
            "WSXcode",
            "WSProofreading",
            "WSDocumentation",
            // [_Workaround: This module and its dependency list needs refactoring._]
            "WSSwift",
            "WSThirdParty",
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone"),
            .productItem(name: "SDGSwiftPackageManager", package: "SDGSwift"),
            .productItem(name: "SDGXcode", package: "SDGSwift"),
            .productItem(name: "SwiftPM", package: "swift\u{2D}package\u{2D}manager")
            ]),

        // Git management.
        .target(name: "WSGit", dependencies: [
            "WSGeneralImports",
            "WSProject"
            ]),

        // GitHub management.
        .target(name: "WSGitHub", dependencies: [
            "WSGeneralImports",
            "WSProject",
            "WorkspaceProjectConfiguration"
            ]),

        // Continuous integration management.
        .target(name: "WSContinuousIntegration", dependencies: [
            "WSGeneralImports",
            "WSProject",
            "WSDocumentation"
            ]),

        // Example management.
        .target(name: "WSExamples", dependencies: [
            "WSGeneralImports",
            "WSProject"
            ]),

        // Xcode project management.
        .target(name: "WSXcode", dependencies: [
            "WSGeneralImports",
            "WSProject",
            "WorkspaceProjectConfiguration",
            .productItem(name: "SDGXcode", package: "SDGSwift")
            ]),

        // Proofreading.
        .target(name: "WSProofreading", dependencies: [
            "WSGeneralImports",
            "WSProject",
            "WSThirdParty",
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone")
            ]),

        // Documentation generation.
        .target(name: "WSDocumentation", dependencies: [
            "WSGeneralImports",
            "WSProject",
            "WSValidation",
            "WSThirdParty",
            "WSXcode",
            "WSSwift",
            .productItem(name: "SDGXcode", package: "SDGSwift")
            ]),

        // Mechanism for embedding third party tools.
        .target(name: "WSThirdParty", dependencies: [
            "WSGeneralImports",
            "WorkspaceConfiguration",
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone")
            ]),

        // Utilities for validation reports.
        .target(name: "WSValidation", dependencies: [
            "WSGeneralImports"
            ]),

        // Utilities related to Swift syntax.
        .target(name: "WSSwift", dependencies: [
            "WSGeneralImports"
            ]),

        // Defines general project structure queries and cache.
        .target(name: "WSProject", dependencies: [
            "WSGeneralImports",
            "WorkspaceConfiguration",
            "WorkspaceProjectConfiguration",
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone"),
            .productItem(name: "SDGSwiftPackageManager", package: "SDGSwift"),
            .productItem(name: "SDGSwiftConfigurationLoading", package: "SDGSwift")
            ]),

        // The API used in configuration files.
        .target(name: "WorkspaceConfiguration", dependencies: [
            "WSLocalizations",
            .productItem(name: "SDGControlFlow", package: "SDGCornerstone"),
            .productItem(name: "SDGLogic", package: "SDGCornerstone"),
            .productItem(name: "SDGCollections", package: "SDGCornerstone"),
            .productItem(name: "SDGText", package: "SDGCornerstone"),
            .productItem(name: "SDGLocalization", package: "SDGCornerstone"),
            .productItem(name: "SDGCalendar", package: "SDGCornerstone"),
            .productItem(name: "SDGSwift", package: "SDGSwift"),
            .productItem(name: "SDGSwiftConfiguration", package: "SDGSwift")
            ]),

        // Defines the lists of supported localizations.
        .target(name: "WSLocalizations", dependencies: [
            .productItem(name: "SDGLocalization", package: "SDGCornerstone")
            ]),

        // Centralizes imports needed almost everywhere.
        .target(name: "WSGeneralImports", dependencies: [
            "WSLocalizations",

            .productItem(name: "SDGControlFlow", package: "SDGCornerstone"),
            .productItem(name: "SDGLogic", package: "SDGCornerstone"),
            .productItem(name: "SDGMathematics", package: "SDGCornerstone"),
            .productItem(name: "SDGCollections", package: "SDGCornerstone"),
            .productItem(name: "SDGText", package: "SDGCornerstone"),
            .productItem(name: "SDGPersistence", package: "SDGCornerstone"),
            .productItem(name: "SDGLocalization", package: "SDGCornerstone"),
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone"),

            .productItem(name: "SDGCommandLine", package: "SDGCommandLine"),

            .productItem(name: "SDGSwift", package: "SDGSwift")
            ]),

        // Tests

        .target(name: "WSGeneralTestImports", dependencies: [
            "WSGeneralImports",
            "WorkspaceConfiguration",
            "WSInterface",
            .productItem(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone"),
            .productItem(name: "SDGLocalizationTestUtilities", package: "SDGCornerstone"),
            .productItem(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
            .productItem(name: "SDGCommandLineTestUtilities", package: "SDGCommandLine")
            ]),
        .testTarget(name: "WorkspaceLibraryTests", dependencies: [
            "WSGeneralTestImports",
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone")
            ]),
        .target(name: "test‐ios‐simulator", dependencies: [
            "WSGeneralImports",
            "WSInterface",
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone")
            ], path: "Tests/test‐ios‐simulator"),
        .target(name: "test‐tvos‐simulator", dependencies: [
            "WSGeneralImports",
            "WSInterface",
            .productItem(name: "SDGExternalProcess", package: "SDGCornerstone")
            ], path: "Tests/test‐tvos‐simulator"),
        .target(name: "WSConfigurationExample", dependencies: [
            "WorkspaceConfiguration",
            .productItem(name: "SDGControlFlow", package: "SDGCornerstone")
        ], path: "Tests/WSConfigurationExample"),

        // Other

        // This allows Workspace to load and use a configuration from its own development state, instead of an externally available stable version.
        .target(name: "WorkspaceProjectConfiguration", dependencies: [
            "WorkspaceConfiguration"
        ], path: "", sources: ["Workspace.swift"])
    ]
)
