/*
 ClassFinality.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift
// #workaround(SwiftSyntax 0.50300.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  import SwiftSyntax
#endif
import SDGSwiftSource

import WorkspaceLocalizations

internal struct ClassFinality: SyntaxRule {

  internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "classFinality"
      case .deutschDeutschland:
        return "klassenentgültigkeit"
      }
    })

  private static let message = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Public classes should be open, final or explicitly exempt."
      case .deutschDeutschland:
        return
          "Öffentliche (public) Klassen sollen als offen (open), entgültig (final), oder ausdrückliche Ausnahme markiert."
      }
    })

  // #workaround(SwiftSyntax 0.50300.0, Cannot build.)
  #if !(os(Windows) || os(WASI) || os(Android))

    // MARK: - SyntaxRule

    internal static func check(
      _ node: Syntax,
      context: SyntaxContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {

      switch setting {
      case .library:
        if let classModifiers = node.as(ClassDeclSyntax.self)?.modifiers,
          let `public` = classModifiers.first(where: { $0.name.text == "public" }),
          ¬classModifiers.contains(where: { $0.name.text == "final" })
        {
          reportViolation(
            in: file,
            at: `public`.syntaxRange(in: context),
            message: message,
            status: status
          )
        }
      case .topLevel, .unknown:
        break
      }
    }
  #endif
}
