// swift-tools-version:5.1

/*
 Package.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import PackageDescription

// @localization(🇩🇪DE)
/// Arbeitsbereich automatisiert die Verwaltung von Swift‐Projekten.
///
/// > [Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;SCH2000)
/// >
/// > [Was auch immer ihr macht, arbeitet vom Herzen, als für den Herrn und nicht für Menschen.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;SCH2000)
/// >
/// > ―⁧שאול⁩/Shaʼul
///
/// ### Merkmale
///
/// - Stellt gründliche Prüfungen bereit:
///     - [Testabdeckung](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Testeinstellungen/Eigenschaften/abdeckungErzwingen.html)
///     - [Übersetzerwarnungen](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Testeinstellungen/Eigenschaften/übersetzerwarnungenVerbieten.html)
///     - [Dokumentationsabdeckung](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Programmierschnittstellendokumentationseinstellungen/Eigenschaften/abdeckungErzwingen.html)
///     - [Beispielprüfung](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Programme/arbeitsbereich/Unterbefehle/auffrischen/Unterbefehle/beispiele.html)
///     - [Stilkorrekturlesen](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Korrektureinstellungen.html)
///     - [Erinnerungen](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Korrekturregel/Typ%E2%80%90Eigenschaften/warnungenVonHand.html)
///     - [Einrichtung von fortlaufeden Einbindung](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/EinstellungenFortlaufenderEinbindung/Eigenschaften/verwalten.html) ([GitHub Vorgänge](https://github.com/features/actions))
/// - Erstellt  [Dokumentation](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Programmierschnittstellendokumentationseinstellungen/Eigenschaften/erstellen.html) von Programierschnittstellen.
/// - Automatisiert Quellinstandhaltung:
///     - [Einbau von Ressourcen](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Programme/arbeitsbereich/Unterbefehle/auffrischen/Unterbefehle/ressourcen.html)
///     - [Geerbte Dokumentation](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Programme/arbeitsbereich/Unterbefehle/auffrischen/Unterbefehle/geerbte%E2%80%90dokumentation.html)
///     - [Erstellung von Xcode‐Projekte](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/XcodeEinstellungen/Eigenschaften/verwalten.html)
/// - Automatisiert quelloffene Nebensachen:
///     - [Dateivorspänne](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Dateivorspannseinstellungen.html)
///     - [Lies‐mich‐Dateien](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/LiesMichEinstellungen.html)
///     - [Lizenzhinweise](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/Lizenzeinstellungen.html)
///     - [Mitwirkungsanweisungen](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Typen/GitHubConfiguration.html)
/// - Für Verwendung neben dem [Swift Package Manager](https://swift.org/package-manager/) vorgesehen.
/// - Verwaltet Projekte für macOS, Windows, Linux, tvOS, iOS, Android und watchOS.
/// - [Konfigurierbar](https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Biblioteken/WorkspaceConfiguration.html)
// @localization(🇺🇸EN)
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
///     - [Test coverage](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/TestingConfiguration/Properties/enforceCoverage.html)
///     - [Compiler warnings](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/TestingConfiguration/Properties/prohibitCompilerWarnings.html)
///     - [Documentation coverage](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/APIDocumentationConfiguration/Properties/enforceCoverage.html)
///     - [Example validation](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Tools/workspace/Subcommands/refresh/Subcommands/examples.html)
///     - [Style proofreading](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/ProofreadingConfiguration.html)
///     - [Reminders](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/ProofreadingRule/Cases/manualWarnings.html)
///     - [Continuous integration set‐up](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/ContinuousIntegrationConfiguration/Properties/manage.html) ([GitHub Actions](https://github.com/features/actions))
/// - Generates API [documentation](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/APIDocumentationConfiguration/Properties/generate.html).
/// - Automates code maintenance:
///     - [Embedded resources](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Tools/workspace/Subcommands/refresh/Subcommands/resources.html)
///     - [Inherited documentation](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Tools/workspace/Subcommands/refresh/Subcommands/inherited%E2%80%90documentation.html)
///     - [Xcode project generation](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/XcodeConfiguration/Properties/manage.html)
/// - Automates open source details:
///     - [File headers](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/FileHeaderConfiguration.html)
///     - [Read‐me files](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/ReadMeConfiguration.html)
///     - [Licence notices](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/LicenseConfiguration.html)
///     - [Contributing instructions](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Types/GitHubConfiguration.html)
/// - Designed to interoperate with the [Swift Package Manager](https://swift.org/package-manager/).
/// - Manages projects for macOS, Windows, Linux, tvOS, iOS, Android and watchOS.
/// - [Configurable](https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Libraries/WorkspaceConfiguration.html)
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
///     - [Example validation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Tools/workspace/Subcommands/refresh/Subcommands/examples.html)
///     - [Style proofreading](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ProofreadingConfiguration.html)
///     - [Reminders](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ProofreadingRule/Cases/manualWarnings.html)
///     - [Continuous integration set‐up](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ContinuousIntegrationConfiguration/Properties/manage.html) ([GitHub Actions](https://github.com/features/actions))
/// - Generates API [documentation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/APIDocumentationConfiguration/Properties/generate.html).
/// - Automates code maintenance:
///     - [Embedded resources](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Tools/workspace/Subcommands/refresh/Subcommands/resources.html)
///     - [Inherited documentation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Tools/workspace/Subcommands/refresh/Subcommands/inherited%E2%80%90documentation.html)
///     - [Xcode project generation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/XcodeConfiguration/Properties/manage.html)
/// - Automates open source details:
///     - [File headers](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/FileHeaderConfiguration.html)
///     - [Read‐me files](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ReadMeConfiguration.html)
///     - [Licence notices](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/LicenceConfiguration.html)
///     - [Contributing instructions](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/GitHubConfiguration.html)
/// - Designed to interoperate with the [Swift Package Manager](https://swift.org/package-manager/).
/// - Manages projects for macOS, Windows, Linux, tvOS, iOS, Android and watchOS.
/// - [Configurable](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Libraries/WorkspaceConfiguration.html)
// @localization(🇬🇧EN)
/// Workspace automates management of Swift projects.
///
/// > [Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIVUK)
/// >
/// > [Whatever you do, work from the heart, as working for the Lord and not for men.](https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIVUK)
/// >
/// > ―⁧שאול⁩/Shaʼul
///
/// ### Features
///
/// - Provides rigorous validation:
///     - [Test coverage](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/TestingConfiguration/Properties/enforceCoverage.html)
///     - [Compiler warnings](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/TestingConfiguration/Properties/prohibitCompilerWarnings.html)
///     - [Documentation coverage](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/APIDocumentationConfiguration/Properties/enforceCoverage.html)
///     - [Example validation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Tools/workspace/Subcommands/refresh/Subcommands/examples.html)
///     - [Style proofreading](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/ProofreadingConfiguration.html)
///     - [Reminders](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/ProofreadingRule/Cases/manualWarnings.html)
///     - [Continuous integration set‐up](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/ContinuousIntegrationConfiguration/Properties/manage.html) ([GitHub Actions](https://github.com/features/actions))
/// - Generates API [documentation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/APIDocumentationConfiguration/Properties/generate.html).
/// - Automates code maintenance:
///     - [Embedded resources](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Tools/workspace/Subcommands/refresh/Subcommands/resources.html)
///     - [Inherited documentation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Tools/workspace/Subcommands/refresh/Subcommands/inherited%E2%80%90documentation.html)
///     - [Xcode project generation](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/XcodeConfiguration/Properties/manage.html)
/// - Automates open source details:
///     - [File headers](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/FileHeaderConfiguration.html)
///     - [Read‐me files](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/ReadMeConfiguration.html)
///     - [Licence notices](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/LicenceConfiguration.html)
///     - [Contributing instructions](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Types/GitHubConfiguration.html)
/// - Designed to interoperate with the [Swift Package Manager](https://swift.org/package-manager/).
/// - Manages projects for macOS, Windows, Linux, tvOS, iOS, Android and watchOS.
/// - [Configurable](https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Libraries/WorkspaceConfiguration.html)
let package = Package(
  name: "Workspace",
  platforms: [
    // These must also be updated in Sources/WSProject/PackageRepository.swift.
    .macOS(.v10_10)
  ],
  products: [
    // @localization(🇩🇪DE)
    // #documentation(ArbeitsbereichKonfiguration)
    /// Die Wurzel der Programmierschnittstelle für Konfigurationsdateien.
    ///
    /// Arbeitsbereich kann durch eine Swift‐Datei Namens `Arbeitsbereich.swift` im Projektwurzel konfiguriert werden.
    ///
    /// Der Inhalt einer Konfigurationsdatei könnte etwa so aussehen:
    ///
    /// ```swift
    /// import WorkspaceConfiguration
    ///
    /// /*
    ///  Externe Pakete sind mit dieser Syntax einführbar:
    ///  import [Modul] // [Ressourcenzeiger], [Version], [Produkt]
    ///  */
    /// import SDGControlFlow  // https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
    ///
    /// let konfiguration = ArbeitsbereichKonfiguration()
    /// konfiguration.alleAufgabenEinschalten()
    ///
    /// konfiguration.unterstützteSchichte = [.macOS, .windows, .linux, .android]
    ///
    /// konfiguration.dokumentation.aktuelleVersion = Version(1, 0, 0)
    /// konfiguration.dokumentation.projektSeite = URL(string: "projekt.de")
    /// konfiguration.dokumentation
    ///   .dokumentationsRessourcenzeiger = URL(string: "projekt.de/Dokumentation")
    /// konfiguration.dokumentation
    ///   .lagerRessourcenzeiger = URL(string: "https://github.com/Benutzer/Projekt")
    ///
    /// konfiguration.dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung = 2017
    ///
    /// konfiguration.dokumentation.lokalisationen = ["🇩🇪DE", "fr"]
    /// konfiguration.dokumentation.programmierschnittstelle.urheberrechtsschutzvermerk =
    ///   BequemeEinstellung<[Lokalisationskennzeichen: StrengeZeichenkette]>(auswerten: { konfiguration in
    ///     return [
    ///       "🇩🇪DE": "Urheberrecht #daten \(konfiguration.dokumentation.hauptautor!).",
    ///       "fr": "Droit d’auteur #daten \(konfiguration.dokumentation.hauptautor!)."
    ///     ]
    ///   })
    ///
    /// konfiguration.dokumentation.hauptautor = "Max Mustermann"
    /// ```
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
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
    /// import SDGControlFlow  // https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
    ///
    /// let configuration = WorkspaceConfiguration()
    /// configuration.optIntoAllTasks()
    ///
    /// configuration.supportedPlatforms = [.macOS, .windows, .linux, .android]
    ///
    /// configuration.documentation.currentVersion = Version(1, 0, 0)
    /// configuration.documentation.projectWebsite = URL(string: "project.uk")
    /// configuration.documentation.documentationURL = URL(string: "project.uk/Documentation")
    /// configuration.documentation.repositoryURL = URL(string: "https://github.com/User/Project")
    ///
    /// configuration.documentation.api.yearFirstPublished = 2017
    ///
    /// configuration.documentation.localisations = ["🇬🇧EN", "🇺🇸EN", "🇨🇦EN", "fr", "es"]
    /// configuration.documentation.api.copyrightNotice = Lazy<[LocalisationIdentifier: StrictString]>(
    ///   resolve: { configuration in
    ///     return [
    ///       "🇬🇧EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
    ///       "🇺🇸EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
    ///       "🇨🇦EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
    ///       "fr": "Droit d’auteur #dates \(configuration.documentation.primaryAuthor!).",
    ///       "es": "Derecho de autor #dates \(configuration.documentation.primaryAuthor!)."
    ///     ]
    ///   })
    ///
    /// configuration.documentation.primaryAuthor = "John Doe"
    /// ```
    .library(name: "WorkspaceConfiguration", targets: ["WorkspaceConfiguration"]),

    /// Workspace.
    .executable(name: "workspace", targets: ["WorkspaceTool"]),
    /// Arbeitsbereich.
    .executable(name: "arbeitsbereich", targets: ["WorkspaceTool"])
  ],
  dependencies: [
    .package(
      url: "https://github.com/SDGGiesbrecht/SDGCornerstone",
      from: Version(4, 5, 0)
    ),
    .package(
      url: "https://github.com/SDGGiesbrecht/SDGCommandLine",
      from: Version(1, 3, 1)
    ),
    .package(
      url: "https://github.com/SDGGiesbrecht/SDGSwift",
      .upToNextMinor(from: Version(0, 19, 3))
    ),
    .package(
      url: "https://github.com/apple/swift\u{2D}package\u{2D}manager",
      .exact(Version(0, 5, 0))
    ),
    .package(
      url: "https://github.com/SDGGiesbrecht/swift\u{2D}format",
      .exact(Version(0, 0, 50100))
    ),
    .package(url: "https://github.com/SDGGiesbrecht/SDGWeb", from: Version(5, 1, 2))
  ],
  targets: [
    // The executable. (Multiple products duplicate this with localized names.)
    .target(name: "WorkspaceTool", dependencies: [.target(name: "WorkspaceLibrary")]),
    // The umbrella library. (Shared by the various localized executables.)
    .target(
      name: "WorkspaceLibrary",
      dependencies: [
        "WSGeneralImports",
        "WorkspaceProjectConfiguration",
        "WSInterface"
      ]
    ),

    // Components

    // Defines the public command line interface.
    .target(
      name: "WSInterface",
      dependencies: [
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
        "WSDocumentation",
        .product(name: "SDGVersioning", package: "SDGCornerstone")
      ]
    ),

    // Workspace scripts.
    .target(
      name: "WSScripts",
      dependencies: [
        "WSGeneralImports",
        "WSProject"
      ]
    ),

    // Git management.
    .target(
      name: "WSGit",
      dependencies: [
        "WSGeneralImports",
        "WSProject"
      ]
    ),

    // Open source management.
    .target(
      name: "WSOpenSource",
      dependencies: [
        "WSGeneralImports",
        "WSProject",
        "WSExamples",
        "WSDocumentation",
        .product(name: "SDGSwiftSource", package: "SDGSwift")
      ]
    ),

    // Licence management.
    .target(
      name: "WSLicence",
      dependencies: [
        "WSGeneralImports",
        "WorkspaceConfiguration",
        "WSProject"
      ]
    ),

    // GitHub management.
    .target(
      name: "WSGitHub",
      dependencies: [
        "WSGeneralImports",
        "WSProject",
        "WorkspaceProjectConfiguration"
      ]
    ),

    // Continuous integration management.
    .target(
      name: "WSContinuousIntegration",
      dependencies: [
        "WSGeneralImports",
        "WSProject",
        "WSScripts",
        "WSDocumentation",
        .product(name: "SDGSwiftPackageManager", package: "SDGSwift"),
        .product(name: "SDGSwiftSource", package: "SDGSwift"),
        .product(name: "SwiftPM\u{2D}auto", package: "swift\u{2D}package\u{2D}manager"),
        .product(name: "SwiftFormat", package: "swift\u{2D}format")
      ]
    ),

    // Resource management.
    .target(
      name: "WSResources",
      dependencies: [
        "WSGeneralImports",
        "WSProject",
        "WSSwift",
        .product(name: "SDGSwiftPackageManager", package: "SDGSwift"),
        .product(name: "SwiftFormat", package: "swift\u{2D}format")
      ]
    ),

    // File header management.
    .target(
      name: "WSFileHeaders",
      dependencies: [
        "WSGeneralImports",
        "WSProject"
      ]
    ),

    // Example management.
    .target(
      name: "WSExamples",
      dependencies: [
        "WSGeneralImports",
        "WSProject",
        "WSParsing"
      ]
    ),

    // Normalization.
    .target(
      name: "WSNormalization",
      dependencies: [
        "WSGeneralImports",
        "WSProject",
        .product(name: "SwiftFormatConfiguration", package: "swift\u{2D}format"),
        .product(name: "SwiftFormat", package: "swift\u{2D}format")
      ]
    ),

    // Xcode project management.
    .target(
      name: "WSXcode",
      dependencies: [
        "WSGeneralImports",
        "WSProject",
        "WorkspaceProjectConfiguration",
        .product(name: "SDGXcode", package: "SDGSwift")
      ]
    ),

    // Proofreading.
    .target(
      name: "WSProofreading",
      dependencies: [
        "WSGeneralImports",
        "WSProject",
        "WSCustomTask",
        .product(name: "SDGCollections", package: "SDGCornerstone"),
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
        .product(name: "SDGVersioning", package: "SDGCornerstone"),
        .product(name: "SDGSwiftSource", package: "SDGSwift"),
        .product(name: "SwiftFormat", package: "swift\u{2D}format")
      ]
    ),

    // Testing.
    .target(
      name: "WSTesting",
      dependencies: [
        "WSGeneralImports",
        "WSProject",
        "WSValidation",
        "WSContinuousIntegration",
        "WSProofreading",
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
        .product(name: "SDGSwiftPackageManager", package: "SDGSwift"),
        .product(name: "SDGXcode", package: "SDGSwift")
      ]
    ),

    // Documentation generation.
    .target(
      name: "WSDocumentation",
      dependencies: [
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
      ],
      swiftSettings: [
        .define("UNIDENTIFIED_SYNTAX_WARNINGS", .when(configuration: .debug))
      ]
    ),

    // Mechanism for embedding third party tools.
    .target(
      name: "WSCustomTask",
      dependencies: [
        "WSGeneralImports",
        "WorkspaceConfiguration",
        .product(name: "SDGSwift", package: "SDGSwift"),
        .product(name: "SDGExternalProcess", package: "SDGCornerstone")
      ]
    ),

    // Utilities for validation reports.
    .target(
      name: "WSValidation",
      dependencies: [
        "WSGeneralImports",
        "WSProject"
      ]
    ),

    // Utilities related to Swift syntax.
    .target(
      name: "WSSwift",
      dependencies: [
        "WSGeneralImports"
      ]
    ),

    // Utilities related to parsing in‐source declarations and directives.
    .target(
      name: "WSParsing",
      dependencies: [
        "WSGeneralImports",
        "WSLocalizations",
        "WSProject"
      ]
    ),

    // Defines general project structure queries and cache.
    .target(
      name: "WSProject",
      dependencies: [
        "WSGeneralImports",
        "WorkspaceConfiguration",
        "WorkspaceProjectConfiguration",
        .product(name: "SDGCalendar", package: "SDGCornerstone"),
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
        .product(name: "SDGVersioning", package: "SDGCornerstone"),
        .product(name: "SDGSwiftPackageManager", package: "SDGSwift"),
        .product(name: "SDGSwiftConfigurationLoading", package: "SDGSwift")
      ],
      swiftSettings: [
        .define("CACHE_LOG", .when(configuration: .debug))
      ]
    ),

    // @localization(🇩🇪DE)
    // #documentation(ArbeitsbereichKonfiguration)
    /// Die Wurzel der Programmierschnittstelle für Konfigurationsdateien.
    ///
    /// Arbeitsbereich kann durch eine Swift‐Datei Namens `Arbeitsbereich.swift` im Projektwurzel konfiguriert werden.
    ///
    /// Der Inhalt einer Konfigurationsdatei könnte etwa so aussehen:
    ///
    /// ```swift
    /// import WorkspaceConfiguration
    ///
    /// /*
    ///  Externe Pakete sind mit dieser Syntax einführbar:
    ///  import [Modul] // [Ressourcenzeiger], [Version], [Produkt]
    ///  */
    /// import SDGControlFlow  // https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
    ///
    /// let konfiguration = ArbeitsbereichKonfiguration()
    /// konfiguration.alleAufgabenEinschalten()
    ///
    /// konfiguration.unterstützteSchichte = [.macOS, .windows, .linux, .android]
    ///
    /// konfiguration.dokumentation.aktuelleVersion = Version(1, 0, 0)
    /// konfiguration.dokumentation.projektSeite = URL(string: "projekt.de")
    /// konfiguration.dokumentation
    ///   .dokumentationsRessourcenzeiger = URL(string: "projekt.de/Dokumentation")
    /// konfiguration.dokumentation
    ///   .lagerRessourcenzeiger = URL(string: "https://github.com/Benutzer/Projekt")
    ///
    /// konfiguration.dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung = 2017
    ///
    /// konfiguration.dokumentation.lokalisationen = ["🇩🇪DE", "fr"]
    /// konfiguration.dokumentation.programmierschnittstelle.urheberrechtsschutzvermerk =
    ///   BequemeEinstellung<[Lokalisationskennzeichen: StrengeZeichenkette]>(auswerten: { konfiguration in
    ///     return [
    ///       "🇩🇪DE": "Urheberrecht #daten \(konfiguration.dokumentation.hauptautor!).",
    ///       "fr": "Droit d’auteur #daten \(konfiguration.dokumentation.hauptautor!)."
    ///     ]
    ///   })
    ///
    /// konfiguration.dokumentation.hauptautor = "Max Mustermann"
    /// ```
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
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
    /// import SDGControlFlow  // https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
    ///
    /// let configuration = WorkspaceConfiguration()
    /// configuration.optIntoAllTasks()
    ///
    /// configuration.supportedPlatforms = [.macOS, .windows, .linux, .android]
    ///
    /// configuration.documentation.currentVersion = Version(1, 0, 0)
    /// configuration.documentation.projectWebsite = URL(string: "project.uk")
    /// configuration.documentation.documentationURL = URL(string: "project.uk/Documentation")
    /// configuration.documentation.repositoryURL = URL(string: "https://github.com/User/Project")
    ///
    /// configuration.documentation.api.yearFirstPublished = 2017
    ///
    /// configuration.documentation.localisations = ["🇬🇧EN", "🇺🇸EN", "🇨🇦EN", "fr", "es"]
    /// configuration.documentation.api.copyrightNotice = Lazy<[LocalisationIdentifier: StrictString]>(
    ///   resolve: { configuration in
    ///     return [
    ///       "🇬🇧EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
    ///       "🇺🇸EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
    ///       "🇨🇦EN": "Copyright #dates \(configuration.documentation.primaryAuthor!).",
    ///       "fr": "Droit d’auteur #dates \(configuration.documentation.primaryAuthor!).",
    ///       "es": "Derecho de autor #dates \(configuration.documentation.primaryAuthor!)."
    ///     ]
    ///   })
    ///
    /// configuration.documentation.primaryAuthor = "John Doe"
    /// ```
    .target(
      name: "WorkspaceConfiguration",
      dependencies: [
        "WSLocalizations",
        .product(name: "SDGControlFlow", package: "SDGCornerstone"),
        .product(name: "SDGLogic", package: "SDGCornerstone"),
        .product(name: "SDGCollections", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGPersistence", package: "SDGCornerstone"),
        .product(name: "SDGLocalization", package: "SDGCornerstone"),
        .product(name: "SDGCalendar", package: "SDGCornerstone"),
        .product(name: "SDGVersioning", package: "SDGCornerstone"),
        .product(name: "SDGSwiftConfiguration", package: "SDGSwift"),
        .product(name: "SwiftFormatConfiguration", package: "swift\u{2D}format")
      ]
    ),

    // Defines the lists of supported localizations.
    .target(
      name: "WSLocalizations",
      dependencies: [
        .product(name: "SDGLocalization", package: "SDGCornerstone")
      ]
    ),

    // Centralizes imports needed almost everywhere.
    .target(
      name: "WSGeneralImports",
      dependencies: [
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
      ]
    ),

    // Tests

    .target(
      name: "WSGeneralTestImports",
      dependencies: [
        "WSGeneralImports",
        "WorkspaceConfiguration",
        "WSInterface",
        .product(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGLocalizationTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGCommandLineTestUtilities", package: "SDGCommandLine")
      ]
    ),
    .testTarget(
      name: "WorkspaceLibraryTests",
      dependencies: [
        "WSGeneralTestImports",
        "WSCustomTask",
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
        .product(name: "SDGCommandLine", package: "SDGCommandLine"),
        .product(name: "SDGHTML", package: "SDGWeb"),
        .product(name: "SDGWeb", package: "SDGWeb")
      ]
    ),
    .target(
      name: "test‐ios‐simulator",
      dependencies: [
        "WSGeneralImports",
        "WSInterface",
        .product(name: "SDGExternalProcess", package: "SDGCornerstone")
      ],
      path: "Tests/test‐ios‐simulator"
    ),
    .target(
      name: "test‐tvos‐simulator",
      dependencies: [
        "WSGeneralImports",
        "WSInterface",
        .product(name: "SDGExternalProcess", package: "SDGCornerstone")
      ],
      path: "Tests/test‐tvos‐simulator"
    ),
    .target(
      name: "WSCrossPlatform",
      dependencies: [
        "WSCrossPlatformC",
        .product(name: "SwiftFormatConfiguration", package: "swift\u{2D}format")
      ],
      path: "Tests/WSCrossPlatform"
    ),
    .target(
      name: "WSCrossPlatform‐Unicode",
      dependencies: ["WSCrossPlatform"],
      path: "Tests/WSCrossPlatform‐Unicode"
    ),
    .target(
      name: "WSCrossPlatformTool",
      dependencies: ["WSCrossPlatform"],
      path: "Tests/WSCrossPlatformTool"
    ),
    .testTarget(
      name: "WSCrossPlatformTests",
      dependencies: [
        "WSCrossPlatform",
        .product(name: "SDGPersistence", package: "SDGCornerstone"),
        .product(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone")
      ]
    ),
    .target(
      name: "WSCrossPlatformC",
      path: "Tests/WSCrossPlatformC"
    ),

    .target(
      name: "WSConfigurationExample",
      dependencies: [
        "WorkspaceConfiguration",
        .product(name: "SDGControlFlow", package: "SDGCornerstone")
      ],
      path: "Tests/WSConfigurationExample"
    ),

    // Other

    // This allows Workspace to load and use a configuration from its own development state, instead of an externally available stable version.
    .target(
      name: "WorkspaceProjectConfiguration",
      dependencies: [
        "WorkspaceConfiguration"
      ],
      path: "",
      sources: ["Workspace.swift"]
    )
  ]
)

// #workaround(Swift 5.1.4, These cannot build on Windows.)
func adjustForWindows() {
  let impossibleDependencies: Set<String> = [
    "SwiftPM\u{2D}auto",
    "SwiftFormat"
  ]
  let impossibleTargets: Set<String> = [
    "WSCrossPlatform‐Unicode",
    "WSCrossPlatformC",
    "test‐ios‐simulator",
    "test‐tvos‐simulator"
  ]
  for target in package.targets {
    target.dependencies.removeAll(where: { dependency in
      #if compiler(<5.2)
        switch dependency {
        case ._targetItem(let name), ._byNameItem(let name):
          return impossibleTargets.contains(name)
        case ._productItem(let name, _):
          return impossibleDependencies.contains(name)
        }
      #else
        switch dependency {
        case ._targetItem(let name, _), ._byNameItem(let name, _):
          return impossibleTargets.contains(name)
        case ._productItem(let name, _, _):
          return impossibleDependencies.contains(name)
        }
      #endif
    })
  }
  package.targets.removeAll(where: { target in
    return impossibleTargets.contains(target.name)
  })
}
#if os(Windows)
  adjustForWindows()
#endif
import Foundation
// #workaround(Swift 5.1.4, Until packages work natively on windows.)
if ProcessInfo.processInfo.environment["GENERATING_CMAKE_FOR_WINDOWS"] == "true" {
  adjustForWindows()
}

func adjustForWeb() {
  // #warning(Not all of these are necessary.)
  package.products.removeAll()
  package.targets.removeAll()
}
if ProcessInfo.processInfo.environment["TARGETING_WEB"] == "true" {
  adjustForWeb()
}

func adjustForAndroid() {
  let impossibleDependencies: Set<String> = [
    "SwiftPM\u{2D}auto",
    "SwiftFormat"
  ]
  for target in package.targets {
    target.dependencies.removeAll(where: { dependency in
      #if compiler(<5.2)
        switch dependency {
        case ._targetItem, ._byNameItem:
          return false
        case ._productItem(let name, _):
          return impossibleDependencies.contains(name)
        }
      #else
        switch dependency {
        case ._targetItem, ._byNameItem:
          return false
        case ._productItem(let name, _, _):
          return impossibleDependencies.contains(name)
        }
      #endif
    })
  }
}
#if os(Android)
  adjustForAndroid()
#endif
import Foundation
if ProcessInfo.processInfo.environment["TARGETING_ANDROID"] == "true" {
  adjustForAndroid()
}
