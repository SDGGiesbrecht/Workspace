// swift-tools-version:5.0

/*
 Package.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import PackageDescription

// @localization(🇨🇦EN)
/// Workspace automates management of Swift projects.
///
/// > [Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIV)
/// >
/// > [Whatever you do, work from the heart, as working for the Lord and not for men.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIV)
/// >
/// > ―⁧שאול⁩/Shaʼul
///
/// ### Features
///
/// - Provides rigorous validation:
///     - [Test coverage](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/TestingConfiguration/Properties/enforceCoverage.html)
///     - [Compiler warnings](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/TestingConfiguration/Properties/prohibitCompilerWarnings.html)
///     - [Documentation coverage](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/APIDocumentationConfiguration/Properties/enforceCoverage.html)
///     - [Example validation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/Examples.html)
///     - [Style proofreading](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ProofreadingConfiguration.html)
///     - [Reminders](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ProofreadingRule/Cases/manualWarnings.html)
///     - [Continuous integration set‐up](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ContinuousIntegrationConfiguration/Properties/manage.html) ([Travis CI](https://travis-ci.org) with help from [Swift Version Manager](https://github.com/kylef/swiftenv))
/// - Generates API [documentation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/APIDocumentationConfiguration/Properties/generate.html).
/// - Automates code maintenance:
///     - [Embedded resources](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/PackageResources.html)
///     - [Inherited documentation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/DocumentationInheritance.html)
///     - [Xcode project generation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/XcodeConfiguration/Properties/manage.html)
/// - Automates open source details:
///     - [File headers](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/FileHeaderConfiguration.html)
///     - [Read‐me files](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ReadMeConfiguration.html)
///     - [Licence notices](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/LicenceConfiguration.html)
///     - [Contributing instructions](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/GitHubConfiguration.html)
/// - Designed to interoperate with the [Swift Package Manager](https://swift.org/package-manager/).
/// - Manages projects for macOS, Linux, iOS, watchOS and tvOS.
/// - [Configurable](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Libraries/WorkspaceConfiguration.html)
///
/// ### The Workspace Workflow
///
/// (The following sample package is a real repository. You can use it to follow along.)
///
/// #### When the Repository Is Cloned
///
/// The need to hunt down workflow tools can deter contributors. On the other hand, including them in the repository causes a lot of clutter. To reduce both, when a project using Workspace is pulled, pushed, or cloned...
///
/// ```shell
/// git clone https://github.com/SDGGiesbrecht/SamplePackage
/// ```
///
/// ...only one small piece of Workspace comes with it: A short script called “Refresh” that comes in two variants, one for each operating system.
///
/// *Hmm... I wish I had more tools at my disposal... Hey! What if I...*
///
/// #### Refresh the Project
///
/// To refresh the project, double‐click the `Refresh` script for the corresponding operating system. (If you are on Linux and double‐clicking fails or opens a text file, see [here](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/Linux.html).)
///
/// `Refresh` opens a terminal window, and in it Workspace reports its actions while it sets the project folder up for development. (This may take a while the first time, but subsequent runs are faster.)
///
/// *This looks better. Let’s get coding!*
///
/// *[Add this... Remove that... Change something over here...]*
///
/// *...All done. I wonder if I broke anything while I was working? Hey! It looks like I can...*
///
/// #### Validate Changes
///
/// When the project seems ready for a push, merge, or pull request, validate the current state of the project by double‐clicking the `Validate` script.
///
/// `Validate` opens a terminal window and in it Workspace runs the project through a series of checks.
///
/// When it finishes, it prints a summary of which tests passed and which tests failed.
///
/// *Oops! I never realized that would happen...*
///
/// #### Summary
///
/// 1. `Refresh` before working.
/// 2. `Validate` when it looks complete.
///
/// *Wow! That was so much easier than doing it all manually!*
///
/// ### Applying Workspace to a Project
///
/// To apply Workspace to a project, run the following command in the root of the project’s repository. (This requires a full install.)
///
/// ```shell
/// $ workspace refresh
/// ```
///
/// By default, Workspace refrains from tasks which would involve modifying project files. Such tasks must be activated with a [configuration](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Libraries/WorkspaceConfiguration.html) file.
let package = Package(
    name: "Workspace",
    platforms: [
        // These must also be updated in Sources/WSProject/PackageRepository.swift.
        .macOS(.v10_13)
    ],
    products: [
        // #documentation(WorkspaceConfiguration)
        /// The root API used in configuration files.
        ///
        /// Workspace can be configured by placing a Swift file named `Workspace.swift` in the project root.
        ///
        /// The contents of a configuration file might look something like this:
        ///
        /// ```swift
        /// import WorkspaceConfiguration
        ///
        /// /*
        ///  Exernal packages can be imported with this syntax:
        ///  import [module] // [url], [version], [product]
        ///  */
        /// import SDGControlFlow // https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
        ///
        /// let configuration = WorkspaceConfiguration()
        /// configuration.optIntoAllTasks()
        /// configuration.documentation.api.generate = true
        /// configuration.documentation.api.yearFirstPublished = 2017
        /// ```
        .library(name: "WorkspaceConfiguration", targets: ["WorkspaceConfiguration"]),

        /// Workspace.
        .executable(name: "workspace", targets: ["WorkspaceTool"]),
        /// Arbeitsbereich.
        .executable(name: "arbeitsbereich", targets: ["WorkspaceTool"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .exact(Version(2, 0, 0))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGCommandLine", .exact(Version(1, 0, 2))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGSwift", .exact(Version(0, 12, 3))),
        .package(url: "https://github.com/SDGGiesbrecht/SDGWeb", .exact(Version(1, 0, 1)))
    ],
    targets: [
        // The executable. (Multiple products duplicate this with localized names.)
        .target(name: "WorkspaceTool", dependencies: [.target(name: "WorkspaceLibrary")]),
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
            "WSScripts",
            "WSGit",
            "WSOpenSource",
            "WSLicence",
            "WSGitHub",
            "WSContinuousIntegration",
            "WSResources",
            "WSFileHeaders",
            "WSExamples",
            "WSNormalization",
            "WSXcode",
            "WSProofreading",
            "WSTesting",
            "WSDocumentation"
            ], swiftSettings: [
                .define("TEST_SHIMS", .when(configuration: .debug))
            ]),

        // Workspace scripts.
        .target(name: "WSScripts", dependencies: [
            "WSGeneralImports",
            "WSProject"
            ]),

        // Git management.
        .target(name: "WSGit", dependencies: [
            "WSGeneralImports",
            "WSProject"
            ]),

        // Open source management.
        .target(name: "WSOpenSource", dependencies: [
            "WSGeneralImports",
            "WSProject",
            "WSExamples",
            "WSDocumentation",
            .product(name: "SDGSwiftSource", package: "SDGSwift")
            ]),

        // Licence management.
        .target(name: "WSLicence", dependencies: [
            "WSGeneralImports",
            "WorkspaceConfiguration",
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

        // Resource management.
        .target(name: "WSResources", dependencies: [
            "WSGeneralImports",
            "WSProject",
            "WSSwift",
            .product(name: "SDGSwiftPackageManager", package: "SDGSwift")
            ]),

        // File header management.
        .target(name: "WSFileHeaders", dependencies: [
            "WSGeneralImports",
            "WSProject"
            ]),

        // Example management.
        .target(name: "WSExamples", dependencies: [
            "WSGeneralImports",
            "WSProject",
            "WSParsing"
            ]),

        // Normalization.
        .target(name: "WSNormalization", dependencies: [
            "WSGeneralImports",
            "WSProject"
            ]),

        // Xcode project management.
        .target(name: "WSXcode", dependencies: [
            "WSGeneralImports",
            "WSProject",
            "WorkspaceProjectConfiguration",
            .product(name: "SDGXcode", package: "SDGSwift")
            ]),

        // Proofreading.
        .target(name: "WSProofreading", dependencies: [
            "WSGeneralImports",
            "WSProject",
            "WSCustomTask",
            .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
            .product(name: "SDGSwiftSource", package: "SDGSwift")
            ]),

        // Testing.
        .target(name: "WSTesting", dependencies: [
            "WSGeneralImports",
            "WSProject",
            "WSValidation",
            "WSContinuousIntegration",
            "WSProofreading",
            .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
            .product(name: "SDGSwiftPackageManager", package: "SDGSwift"),
            .product(name: "SDGXcode", package: "SDGSwift")
            ], swiftSettings: [
                .define("TEST_SHIMS", .when(configuration: .debug))
            ]),

        // Documentation generation.
        .target(name: "WSDocumentation", dependencies: [
            "WSGeneralImports",
            "WSProject",
            "WSParsing",
            "WSValidation",
            "WSXcode",
            "WSSwift",
            .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
            .product(name: "SDGXcode", package: "SDGSwift"),
            .product(name: "SDGSwiftSource", package: "SDGSwift"),
            .product(name: "SDGExportedCommandLineInterface", package: "SDGCommandLine"),
            .product(name: "SDGHTML", package: "SDGWeb"),
            .product(name: "SDGCSS", package: "SDGWeb")
            ], swiftSettings: [
                .define("UNIDENTIFIED_SYNTAX_WARNINGS", .when(configuration: .debug))
            ]),

        // Mechanism for embedding third party tools.
        .target(name: "WSCustomTask", dependencies: [
            "WSGeneralImports",
            "WorkspaceConfiguration",
            .product(name: "SDGSwift", package: "SDGSwift"),
            .product(name: "SDGExternalProcess", package: "SDGCornerstone")
            ]),

        // Utilities for validation reports.
        .target(name: "WSValidation", dependencies: [
            "WSGeneralImports",
            "WSProject"
            ]),

        // Utilities related to Swift syntax.
        .target(name: "WSSwift", dependencies: [
            "WSGeneralImports"
            ]),

        // Utilities related to parsing in‐source declarations and directives.
        .target(name: "WSParsing", dependencies: [
            "WSGeneralImports",
            "WSLocalizations",
            "WSProject"
            ]),

        // Defines general project structure queries and cache.
        .target(name: "WSProject", dependencies: [
            "WSGeneralImports",
            "WorkspaceConfiguration",
            "WorkspaceProjectConfiguration",
            .product(name: "SDGCalendar", package: "SDGCornerstone"),
            .product(name: "SDGSwiftPackageManager", package: "SDGSwift"),
            .product(name: "SDGSwiftConfigurationLoading", package: "SDGSwift")
            ], swiftSettings: [
                .define("CACHE_LOG", .when(configuration: .debug))
            ]),

        // #documentation(WorkspaceConfiguration)
        /// The root API used in configuration files.
        ///
        /// Workspace can be configured by placing a Swift file named `Workspace.swift` in the project root.
        ///
        /// The contents of a configuration file might look something like this:
        ///
        /// ```swift
        /// import WorkspaceConfiguration
        ///
        /// /*
        ///  Exernal packages can be imported with this syntax:
        ///  import [module] // [url], [version], [product]
        ///  */
        /// import SDGControlFlow // https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
        ///
        /// let configuration = WorkspaceConfiguration()
        /// configuration.optIntoAllTasks()
        /// configuration.documentation.api.generate = true
        /// configuration.documentation.api.yearFirstPublished = 2017
        /// ```
        .target(name: "WorkspaceConfiguration", dependencies: [
            "WSLocalizations",
            .product(name: "SDGControlFlow", package: "SDGCornerstone"),
            .product(name: "SDGLogic", package: "SDGCornerstone"),
            .product(name: "SDGCollections", package: "SDGCornerstone"),
            .product(name: "SDGText", package: "SDGCornerstone"),
            .product(name: "SDGLocalization", package: "SDGCornerstone"),
            .product(name: "SDGCalendar", package: "SDGCornerstone"),
            .product(name: "SDGSwift", package: "SDGSwift"),
            .product(name: "SDGSwiftConfiguration", package: "SDGSwift")
            ]),

        // Defines the lists of supported localizations.
        .target(name: "WSLocalizations", dependencies: [
            .product(name: "SDGLocalization", package: "SDGCornerstone")
            ]),

        // Centralizes imports needed almost everywhere.
        .target(name: "WSGeneralImports", dependencies: [
            "WSLocalizations",

            .product(name: "SDGControlFlow", package: "SDGCornerstone"),
            .product(name: "SDGLogic", package: "SDGCornerstone"),
            .product(name: "SDGMathematics", package: "SDGCornerstone"),
            .product(name: "SDGCollections", package: "SDGCornerstone"),
            .product(name: "SDGText", package: "SDGCornerstone"),
            .product(name: "SDGPersistence", package: "SDGCornerstone"),
            .product(name: "SDGLocalization", package: "SDGCornerstone"),
            .product(name: "SDGExternalProcess", package: "SDGCornerstone"),

            .product(name: "SDGCommandLine", package: "SDGCommandLine"),

            .product(name: "SDGSwift", package: "SDGSwift")
            ]),

        // Tests

        .target(name: "WSGeneralTestImports", dependencies: [
            "WSGeneralImports",
            "WorkspaceConfiguration",
            "WSInterface",
            .product(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone"),
            .product(name: "SDGLocalizationTestUtilities", package: "SDGCornerstone"),
            .product(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
            .product(name: "SDGCommandLineTestUtilities", package: "SDGCommandLine")
            ]),
        .testTarget(name: "WorkspaceLibraryTests", dependencies: [
            "WSGeneralTestImports",
            "WSCustomTask",
            .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
            .product(name: "SDGCommandLine", package: "SDGCommandLine")
            ]),
        .target(name: "test‐ios‐simulator", dependencies: [
            "WSGeneralImports",
            "WSInterface",
            .product(name: "SDGExternalProcess", package: "SDGCornerstone")
            ], path: "Tests/test‐ios‐simulator"),
        .target(name: "test‐tvos‐simulator", dependencies: [
            "WSGeneralImports",
            "WSInterface",
            .product(name: "SDGExternalProcess", package: "SDGCornerstone")
            ], path: "Tests/test‐tvos‐simulator"),
        .target(name: "WSConfigurationExample", dependencies: [
            "WorkspaceConfiguration",
            .product(name: "SDGControlFlow", package: "SDGCornerstone")
        ], path: "Tests/WSConfigurationExample"),

        // Other

        // This allows Workspace to load and use a configuration from its own development state, instead of an externally available stable version.
        .target(name: "WorkspaceProjectConfiguration", dependencies: [
            "WorkspaceConfiguration"
        ], path: "", sources: ["Workspace.swift"])
    ]
)
