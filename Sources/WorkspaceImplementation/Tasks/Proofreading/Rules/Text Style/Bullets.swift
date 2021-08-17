/*
 Bullets.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGLogic
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift
  import SDGSwiftSource

  import WorkspaceLocalizations

  internal struct Bullets: SyntaxRule {

    internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "bullets"
        case .deutschDeutschland:
          return "aufzählungszeichen"
        }
      })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Markdown lists should use ASCII bullets."
      case .deutschDeutschland:
        return "Markdown‐Listen sollen ASCII‐Aufzählungszeichen verwenden."
      }
    })

    #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_SYNTAX
      internal static func check(
        _ node: ExtendedSyntax,
        context: ExtendedSyntaxContext,
        file: TextFile,
        setting: Setting,
        project: PackageRepository,
        status: ProofreadingStatus,
        output: Command.Output
      ) {

        if let token = node as? ExtendedTokenSyntax,
          token.kind == .bullet,
          token.text ≠ "\u{2D}",
          ¬token.text.contains(".")
        {

          reportViolation(
            in: file,
            at: token.range(in: context),
            replacementSuggestion: "\u{2D}",
            message: message,
            status: status
          )
        }
      }
    #endif
  }
#endif
