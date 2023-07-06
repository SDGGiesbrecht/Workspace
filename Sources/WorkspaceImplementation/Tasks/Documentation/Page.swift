/*
 Page.swift

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
  import SDGHTML

  import WorkspaceConfiguration

  internal class Page {

    internal static func sanitize(
      fileName: StrictString,
      customReplacements: [(StrictString, StrictString)]
    ) -> StrictString {
      var result = fileName
      for (key, value) in customReplacements {
        result.replaceMatches(for: key, with: value)
      }
      return result
    }

    // MARK: - Static Properties

    private static let template: StrictString = {
      var result = TextFile(mockFileWithContents: Resources.page, fileType: .html)
      result.header = ""
      return StrictString(result.contents)
    }()

    private static func watermark(localization: LocalizationIdentifier) -> StrictString {
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

      let link = ElementSyntax("a", attributes: ["href": targetURL], contents: name, inline: true)
        .normalizedSource()

      let generatedUsing: StrictString
      switch resolved {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        generatedUsing = "Generated with " + link + "."
      case .deutschDeutschland:
        generatedUsing = "Erstellt mit " + link + "."
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

    // MARK: - Initialization

    internal init(
      localization: LocalizationIdentifier,
      pathToSiteRoot: StrictString,
      navigationPath: StrictString,
      packageImport: StrictString?,
      index: StrictString,
      sectionIdentifier: IndexSectionIdentifier?,
      platforms: StrictString,
      symbolImports: StrictString,
      symbolType: StrictString?,
      title: StrictString,
      content: StrictString,
      copyright: StrictString
    ) {
      // Converted to Article.init(...)
      contents = ""
    }

    // MARK: - Properties

    internal let contents: StrictString
  }
#endif
