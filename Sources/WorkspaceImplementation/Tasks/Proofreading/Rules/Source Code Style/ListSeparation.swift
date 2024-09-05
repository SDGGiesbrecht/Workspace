/*
 ListSeparation.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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
  import SwiftSyntax
  import SDGSwiftSource

  import WorkspaceLocalizations

  internal struct ListSeparation: SyntaxRule {

    internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "listSeparation"
        case .deutschDeutschland:
          return "listentrennung"
        }
      })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "List separators should only occur between list elements."
      case .deutschDeutschland:
        return "Listentrennzeichen sollen nur zwischen Listenelementen stehen."
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

      if node is Token,
        let token = (context.globalAncestors.last?.node as? SwiftSyntaxNode)?.swiftSyntaxNode.as(TokenSyntax.self),
        let entry = token.parent?.asProtocol(WithTrailingCommaSyntax.self),
        token.indexInParent == entry.trailingComma?.indexInParent,
        let list = entry.parent,
        entry.indexInParent == list.children(viewMode: .sourceAccurate).last?.indexInParent
      {

        reportViolation(
          in: file,
          at: context.location,
          replacementSuggestion: "",
          message: message,
          status: status
        )
      }
    }
  }
#endif
