/*
 ListSeparation.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift
#if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_SYNTAX
  import SwiftSyntax
#endif
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

  // #workaround(SwiftSyntax 0.50300.0, Cannot build.)
  #if !(os(Windows) || os(WASI) || os(Android))
    internal static func check(
      _ node: Syntax,
      context: SyntaxContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {

      if let entry = node.asProtocol(WithTrailingCommaSyntax.self),
        let comma = entry.trailingComma,
        entry.indexInParent == entry.parent?.children.last?.indexInParent
      {

        reportViolation(
          in: file,
          at: comma.syntaxRange(in: context),
          replacementSuggestion: "",
          message: message,
          status: status
        )
      }
    }
  #endif
}
