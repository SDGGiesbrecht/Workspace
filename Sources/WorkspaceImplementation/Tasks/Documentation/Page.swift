/*
 Page.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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
        var result = TextFile(mockFileWithContents: Resources.Documentation.page, fileType: .html)
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
      compilationConditions: StrictString?,
      constraints: StrictString?,
      title: StrictString,
      content: StrictString,
      extensions: StrictString,
      copyright: StrictString
    ) {

        var mutable = Page.template
      mutable.replaceMatches(for: "[*localization*]".scalars, with: localization.code.scalars)
      mutable.replaceMatches(
        for: "[*text direction*]".scalars,
        with: localization.textDirection.htmlAttribute.scalars
      )

      mutable.replaceMatches(for: "[*navigation path*]", with: navigationPath.scalars)

      mutable.replaceMatches(for: "[*package import*]", with: packageImport ?? "")

      mutable.replaceMatches(for: "[*index*]", with: index)
      mutable.replaceMatches(
        for: "[*section identifier*]",
        with: sectionIdentifier?.htmlIdentifier ?? ""
      )
      mutable.replaceMatches(for: "[*platforms*]", with: platforms)
      mutable.replaceMatches(
        for: "[*site root*]".scalars,
        with: HTML.escapeTextForAttribute(pathToSiteRoot)
      )

      mutable.replaceMatches(for: "[*imports*]".scalars, with: symbolImports)

      let symbolTypeLabel: StrictString
      if let specified = symbolType {
        symbolTypeLabel = ElementSyntax(
          "div",
          attributes: ["class": "symbol‐type"],
          contents: specified,
          inline: true
        )
        .normalizedSource()
      } else {
        symbolTypeLabel = ""  // @exempt(from: tests) Unreachable yet.
      }
      mutable.replaceMatches(for: "[*symbol type*]", with: symbolTypeLabel)

      mutable.replaceMatches(for: "[*compilation conditions*]", with: compilationConditions ?? "")
      mutable.replaceMatches(for: "[*title*]", with: HTML.escapeTextForCharacterData(title))
      mutable.replaceMatches(for: "[*constraints*]", with: constraints ?? "")

      mutable.replaceMatches(
        for: "[*copyright*]",
        with: ElementSyntax("span", contents: copyright, inline: false).normalizedSource()
      )
      mutable.replaceMatches(
        for: "[*workspace*]",
        with: Page.watermark(localization: localization)
      )

      mutable.replaceMatches(for: "[*content*]", with: content)

      mutable.replaceMatches(for: "[*extensions*]".scalars, with: extensions)

      contents = mutable
    }

    // MARK: - Properties

    internal let contents: StrictString
  }
#endif
