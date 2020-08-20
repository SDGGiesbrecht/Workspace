// swift-tools-version:5.2

/*
 Package.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
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
/// - Verwaltet Projekte für macOS, Windows, Netz, CentOS, Ubuntu, tvOS, iOS, Android, Amazon Linux und watchOS.
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
/// - Manages projects for macOS, Windows, web, CentOS, Ubuntu, tvOS, iOS, Android, Amazon Linux and watchOS.
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
/// - Manages projects for macOS, Windows, web, CentOS, Ubuntu, tvOS, iOS, Android, Amazon Linux and watchOS.
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
/// - Manages projects for macOS, Windows, web, CentOS, Ubuntu, tvOS, iOS, Android, Amazon Linux and watchOS.
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
    ///  import [Modul] // [Paket], [Ressourcenzeiger], [Version], [Produkt]
    ///  */
    /// import SDGControlFlow
    /// // SDGCornerstone, https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
    ///
    /// let konfiguration = ArbeitsbereichKonfiguration()
    /// konfiguration.alleAufgabenEinschalten()
    ///
    /// konfiguration.unterstützteSchichte = [.macOS, .windows, .ubuntu, .android]
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
    ///   BequemeEinstellung<[Lokalisationskennzeichen: StrengeZeichenkette]>(
    ///     auswerten: { konfiguration in
    ///       return [
    ///         "🇩🇪DE": "Urheberrecht #daten \(konfiguration.dokumentation.hauptautor!).",
    ///         "fr": "Droit d’auteur #daten \(konfiguration.dokumentation.hauptautor!).",
    ///       ]
    ///     }
    ///   )
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
    ///  import [module] // [package], [url], [version], [product]
    ///  */
    /// import SDGControlFlow
    /// // SDGCornerstone, https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
    ///
    /// let configuration = WorkspaceConfiguration()
    /// configuration.optIntoAllTasks()
    ///
    /// configuration.supportedPlatforms = [.macOS, .windows, .ubuntu, .android]
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
    ///       "es": "Derecho de autor #dates \(configuration.documentation.primaryAuthor!).",
    ///     ]
    ///   })
    ///
    /// configuration.documentation.primaryAuthor = "John Doe"
    /// ```
    .library(name: "WorkspaceConfiguration", targets: ["WorkspaceConfiguration"]),

    /// Workspace.
    .executable(name: "workspace", targets: ["WorkspaceTool"]),
    /// Arbeitsbereich.
    .executable(name: "arbeitsbereich", targets: ["WorkspaceTool"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/SDGGiesbrecht/SDGCornerstone",
      from: Version(5, 5, 0)
    ),
    .package(
      url: "https://github.com/SDGGiesbrecht/SDGCommandLine",
      from: Version(1, 5, 0)
    ),
    .package(
      url: "https://github.com/SDGGiesbrecht/SDGSwift",
      from: Version(2, 1, 1)
    ),
    .package(
      name: "SwiftPM",
      url: "https://github.com/apple/swift\u{2D}package\u{2D}manager",
      .exact(Version(0, 6, 0))
    ),
    .package(
      name: "SwiftSyntax",
      url: "https://github.com/apple/swift\u{2D}syntax",
      .exact(Version(0, 50200, 0))
    ),
    .package(
      url: "https://github.com/apple/swift\u{2D}format",
      .exact(Version(0, 50200, 1))
    ),
    .package(url: "https://github.com/SDGGiesbrecht/SDGWeb", from: Version(5, 4, 0)),
  ],
  targets: [
    // The executable. (Multiple products duplicate this with localized names.)
    .target(name: "WorkspaceTool", dependencies: [.target(name: "WorkspaceImplementation")]),
    // The umbrella library. (Shared by the various localized executables.)
    .target(
      name: "WorkspaceImplementation",
      dependencies: [
        "WSGeneralImports",
        "WorkspaceConfiguration",
        "WorkspaceProjectConfiguration",
        "WSProject",
        "WSValidation",
        "WSSwift",
        "WSParsing",
        "WSXcode",
        "WSProofreading",
        "WSDocumentation",
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
        .product(name: "SDGVersioning", package: "SDGCornerstone"),
        .product(name: "SDGSwiftPackageManager", package: "SDGSwift"),
        .product(name: "SDGSwiftSource", package: "SDGSwift"),
        .product(name: "SDGXcode", package: "SDGSwift"),
        .product(name: "SwiftPM\u{2D}auto", package: "SwiftPM"),
        .product(name: "SwiftFormatConfiguration", package: "swift\u{2D}format"),
        .product(name: "SwiftFormat", package: "swift\u{2D}format"),
      ]
    ),

    // Components

    // Xcode project management.
    .target(
      name: "WSXcode",
      dependencies: [
        "WSGeneralImports",
        "WSProject",
        "WorkspaceProjectConfiguration",
        .product(name: "SDGXcode", package: "SDGSwift"),
      ]
    ),

    // Proofreading.
    .target(
      name: "WSProofreading",
      dependencies: [
        "WSGeneralImports",
        "WSProject",
        "WSCustomTask",
        .product(name: "SDGLogic", package: "SDGCornerstone"),
        .product(name: "SDGCollections", package: "SDGCornerstone"),
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
        .product(name: "SDGVersioning", package: "SDGCornerstone"),
        .product(name: "SDGSwiftSource", package: "SDGSwift"),
        .product(name: "SwiftFormat", package: "swift\u{2D}format"),
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
        .product(name: "SDGCSS", package: "SDGWeb"),
        .product(name: "SwiftSyntax", package: "SwiftSyntax"),
      ]
    ),

    // Mechanism for embedding third party tools.
    .target(
      name: "WSCustomTask",
      dependencies: [
        "WSGeneralImports",
        "WorkspaceConfiguration",
        .product(name: "SDGSwift", package: "SDGSwift"),
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
      ]
    ),

    // Utilities for validation reports.
    .target(
      name: "WSValidation",
      dependencies: [
        "WSGeneralImports",
        "WSProject",
      ]
    ),

    // Utilities related to Swift syntax.
    .target(
      name: "WSSwift",
      dependencies: [
        "WSGeneralImports",
        "WorkspaceConfiguration",
        .product(name: "SwiftSyntax", package: "SwiftSyntax"),
        .product(name: "SDGSwiftSource", package: "SDGSwift"),
        .product(name: "SwiftFormat", package: "swift\u{2D}format"),
      ]
    ),

    // Utilities related to parsing in‐source declarations and directives.
    .target(
      name: "WSParsing",
      dependencies: [
        "WSGeneralImports",
        "WSLocalizations",
        "WSProject",
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
        .product(name: "SDGSwiftConfigurationLoading", package: "SDGSwift"),
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
    ///  import [Modul] // [Paket], [Ressourcenzeiger], [Version], [Produkt]
    ///  */
    /// import SDGControlFlow
    /// // SDGCornerstone, https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
    ///
    /// let konfiguration = ArbeitsbereichKonfiguration()
    /// konfiguration.alleAufgabenEinschalten()
    ///
    /// konfiguration.unterstützteSchichte = [.macOS, .windows, .ubuntu, .android]
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
    ///   BequemeEinstellung<[Lokalisationskennzeichen: StrengeZeichenkette]>(
    ///     auswerten: { konfiguration in
    ///       return [
    ///         "🇩🇪DE": "Urheberrecht #daten \(konfiguration.dokumentation.hauptautor!).",
    ///         "fr": "Droit d’auteur #daten \(konfiguration.dokumentation.hauptautor!).",
    ///       ]
    ///     }
    ///   )
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
    ///  import [module] // [package], [url], [version], [product]
    ///  */
    /// import SDGControlFlow
    /// // SDGCornerstone, https://github.com/SDGGiesbrecht/SDGCornerstone, 0.10.0, SDGControlFlow
    ///
    /// let configuration = WorkspaceConfiguration()
    /// configuration.optIntoAllTasks()
    ///
    /// configuration.supportedPlatforms = [.macOS, .windows, .ubuntu, .android]
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
    ///       "es": "Derecho de autor #dates \(configuration.documentation.primaryAuthor!).",
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
        .product(name: "SwiftFormatConfiguration", package: "swift\u{2D}format"),
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

        .product(name: "SDGSwift", package: "SDGSwift"),
      ]
    ),

    // Tests

    .target(
      name: "WSGeneralTestImports",
      dependencies: [
        "WSGeneralImports",
        "WorkspaceConfiguration",
        "WorkspaceImplementation",
        .product(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGLocalizationTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGCommandLineTestUtilities", package: "SDGCommandLine"),
      ]
    ),
    .testTarget(
      name: "WorkspaceTests",
      dependencies: [
        "WSGeneralTestImports",
        "WSCustomTask",
        "WorkspaceProjectConfiguration",
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
        .product(name: "SDGCommandLine", package: "SDGCommandLine"),
        .product(name: "SDGHTML", package: "SDGWeb"),
        .product(name: "SDGWeb", package: "SDGWeb"),
      ]
    ),
    .target(
      name: "test‐ios‐simulator",
      dependencies: [
        "WSGeneralImports",
        "WorkspaceImplementation",
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
      ],
      path: "Tests/test‐ios‐simulator"
    ),
    .target(
      name: "test‐tvos‐simulator",
      dependencies: [
        "WSGeneralImports",
        "WorkspaceImplementation",
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
      ],
      path: "Tests/test‐tvos‐simulator"
    ),
    .target(
      name: "WSCrossPlatform",
      dependencies: [
        "WSCrossPlatformC",
        .product(name: "SwiftFormatConfiguration", package: "swift\u{2D}format"),
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
        .product(name: "SDGExternalProcess", package: "SDGCornerstone"),
        .product(name: "SDGVersioning", package: "SDGCornerstone"),
        .product(name: "SDGSwift", package: "SDGSwift"),
        .product(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone"),
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
        .product(name: "SDGControlFlow", package: "SDGCornerstone"),
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
    ),
  ]
)

import Foundation
if ProcessInfo.processInfo.environment["TARGETING_WINDOWS"] == "true" {
  // #workaround(Swift 5.2.4, These cannot build on Windows.)
  let impossibleDependencies = [
    "SwiftPM",
    "SwiftSyntax",
    "SwiftFormat\u{22}",
  ]
  for target in package.targets {
    target.dependencies.removeAll(where: { dependency in
      return impossibleDependencies.contains(where: { impossible in
        "\(dependency)".contains(impossible)
      })
    })
  }
}

if ProcessInfo.processInfo.environment["TARGETING_ANDROID"] == "true" {
  // #workaround(Swift 5.2.4, These cannot build on Android.)
  let impossibleDependencies = [
    "SwiftPM",
    "SwiftSyntax",
    "SwiftFormat\u{22}",
  ]
  for target in package.targets {
    target.dependencies.removeAll(where: { dependency in
      return impossibleDependencies.contains(where: { impossible in
        "\(dependency)".contains(impossible)
      })
    })
  }
}

if ProcessInfo.processInfo.environment["TARGETING_WEB"] == "true" {
  // #workaround(Swift 5.2.4, Web won’t resolve manifests with dynamic libraries.)
  let impossiblePackages: [String] = [
    "swift\u{2D}package\u{2D}manager"
  ]
  package.dependencies.removeAll(where: { dependency in
    for impossible in impossiblePackages {
      if dependency.url.hasSuffix(impossible) {
        return true
      }
    }
    return false
  })
  // #workaround(Swift 5.2.4, Cannot build for web.)
  let impossibleDependencies: Set<String> = [
    // SwiftFormat
    "SwiftFormat\u{22}",
    "SwiftFormatConfiguration",
    // SwiftPM
    "SwiftPM",
    // SwiftSyntax
    "SwiftSyntax",
  ]
  for target in package.targets {
    target.dependencies.removeAll(where: { dependency in
      return impossibleDependencies.contains(where: { impossible in
        return "\(dependency)".contains(impossible)
      })
    })
  }
  for target in package.targets {
    // #workaround(Swift 5.2.4, Web lacks Foundation.)
    target.exclude.append("Resources.swift")
  }
}

// Windows Tests (Generated automatically by Workspace.)
import Foundation
if ProcessInfo.processInfo.environment["TARGETING_WINDOWS"] == "true" {
  var tests: [Target] = []
  var other: [Target] = []
  for target in package.targets {
    if target.type == .test {
      tests.append(target)
    } else {
      other.append(target)
    }
  }
  package.targets = other
  package.targets.append(
    contentsOf: tests.map({ test in
      return .target(
        name: test.name,
        dependencies: test.dependencies,
        path: test.path ?? "Tests/\(test.name)",
        exclude: test.exclude,
        sources: test.sources,
        publicHeadersPath: test.publicHeadersPath,
        cSettings: test.cSettings,
        cxxSettings: test.cxxSettings,
        swiftSettings: test.swiftSettings,
        linkerSettings: test.linkerSettings
      )
    })
  )
  package.targets.append(
    .target(
      name: "WindowsTests",
      dependencies: tests.map({ Target.Dependency.target(name: $0.name) }),
      path: "Tests/WindowsTests"
    )
  )
}
// End Windows Tests
