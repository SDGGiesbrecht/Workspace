/*
 DocumentationConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

import WorkspaceLocalizations

// @localization(🇩🇪DE) @crossReference(DocumentationConfiguration)
/// Einstellungen zur Dokumentation.
public typealias Dokumentationseinstellungen = DocumentationConfiguration
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(DocumentationConfiguration)
/// Options related to documentation.
public struct DocumentationConfiguration: Codable {

  // MARK: - Properties

  // @localization(🇺🇸EN)
  /// The localizations supported by the project.
  ///
  /// The default contains no localizations, but some tasks may throw errors if they require localizations to be specified.
  ///
  /// ### Localizing Documentation
  ///
  /// When documenting with more than one localization active, each documentation comment must be marked according to its localization.
  ///
  /// ```swift
  /// // @localization(🇪🇸ES)
  /// /// Verifica la desigualdad.
  /// // @localization(🇺🇸EN) @localization(🇬🇧EN)
  /// /// Checks for inequality.
  /// infix operator ≠
  /// ```
  ///
  /// Localized versions of a symbol can be cross‐referenced with each other so that they will be treated as the same symbol. In the following example, `doSomething()` will only appear in the English documentation and `hacerAlgo()` will only appear in the Spanish documentation. Switching the language while looking at one of them will display the opposite function.
  ///
  /// ```swift
  /// // @localization(🇺🇸EN) @localization(🇬🇧EN) @crossReference(doSomething)
  /// /// Does something.
  /// public func doSomething() {}
  /// // @localization(🇪🇸ES) @crossReference(doSomething)
  /// /// Hace algo.
  /// public func hacerAlgo() {}
  /// ```
  ///
  /// A set of cross references can opt out of a particular localization. This can be useful when providing aliases for something that pre‐exists in only some of the localizations.
  ///
  /// ```swift
  /// // @localization(🇪🇸ES) @notLocalized(🇺🇸EN)
  /// /// Una cadena de caracteres.
  /// public typealias CadenaDeCaracteres = String
  /// ```
  // @localization(🇨🇦EN) @crossReference(DocumentationConfiguration.localizations)
  /// The localizations supported by the project.
  ///
  /// The default contains no localizations, but some tasks may throw errors if they require localizations to be specified.
  ///
  /// ### Localizing Documentation
  ///
  /// When documenting with more than one localization active, each documentation comment must be marked according to its localization.
  ///
  /// ```swift
  /// // @localization(🇫🇷FR)
  /// /// Vérifie l’inégalité.
  /// // @localization(🇨🇦EN) @localization(🇬🇧EN)
  /// /// Checks for inequality.
  /// infix operator ≠
  /// ```
  ///
  /// Localized versions of a symbol can be cross‐referenced with each other so that they will be treated as the same symbol. In the following example, `doSomething()` will only appear in the English documentation and `faireQuelqueChose()` will only appear in the French documentation. Switching the language while looking at one of them will display the opposite function.
  ///
  /// ```swift
  /// // @localization(🇨🇦EN) @localization(🇬🇧EN) @crossReference(doSomething)
  /// /// Does something.
  /// public func doSomething() {}
  /// // @localization(🇫🇷FR) @crossReference(doSomething)
  /// /// Fait quelque chose.
  /// public func faireQuelqueChose() {}
  /// ```
  ///
  /// A set of cross references can opt out of a particular localization. This can be useful when providing aliases for something that pre‐exists in only some of the localizations.
  ///
  /// ```swift
  /// // @localization(🇫🇷FR) @notLocalized(🇨🇦EN)
  /// /// Une chaîne de caractères.
  /// public typealias ChaîneDeCaractères = String
  /// ```
  public var localizations: [LocalizationIdentifier] = []
  // @localization(🇬🇧EN) @crossReference(DocumentationConfiguration.localizations)
  /// The localisations supported by the project.
  ///
  /// The default contains no localisations, but some tasks may throw errors if they require localisations to be specified.
  ///
  /// ### Localising Documentation
  ///
  /// When documenting with more than one localisation active, each documentation comment must be marked according to its localisation.
  ///
  /// ```swift
  /// // @localization(🇫🇷FR)
  /// /// Vérifie l’inégalité.
  /// // @localization(🇬🇧EN) @localization(🇺🇸EN)
  /// /// Checks for inequality.
  /// infix operator ≠
  /// ```
  ///
  /// Localised versions of a symbol can be cross‐referenced with each other so that they will be treated as the same symbol. In the following example, `doSomething()` will only appear in the English documentation and `faireQuelqueChose()` will only appear in the French documentation. Switching the language while looking at one of them will display the opposite function.
  ///
  /// ```swift
  /// // @localization(🇬🇧EN) @localization(🇺🇸EN) @crossReference(doSomething)
  /// /// Does something.
  /// public func doSomething() {}
  /// // @localization(🇫🇷FR) @crossReference(doSomething)
  /// /// Fait quelque chose.
  /// public func faireQuelqueChose() {}
  /// ```
  ///
  /// A set of cross references can opt out of a particular localisation. This can be useful when providing aliases for something that pre‐exists in only some of the localisations.
  ///
  /// ```swift
  /// // @localization(🇫🇷FR) @notLocalised(🇬🇧EN)
  /// /// Une chaîne de caractères.
  /// public typealias ChaîneDeCaractères = String
  /// ```
  public var localisations: [LocalisationIdentifier] {
    get { return localizations }
    set { localizations = newValue }
  }
  // @localization(🇩🇪DE) @crossReference(DocumentationConfiguration.localizations)
  /// Die Lokalisationen des Projekts.
  ///
  /// Keine Lokalisationen sind voreingestellt, aber manche Aufgaben können Fehler werfen wenn keine Lokalisationen angegeben sind.
  ///
  /// ### Dokumentation lokalisieren
  ///
  /// Wenn mehrere Lokalisationen eingeschaltet sind, jeder Dokumentationskommentar muss mit einem Lokalisation markiert werden.
  ///
  /// ```swift
  /// // @lokalisation(🇫🇷FR)
  /// /// Vérifie l’inégalité.
  /// // @lokalisation(🇩🇪DE) @lokalisation(🇦🇹DE)
  /// /// Prüft die Ungleichheit.
  /// infix operator ≠
  /// ```
  ///
  /// Lokalisierte versionen eines Symbols können miteinander verknüpft werden, damit sie als ein einziges Symbol gehandelt werden. Im folgendes Beispiel, `etwasTun()` wird nur in der deutschen Dokumentation erscheinen. und `faireQuelqueChose()` wird nur in der französischen erscheinen. Das Umschalten von Sprachen auf der Seite von einem führt zum anderen.
  ///
  /// ```swift
  /// // @lokalisation(🇩🇪DE) @lokalisation(🇦🇹DE) @querverweis(etwasTun)
  /// /// Tut etwas.
  /// public func etwasTun() {}
  /// // @lokalisation(🇫🇷FR) @querverweis(etwasTun)
  /// /// Fait quelque chose.
  /// public func faireQuelqueChose() {}
  /// ```
  ///
  /// Eine Gruppe von Querverweisen können eine bestimmte Lokalisation ausschließen. Es kann nützlich sein, um etwas umzunennen, was in nur manche Lokalisationen schon existiert.
  ///
  /// ```swift
  /// // @lokalisation(🇩🇪DE) @notLocalised(🇬🇧EN)
  /// /// Eine Zeichenkette.
  /// public typealias Zeichenkette = String
  /// ```
  public var lokalisationen: [Lokalisationskennzeichen] {
    get { return localizations }
    set { localizations = newValue }
  }

  public var _localizationsOrSystemFallback: [LocalizationIdentifier] {
    let configured = localizations
    if ¬configured.isEmpty {
      return configured
    } else {
      return [LocalizationIdentifier(AnyLocalization.resolved())]
    }
  }
  internal var localizationsOrSystemFallback: [LocalizationIdentifier] {
    return _localizationsOrSystemFallback
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(DocumentationConfiguration.currentVersion)
  /// The semantic version of the current stable release of the project.
  public var currentVersion: Version?
  // @localization(🇩🇪DE) @crossReference(DocumentationConfiguration.currentVersion)
  /// Die bedeutende Version der aktuelle stabile Ausgabe des Projekts.
  public var aktuelleVersion: Version? {
    get { return currentVersion }
    set { currentVersion = newValue }
  }

  // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
  #if !os(WASI)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(DocumentationConfiguration.projectWebsite)
    /// The URL of the project website.
    public var projectWebsite: URL?
    // @localization(🇩🇪DE) @crossReference(DocumentationConfiguration.projectWebsite)
    /// Der einheitliche Ressourcenzeiger der Internetseite des Projekts.
    public var projektSeite: EinheitlicherRessourcenzeiger? {
      get { return projectWebsite }
      set { projectWebsite = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(DocumentationConfiguration.documentationURL)
    /// The root URL where Workspace‐generated API documentation is hosted.
    public var documentationURL: URL?
    // @localization(🇩🇪DE) @crossReference(DocumentationConfiguration.documentationURL)
    /// Der einheitliche Ressourcenzeiger der Wurzel der Seite wo die erstellte Dokumentation veröffentlicht wird.
    public var dokumentationsRessourcenzeiger: EinheitlicherRessourcenzeiger? {
      get { return documentationURL }
      set { documentationURL = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(DocumentationConfiguration.repositoryURL)
    /// The URL of the project repository.
    public var repositoryURL: URL?
    // @localization(🇩🇪DE) @crossReference(DocumentationConfiguration.repositoryURL)
    /// Der einheitliche Ressourcenzeiger des Projektlagers.
    public var lagerRessourcenzeiger: EinheitlicherRessourcenzeiger? {
      get { return repositoryURL }
      set { repositoryURL = newValue }
    }
  #endif

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(DocumentationConfiguration.primaryAuthor)
  /// The primary project author.
  public var primaryAuthor: StrictString?
  // @localization(🇩🇪DE) @crossReference(DocumentationConfiguration.primaryAuthor)
  /// Der Hauptautor des Projekts.
  public var hauptautor: StrengeZeichenkette? {
    get { return primaryAuthor }
    set { primaryAuthor = newValue }
  }

  // @localization(🇩🇪DE) @crossReference(DocumentationConfiguration.installationInstructions)
  /// Installationsanweisungen.
  ///
  /// Installationsanweisungen werden automatisch hergeleitet, wenn `lagerRessourcenzeiger` und `aktuelleVersion` angegeben sind.
  public var installationsanleitungen: BequemeEinstellung<[Lokalisationskennzeichen: Markdown]> {
    get { return installationInstructions }
    set { installationInstructions = newValue }
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(DocumentationConfiguration.installationInstructions)
  /// Installation instructions.
  ///
  /// Default instructions exist for executable products if `repositoryURL` and `currentVersion` are defined.
  public var installationInstructions: Lazy<[LocalizationIdentifier: Markdown]> = Lazy<
    [LocalizationIdentifier: Markdown]
  >(resolve: { (configuration: WorkspaceConfiguration) -> [LocalizationIdentifier: Markdown] in

    // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
    #if os(WASI)
      return [:]
    #else
      guard let packageURL = configuration.documentation.repositoryURL,
        let version = configuration.documentation.currentVersion
      else {
        return [:]
      }

      var result: [LocalizationIdentifier: StrictString] = [:]
      for localization in configuration.documentation.localizationsOrSystemFallback {
        if let provided = localization._reasonableMatch {
          result[localization] = localizedToolInstallationInstructions(
            packageURL: packageURL,
            version: version,
            localization: provided
          )
        }
      }
      return result
    #endif
  })

  // @localization(🇩🇪DE) @crossReference(DocumentationConfiguration.importingInstructions)
  /// Einführungsanweisungen.
  ///
  /// Einführungssanweisungen werden automatisch davon hergeleitet, wenn `lagerRessourcenzeiger` und `aktuelleVersion` angegeben sind.
  public var einführungsanleitungen: BequemeEinstellung<[Lokalisationskennzeichen: Markdown]> {
    get { return importingInstructions }
    set { importingInstructions = newValue }
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(DocumentationConfiguration.importingInstructions)
  /// Importing instructions.
  ///
  /// Default instructions exist for library products if `repositoryURL` and `currentVersion` are defined.
  public var importingInstructions: Lazy<[LocalizationIdentifier: Markdown]> = Lazy<
    [LocalizationIdentifier: Markdown]
  >(resolve: { (configuration: WorkspaceConfiguration) -> [LocalizationIdentifier: Markdown] in

    // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
    #if os(WASI)
      return [:]
    #else
      guard let packageURL = configuration.documentation.repositoryURL,
        let version = configuration.documentation.currentVersion
      else {
        return [:]
      }

      var result: [LocalizationIdentifier: StrictString] = [:]
      for localization in configuration.documentation.localizationsOrSystemFallback {
        if let provided = localization._reasonableMatch {
          result[localization] = localizedLibraryImportingInstructions(
            packageURL: packageURL,
            version: version,
            localization: provided
          )
        }
      }
      return result
    #endif
  })

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(DocumentationConfiguration.about)
  /// The about section.
  public var about: [LocalizationIdentifier: Markdown] = [:]
  // @localization(🇩🇪DE) @crossReference(DocumentationConfiguration.about)
  /// Die „Über“‐Abschnitt.
  public var über: [Lokalisationskennzeichen: Markdown] {
    get { return about }
    set { about = newValue }
  }

  // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
  #if !os(WASI)
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    // @crossReference(DocumentationConfiguration.relatedProjects)
    /// A list of related projects.
    public var relatedProjects: [RelatedProjectEntry] = []
    // @localization(🇩🇪DE) @crossReference(DocumentationConfiguration.relatedProjects)
    /// Eine Liste verwandter Projekte.
    public var verwandteProjekte: [EintragZuVerwantdenProjekten] {
      get { return relatedProjects }
      set { relatedProjects = newValue }
    }
  #endif

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(DocumentationConfiguration.readMe)
  /// Options related to the project read‐me.
  public var readMe: ReadMeConfiguration = ReadMeConfiguration()
  // @localization(🇩🇪DE) @crossReference(DocumentationConfiguration.readMe)
  /// Einstellungen zur Lies‐mich Datei des Projekts.
  public var liesMich: LiesMichEinstellungen {
    get { return readMe }
    set { readMe = newValue }
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(DocumentationConfiguration.api)
  /// Options related to API documentation.
  public var api: APIDocumentationConfiguration = APIDocumentationConfiguration()
  // @localization(🇩🇪DE) @crossReference(DocumentationConfiguration.api)
  /// Einstellungen zur Lies‐mich Datei des Projekts.
  public var programmierschnittstelle: Programmierschnittstellendokumentationseinstellungen {
    get { return api }
    set { api = newValue }
  }

  // MARK: - Installation Instructions

  // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
  #if !os(WASI)
    private static func localizedToolInstallationInstructions(
      packageURL: URL,
      version: Version,
      localization: ContentLocalization
    ) -> StrictString? {

      let tools = WorkspaceContext.current.manifest.products.filter { $0.type == .executable }

      guard ¬tools.isEmpty else {
        return nil
      }

      let projectName = WorkspaceContext.current.manifest.packageName
      let toolNames = tools.map { $0.name }

      return [
        UserFacing<StrictString, ContentLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            var result: StrictString = "\(projectName) provides "
            if tools.count == 1 {
              result += "a command line tool"
            } else {
              result += "command line tools"
            }
            result += "."
            return result
          case .deutschDeutschland:
            var result: StrictString = "\(projectName) stellt "
            if tools.count == 1 {
              result += "ein Befehlszeilenprogramm"
            } else {
              result += "Befehlszeilenprogramme"
            }
            result += " bereit."
            return result
          }
        }).resolved(for: localization),
        "",
        UserFacing<StrictString, ContentLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            var result: StrictString = ""
            if tools.count == 1 {
              result += "It"
            } else {
              result += "They"
            }
            result +=
              " can be installed any way Swift packages can be installed. The most direct method is pasting the following into a terminal, which will either install or update "
            if tools.count == 1 {
              result += "it"
            } else {
              result += "them"
            }
            result += ":"
            return result
          case .deutschDeutschland:
            var result: StrictString = ""
            if tools.count == 1 {
              result += "Es kann"
            } else {
              result += "Sie können"
            }
            result +=
              " installiert werden nach allen Methoden, die Swift‐Pakete unterstützen. Die direkteste ist, folgendes im Terminal einzugeben. Somit "
            if tools.count == 1 {
              result += "wird es"
            } else {
              result += "werden sie"
            }
            result += " entweder installiert oder aktualisiert:"
            return result
          }
        }).resolved(for: localization),
        "",
        "```shell",
        "curl \u{2D}sL https://gist.github.com/SDGGiesbrecht/4d76ad2f2b9c7bf9072ca1da9815d7e2/raw/update.sh | bash \u{2D}s \(projectName) \u{22}\(packageURL.absoluteString)\u{22} \(version.string()) \u{22}\(toolNames.first!) help\u{22} \(toolNames.joined(separator: " "))",
        "```",
      ].joinedAsLines()
    }

    private static func localizedLibraryImportingInstructions(
      packageURL: URL,
      version: Version,
      localization: ContentLocalization
    ) -> StrictString? {

      let libraries = WorkspaceContext.current.manifest.products.filter { $0.type == .library }

      guard ¬libraries.isEmpty else {
        return nil
      }

      let packageName = WorkspaceContext.current.manifest.packageName
      let projectName = packageName

      var versionSpecification: StrictString
      if version.major == 0 {
        versionSpecification =
          ".upToNextMinor(from: Version(\(version.major.inDigits()), \(version.minor.inDigits()), \(version.patch.inDigits())))"
      } else {
        versionSpecification =
          "from: Version(\(version.major.inDigits()), \(version.minor.inDigits()), \(version.patch.inDigits()))"
      }

      var result = [
        UserFacing<StrictString, ContentLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            var result: StrictString = "\(projectName) provides "
            if libraries.count == 1 {
              result += "a library"
            } else {
              result += "libraries"
            }
            result +=
              " for use with the [Swift Package Manager](https://swift.org/package\u{2D}manager/)."
            return result
          case .deutschDeutschland:
            var result: StrictString = "\(projectName) stellt "
            if libraries.count == 1 {
              result += "eine Bibliotek"
            } else {
              result += "Biblioteken"
            }
            result +=
              " für zur Verwendung mit dem [Swift‐Paketenverwalter (*Swift Package Manager*)](https://swift.org/package\u{2D}manager/) bereit."
            return result
          }
        }).resolved(for: localization),
        "",
        UserFacing<StrictString, ContentLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            var result: StrictString =
              "Simply add \(projectName) as a dependency in `Package.swift`"
            if libraries.count == 1 {
              result += ":"
            } else {
              result += " and specify which of the libraries to use:"
            }
            return result
          case .deutschDeutschland:
            var result: StrictString =
              "\(projectName) einfach als Abhängigkeit (*dependency*) in `Package.swift` hinzufügen"
            if libraries.count == 1 {
              result += ":"
            } else {
              result += " und die gewünschte Biblioteken angeben:"
            }
            return result
          }
        }).resolved(for: localization),
        "",
        "```swift",
        ("let "
          + UserFacing<StrictString, ContentLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "package"
            case .deutschDeutschland:
              return "paket"
            }
          }).resolved(for: localization) + " = Package(") as StrictString,
        ("  name: \u{22}"
          + UserFacing<StrictString, ContentLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "MyPackage"
            case .deutschDeutschland:
              return "MeinePaket"
            }
          }).resolved(for: localization) + "\u{22},") as StrictString,
        "  dependencies: [",
        "    .package(",
        "      name: \u{22}\(packageName)\u{22},",
        "      url: \u{22}\(packageURL.absoluteString)\u{22},",
        "      \(versionSpecification)",
        "    ),",
        "  ],",
        "  targets: [",
        "    .target(",
        ("      name: \u{22}"
          + UserFacing<StrictString, ContentLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "MyTarget"
            case .deutschDeutschland:
              return "MeinZiel"
            }
          }).resolved(for: localization) + "\u{22},") as StrictString,
        "      dependencies: [",
      ]

      for library in libraries {
        result += [
          "        .product(name: \u{22}\(library.name)\u{22}, package: \u{22}\(packageName)\u{22}),"
        ]
      }

      result += [
        "      ]",
        "    )",
        "  ]",
        ")",
        "```",
        "",
        UserFacing<StrictString, ContentLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            var result: StrictString = "The "
            if libraries.count == 1 ∧ libraries.first!.modules.count == 1 {
              result += "module"
            } else {
              result += "modules"
            }
            result += " can then be imported in source files:"
            return result
          case .deutschDeutschland:
            var result: StrictString = ""
            if libraries.count == 1 ∧ libraries.first!.modules.count == 1 {
              result += "Das Modul"
            } else {
              result += "Die Module"
            }
            result += " können dann in Quelldateien eingeführt (*imported*) werden:"
            return result
          }
        }).resolved(for: localization),
        "",
        "```swift",
      ]

      for module in WorkspaceContext.current.manifest.productModules {
        result += ["import \(module)"]
      }

      result += [
        "```"
      ]

      return result.joinedAsLines()
    }
  #endif
}
