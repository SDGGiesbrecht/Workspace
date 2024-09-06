/*
 CalloutCasing.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGLogic
  import SDGCollections
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift
  import SDGSwiftSource

  import WorkspaceLocalizations

  internal struct CalloutCasing: SyntaxRule {

    internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "calloutCasing"
        case .deutschDeutschland:
          return "hervorhebungsGroßschreibung"
        }
      })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
      switch localization {
      case .englishUnitedKingdom:
        return "Callouts should be capitalised."
      case .englishUnitedStates, .englishCanada:
        return "Callouts should be capitalized."
      case .deutschDeutschland:
        return "Hervorhebungen sollen großgeschrieben sein."
      }
    })

    internal static func check(
      _ node: SyntaxNode,
      context: ScanContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {

      if let token = node as? Token,
        case .callout = token.kind,
        let first = token.text().scalars.first,
        first ∈ CharacterSet.lowercaseLetters
      {

        var replacement = token.text()
        let first = replacement.removeFirst()
        replacement.prepend(contentsOf: String(first).uppercased())

        reportViolation(
          in: file,
          at: context.location,
          replacementSuggestion: StrictString(replacement),
          message: message,
          status: status
        )
      }
    }
  }
#endif
