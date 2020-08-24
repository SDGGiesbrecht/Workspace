/*
 ParameterGrouping.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift
import SDGSwiftSource

import WorkspaceLocalizations

internal struct ParameterGrouping: SyntaxRule {

  internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "parameterGrouping"
      case .deutschDeutschland:
        return "übergabewertenzusammenstellung"
      }
    })

  private static let message = UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Parameters should be grouped under a single callout."
    case .deutschDeutschland:
      return "Übergabewerte sollen unter einer einzigen Hervorhebung gestellt sein."
    }
  })

  // #workaround(SwiftSyntax 0.50200.0, Cannot build.)
  #if !(os(Windows) || os(WASI) || os(Android))
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
        token.kind == .callout,
        token.text.lowercased() == "parameter"
      {

        reportViolation(
          in: file,
          at: token.range(in: context),
          message: message,
          status: status
        )
      }
    }
  #endif
}
