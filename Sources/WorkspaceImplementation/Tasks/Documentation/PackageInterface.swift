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
