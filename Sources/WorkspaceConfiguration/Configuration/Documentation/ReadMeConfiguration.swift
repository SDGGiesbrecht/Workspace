/*
 ReadMeConfiguration.swift

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

// @localization(🇩🇪DE) @crossReference(ReadMeConfiguration)
/// Einstellungen zur Lies‐mich Datei.
///
/// ```shell
/// $ arbeitsbereich auffrischen lies‐mich
/// ```
///
/// Eine Lies‐mich Datei ist eine `README.md` Datei, die GitHub als die Hauptseite des Projekts verwendet.
public typealias LiesMichEinstellungen = ReadMeConfiguration
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(ReadMeConfiguration)
/// Options related to the project read‐me.
///
/// ```shell
/// $ workspace refresh read‐me
/// ```
///
/// A read‐me is a `README.md` file that GitHub uses as the project’s main page.
public struct ReadMeConfiguration: Codable {

  // MARK: - Options

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(ReadMeConfiguration.manage)
  /// Whether or not to manage the project read‐me.
  ///
  /// This is off by default.
  public var manage: Bool = false
  // @localization(🇩🇪DE) @crossReference(ReadMeConfiguration.manage)
  /// Ob Arbeitsbereich die Lies‐mich Datei verwalten soll.
  ///
  /// Wenn nicht angegeben, ist diese Einstellung aus.
  public var verwalten: Bool {
    get { return manage }
    set { manage = newValue }
  }

  // @localization(🇩🇪DE) @crossReference(ReadMeConfiguration.contents)
  /// Der Inhalt der Lies‐mich Datei.
  ///
  /// Wenn nicht angegeben, ist der Inhalt aus den anderen Dokumentations‐ und Lies‐mich‐Einstellungen hergeleitet.
  ///
  /// Arbeitsbereich wird `#paketenDokumentation` mit der Dokumentation aus der Ladeliste ersetzen.
  public var inhalt: BequemeEinstellung<[Lokalisationskennzeichen: Markdown]> {
    get { return contents }
    set { contents = newValue }
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(ReadMeConfiguration.contents)
  /// The entire contents of the read‐me.
  ///
  /// By default, this is assembled from the other documentation and read‐me options.
  ///
  /// Workspace will replace the dynamic element `#packageDocumentation` with the documentation comment parsed from the package manifest.
  public var contents: Lazy<[LocalizationIdentifier: Markdown]> = Lazy<
    [LocalizationIdentifier: Markdown]
  >(resolve: { (configuration: WorkspaceConfiguration) -> [LocalizationIdentifier: Markdown] in

    var result: [LocalizationIdentifier: Markdown] = [:]
    for localization in configuration.documentation.localizationsOrSystemFallback {

      var readMe: [StrictString] = []

      if let provided = localization._reasonableMatch {
        readMe += [
          Platform.allCases
            .filter({ configuration.supportedPlatforms.contains($0) })
            .map({ $0._isolatedName(for: provided) })
            .joined(separator: " • "),
          "",
        ]
      }

      if let api = apiLink(for: configuration, in: localization) {
        readMe += [
          api,
          "",
        ]
      }

      // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
      #if !os(WASI)
        readMe += ["# " + WorkspaceContext.current.manifest.packageName.scalars]
      #endif

      readMe += [
        "",
        "#packageDocumentation",
      ]

      if let installation = configuration.documentation.installationInstructions
        .resolve(configuration)[localization]
      {
        let header: StrictString
        switch localization._bestMatch {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          header = "Installation"
        }
        readMe += [
          "",
          "## " + header,
          "",
          installation,
        ]
      }
      if let importing = configuration.documentation.importingInstructions
        .resolve(configuration)[localization]
      {
        let header: StrictString
        switch localization._bestMatch {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          header = "Importing"
        case .deutschDeutschland:
          header = "Einführung"
        }
        readMe += [
          "",
          "## " + header,
          "",
          importing,
        ]
      }

      if let about = configuration.documentation.about[localization] {
        let header: StrictString
        switch localization._bestMatch {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          header = "About"
        case .deutschDeutschland:
          header = "Über"
        }
        readMe += [
          "",
          "## " + header,
          "",
          about,
        ]
      }

      result[localization] = readMe.joinedAsLines()
    }
    return result
  })

  // MARK: - Useful components.

  private static let documentationDirectoryName = "Documentation"
  // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
  #if !os(WASI)
    public static func _documentationDirectory(for project: URL) -> URL {
      return project.appendingPathComponent(documentationDirectoryName)
    }

    private static func _locationOfDocumentationFile(
      named name: StrictString,
      for localization: LocalizationIdentifier,
      in project: URL
    ) -> URL {
      let icon = ContentLocalization.icon(for: localization.code) ?? "[\(localization.code)]"
      let fileName: StrictString = icon + " " + name + ".md"
      return _documentationDirectory(for: project).appendingPathComponent(String(fileName))
    }

    public static func _readMeLocation(
      for project: URL,
      localization: LocalizationIdentifier
    ) -> URL {
      let name: StrictString
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        name = "Read Me"
      case .deutschDeutschland:
        name = "Lies mich"
      }
      return _locationOfDocumentationFile(named: name, for: localization, in: project)
    }
  #endif

  // @localization(🇩🇪DE) @crossReference(ReadMeConfiguration.apiLink(for:in:))
  /// Baut Verweise zur Programmierschnittstellendokumentation auf, die von der Konfiguration hergeleitet sind.
  ///
  /// Das Ergebnis wird `nil` wenn `dokumentationsRessourcenzeiger` nicht angegeben ist, oder die angeforderte Lokalisation nicht unterstützt ist.
  ///
  /// - Parameters:
  ///     - konfiguration: The configuration based on which the links should be constructed.
  ///     - lokalisation: The localization to use.
  public static func programmierschnittstellenverweis(
    für konfiguration: ArbeitsbereichKonfiguration,
    auf lokalisation: Lokalisationskennzeichen
  ) -> StrengeZeichenkette? {
    return apiLink(for: konfiguration, in: lokalisation)
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(ReadMeConfiguration.apiLink(for:in:))
  /// Attempts to construct API links based on the specified configuration.
  ///
  /// The result will be `nil` if `documentationURL` is not specified or if the requested localization is not supported.
  ///
  /// - Parameters:
  ///     - configuration: The configuration based on which the links should be constructed.
  ///     - localization: The localization to use.
  public static func apiLink(
    for configuration: WorkspaceConfiguration,
    in localization: LocalizationIdentifier
  ) -> StrictString? {

    // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
    #if os(WASI)
      return nil
    #else
      guard let baseURL = configuration.documentation.documentationURL,
        let provided = localization._reasonableMatch
      else {
        return nil
      }

      let label: StrictString
      switch provided {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        label = "Documentation"
      case .deutschDeutschland:
        label = "Dokumentation"
      }

      var link: StrictString = "[" + label + "]("
      link +=
        StrictString(
          baseURL.appendingPathComponent(String(localization._directoryName)).absoluteString
        )
        + ")"
      return link
    #endif
  }

  // MARK: - Related Projects

  // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
  #if !os(WASI)
    public static func _relatedProjectsLocation(
      for project: URL,
      localization: LocalizationIdentifier
    ) -> URL {
      let name: StrictString
      switch localization._bestMatch {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        name = "Related Projects"
      case .deutschDeutschland:
        name = "Verwandte Projekte"
      }
      return _locationOfDocumentationFile(named: name, for: localization, in: project)
    }
  #endif
}
