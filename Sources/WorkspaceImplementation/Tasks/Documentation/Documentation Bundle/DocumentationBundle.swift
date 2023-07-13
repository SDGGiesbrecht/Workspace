/*
 DocumentationBundle.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
import Foundation

import OrderedCollections
import SDGText

import WorkspaceConfiguration

import SDGHTML

internal struct DocumentationBundle {

  // MARK: - Static Methods

  internal static func sanitize(title: StrictString) -> StrictString {
    return StrictString(
      // Einführung → Einfu\u{2D}rung
      // workspace check‐for‐updates → workspace\u{2D}check\u{2D}for\u{2D}updates
      title.lazy.map({ scalar in
        if ¬scalar.isASCII
          ∨ scalar ∉ CharacterSet.urlPathAllowed {
          return "\u{2D}"
        } else {
          return scalar
        }
      })
    )
  }

  internal static func link(toArticle article: StrictString) -> StrictString {
    return "\u{2D} <doc:\(sanitize(title: article))>"
  }

  // MARK: - Initialization

  internal init(
    developmentLocalization: LocalizationIdentifier,
    copyright: [LocalizationIdentifier?: StrictString],
    articles: OrderedDictionary<StrictString, Article>
  ) {
    self.developmentLocalization = developmentLocalization
    self.copyright = copyright
    self.articles = articles
  }

  // MARK: - Properties

  private let developmentLocalization: LocalizationIdentifier
  private let copyright: [LocalizationIdentifier?: StrictString]
  private let articles: OrderedDictionary<StrictString, Article>

  // MARK: - Output

  internal func write(to outputDirectory: URL) throws {
    try writeFooter(to: outputDirectory)
    var existing: Set<StrictString> = []
    for (path, article) in articles {
      let url = outputDirectory.appendingPathComponent(String(path))
      let source = article.source
      let fileName = StrictString(url.lastPathComponent)
      if ¬existing.contains(fileName) {
        existing.insert(fileName)
        try source.save(to: url)
      }
    }
  }

  private func writeFooter(
    to outputDirectory: URL
  ) throws {
    // This is presently refused by DocC unsless experimental flags are set.
    // Keeping this here ensures that Workspace retains its logic for fishing out and validating the relevant information.
    let footer = StrictString([
      "<footer id=\u{22}footer\u{22} role=\u{22}contentinfo\u{22} hidden>",
      " <div class=\u{22}container\u{22}>",
      "  <div>",
      "   <p class=\u{22}copyright\u{22}>\(copyright(localization: developmentLocalization))</p>",
      "   <p class=\u{22}trademark\u{22}>\(DocumentationBundle.watermark(localization: developmentLocalization))</p>",
      "  </div>",
      " </div>",
      "</footer>",
    ].joinedAsLines())
    // save to [outputDirectory]/footer.html
    _ = footer
  }

  private func copyright(
    localization: LocalizationIdentifier
  ) -> StrictString {
    if let result = copyright[localization] {
      return result
    } else {
      // Reported as warning earlier.
      return copyright[nil]!
    }
  }

  internal static func watermark(localization: LocalizationIdentifier) -> StrictString {
    let resolved = localization._bestMatch

    let targetURL: StrictString
    switch resolved {
    case .englishUnitedKingdom:
      targetURL = "https://sdggiesbrecht.github.io/Workspace/🇬🇧EN/Workspace.html"
    case .englishUnitedStates:
      targetURL = "https://sdggiesbrecht.github.io/Workspace/🇺🇸EN/Workspace.html"
    case .englishCanada:
      targetURL = "https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Workspace.html"
    case .deutschDeutschland:
      targetURL = "https://sdggiesbrecht.github.io/Workspace/🇩🇪DE/Workspace.html"
    }

    let name: StrictString
    switch resolved {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      name = "Workspace"
    case .deutschDeutschland:
      name = "Arbeitsbereich"
    }

    let link = ElementSyntax(
      "a",
      attributes: ["href": targetURL],
      contents: name,
      inline: true
    ).normalizedSource()

    let docCLink = ElementSyntax(
      "a",
      attributes: ["href": "https://www.swift.org/documentation/docc/"],
      contents: "DocC",
      inline: true
    ).normalizedSource()

    let generatedUsing: StrictString
    switch resolved {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      generatedUsing = "Generated with " + link + " and \(docCLink)."
    case .deutschDeutschland:
      generatedUsing = "Erstellt mit " + link + " und \(docCLink)."
    }

    let sdg: StrictString
    switch resolved {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
      .deutschDeutschland:
      sdg = ElementSyntax(
        "span",
        attributes: ["lang": "la\u{2D}IT"],
        contents: "Soli Deo gloria.",
        inline: true
      ).normalizedSource()
    }

    return ElementSyntax(
      "span",
      attributes: [
        "lang": StrictString(resolved.code),
        "dir": StrictString(resolved.textDirection.htmlAttribute),
      ],
      contents: generatedUsing + " " + sdg,
      inline: true
    ).normalizedSource()
  }
}
#endif
