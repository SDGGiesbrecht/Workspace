/*
 PackageInterface.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGControlFlow
  import SDGLogic
  import SDGCollections

  import SDGCommandLine

  import SDGSwiftDocumentation
  import SymbolKit
  import SDGHTML
  import SDGSwiftSource
  import SwiftSyntax
  import SwiftSyntaxParser

  import WorkspaceLocalizations
  import WorkspaceConfiguration

  internal struct PackageInterface {

    private static func specify(package: URL?, version: Version?) -> StrictString? {
      guard let specified = package else {
        return nil
      }
      let packageURL = StrictString(specified.absoluteString)

      var result = [
        ElementSyntax("span", attributes: ["class": "punctuation"], contents: ".", inline: true)
          .normalizedSource(),
        ElementSyntax(
          "span",
          attributes: ["class": "external identifier"],
          contents: "package",
          inline: true
        ).normalizedSource(),
        ElementSyntax("span", attributes: ["class": "punctuation"], contents: "(", inline: true)
          .normalizedSource(),
        ElementSyntax(
          "span",
          attributes: ["class": "external identifier"],
          contents: "url",
          inline: true
        )
        .normalizedSource(),
        ElementSyntax("span", attributes: ["class": "punctuation"], contents: ":", inline: true)
          .normalizedSource(),
        " ",
        ElementSyntax(
          "span",
          attributes: ["class": "string"],
          contents: [
            ElementSyntax(
              "span",
              attributes: ["class": "punctuation"],
              contents: "\u{22}",
              inline: true
            ).normalizedSource(),
            ElementSyntax(
              "a",
              attributes: ["href": packageURL],
              contents: [
                ElementSyntax(
                  "span",
                  attributes: ["class": "text"],
                  contents: HTML.escapeTextForCharacterData(packageURL),
                  inline: true
                ).normalizedSource()
              ].joined(),
              inline: true
            ).normalizedSource(),
            ElementSyntax(
              "span",
              attributes: ["class": "punctuation"],
              contents: "\u{22}",
              inline: true
            ).normalizedSource(),
          ].joined(),
          inline: true
        ).normalizedSource(),
      ].joined()

      if let specified = specify(version: version) {
        result.append(
          contentsOf: [
            ElementSyntax(
              "span",
              attributes: ["class": "punctuation"],
              contents: ",",
              inline: true
            )
            .normalizedSource(),
            " ",
            specified,
          ].joined()
        )
      }

      result.append(
        contentsOf: ElementSyntax(
          "span",
          attributes: ["class": "punctuation"],
          contents: ")",
          inline: true
        )
        .normalizedSource()
      )

      return ElementSyntax(
        "span",
        attributes: ["class": "swift blockquote"],
        contents: result,
        inline: true
      )
      .normalizedSource()
    }

    private static func specify(version: Version?) -> StrictString? {
      guard let specified = version else {
        return nil
      }

      var result = [
        ElementSyntax(
          "span",
          attributes: ["class": "external identifier"],
          contents: "from",
          inline: true
        ).normalizedSource(),
        ElementSyntax("span", attributes: ["class": "punctuation"], contents: ":", inline: true)
          .normalizedSource(),
        " ",
        ElementSyntax(
          "span",
          attributes: ["class": "string"],
          contents: [
            ElementSyntax(
              "span",
              attributes: ["class": "punctuation"],
              contents: "\u{22}",
              inline: true
            ).normalizedSource(),
            ElementSyntax(
              "span",
              attributes: ["class": "text"],
              contents: StrictString(specified.string()),
              inline: true
            )
            .normalizedSource(),
            ElementSyntax(
              "span",
              attributes: ["class": "punctuation"],
              contents: "\u{22}",
              inline: true
            ).normalizedSource(),
          ].joined(),
          inline: true
        ).normalizedSource(),
      ].joined()

      if specified.major == 0 {
        result = [
          ElementSyntax(
            "span",
            attributes: ["class": "punctuation"],
            contents: ".",
            inline: true
          )
          .normalizedSource(),
          ElementSyntax(
            "span",
            attributes: ["class": "external identifier"],
            contents: "upToNextMinor",
            inline: true
          ).normalizedSource(),
          ElementSyntax(
            "span",
            attributes: ["class": "punctuation"],
            contents: "(",
            inline: true
          )
          .normalizedSource(),
          result,
          ElementSyntax(
            "span",
            attributes: ["class": "punctuation"],
            contents: ")",
            inline: true
          )
          .normalizedSource(),
        ].joined()
      }

      return result
    }

    private static func packageHeader(localization: LocalizationIdentifier) -> StrictString {
      if let match = localization._reasonableMatch {
        switch match {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Package"
        case .deutschDeutschland:
          return "Paket"
        }
      } else {
        return "Package"  // From “let ... = Package(...)”
      }
    }

    private static func generateIndexSection(
      named name: StrictString,
      identifier: IndexSectionIdentifier,
      apiEntries: [SymbolLike],
      localization: LocalizationIdentifier,
      extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties]
    ) -> StrictString {
      var entries: [StrictString] = []
      for entry in apiEntries.lazy.filter({ entry in
        return extensionStorage[
          entry.extendedPropertiesIndex,
          default: .default  // @exempt(from: tests) Reachability unknown.
        ].exists(in: localization)

          // #workaround(Why are there symbols that still have no path? See SDGCornerstone.)
          ∧ extensionStorage[
            entry.extendedPropertiesIndex,
            default: .default  // @exempt(from: tests) Reachability unknown.
          ].relativePagePath[localization] ≠ nil

      }).sorted(by: { first, second in
        return compare(
          first,
          second,
          by: { $0.names.resolvedForNavigation },
          { entry in  // @exempt(from: tests) Reachability unknown.
            return extensionStorage[
              entry.extendedPropertiesIndex,
              default: .default  // @exempt(from: tests) Reachability unknown.
            ].relativePagePath[localization]!
          }
        )
      }) {
        entries.append(
          ElementSyntax(
            "a",
            attributes: [
              "href":
                "[*site root*]\(HTML.percentEncodeURLPath(extensionStorage[entry.extendedPropertiesIndex, default: .default /* @exempt(from: tests) */].relativePagePath[localization]!))"
            ],
            contents: HTML.escapeTextForCharacterData(
              StrictString(entry.names.resolvedForNavigation)
            ),
            inline: false
          ).normalizedSource()
        )
      }
      return generateIndexSection(
        named: name,
        identifier: identifier,
        contents: entries.joinedAsLines()
      )
    }

    private static func generateIndexSection(
      named name: StrictString,
      identifier: IndexSectionIdentifier,
      tools: PackageCLI,
      localization: LocalizationIdentifier
    ) -> StrictString {
      var entries: [StrictString] = []
      return generateIndexSection(
        named: name,
        identifier: identifier,
        contents: entries.joinedAsLines()
      )
    }

    private static func generateIndexSection(
      named name: StrictString,
      identifier: IndexSectionIdentifier,
      contents: StrictString
    ) -> StrictString {
      return ElementSyntax(
        "div",
        attributes: ["id": identifier.htmlIdentifier],
        contents: [
          ElementSyntax(
            "a",
            attributes: [
              "class": "heading",
              "onclick": "toggleIndexSectionVisibility(this)",
            ],
            contents: HTML.escapeTextForCharacterData(name),
            inline: true
          )
          .normalizedSource(),
          contents,
        ].joinedAsLines(),
        inline: false
      ).normalizedSource()
    }

    private static func generateLoneIndexEntry(
      named name: StrictString,
      target: StrictString
    ) -> StrictString {
      return ElementSyntax(
        "div",
        contents: ElementSyntax(
          "a",
          attributes: [
            "class": "heading",
            "href": "[*site root*]\(HTML.percentEncodeURLPath(target))",
          ],
          contents: HTML.escapeTextForCharacterData(name),
          inline: true
        )
        .normalizedSource(),
        inline: false
      ).normalizedSource()
    }

    private static func generate(platforms: [StrictString]) -> StrictString {
      var result: [StrictString] = []
      for platform in platforms {
        result.append(
          ElementSyntax(
            "span",
            contents: HTML.escapeTextForCharacterData(platform),
            inline: false
          ).normalizedSource()
        )
      }
      return result.joinedAsLines()
    }

    // MARK: - Initialization

    internal init(
      localizations: [LocalizationIdentifier],
      developmentLocalization: LocalizationIdentifier,
      api: PackageAPI,
      cli: PackageCLI,
      packageURL: URL?,
      version: Version?,
      platforms: [LocalizationIdentifier: [StrictString]],
      output: Command.Output
    ) {

      output.print(
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Processing API..."
          case .deutschDeutschland:
            return "Die Programmierschnittstelle wird verarbeitet ..."
          }
        }).resolved()
      )

      self.localizations = localizations
      self.developmentLocalization = developmentLocalization
      self.api = api
      self.cli = cli
      var extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties] = [:]
      api.computeMergedAPI(extensionStorage: &extensionStorage)

      self.packageImport = PackageInterface.specify(package: packageURL, version: version)

      self.editableModules = api.modules.map { $0.names.title }
      self.packageIdentifiers = api.identifierList()

      var parsingCache: [URL: SymbolGraph.Symbol.CachedSource] = [:]
      api.determine(
        localizations: localizations,
        package: api,
        module: nil,
        extensionStorage: &extensionStorage,
        parsingCache: &parsingCache
      )

      var paths: [LocalizationIdentifier: [String: String]] = [:]
      for localization in localizations {
        paths[localization] = api.determinePaths(
          for: localization,
          package: api,
          extensionStorage: &extensionStorage
        )
      }
      api.determineLocalizedPaths(
        localizations: localizations,
        package: api,
        extensionStorage: &extensionStorage
      )
      self.symbolLinks = paths.mapValues { localization in
        localization.mapValues { link in
          return HTML.percentEncodeURLPath(link)
        }
      }

      self.platforms = platforms.mapValues { PackageInterface.generate(platforms: $0) }
      self.extensionStorage = extensionStorage
    }

    // MARK: - Properties

    private let localizations: [LocalizationIdentifier]
    private let developmentLocalization: LocalizationIdentifier
    private let api: PackageAPI
    private let extensionStorage: [String: SymbolGraph.Symbol.ExtendedProperties]
    private let cli: PackageCLI
    private let packageImport: StrictString?
    private let platforms: [LocalizationIdentifier: StrictString]
    private let editableModules: [String]
    private let packageIdentifiers: Set<String>
    private let symbolLinks: [LocalizationIdentifier: [String: String]]
  }
#endif
