/*
 SyntaxColouring.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

import SDGSwiftSource

import WSProject

internal struct SyntaxColouring: SyntaxRule {

  internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
    switch localization {
    case .englishUnitedKingdom, .englishCanada:
      return "syntaxColouring"
    case .englishUnitedStates:
      return "syntaxColoring"
    case .deutschDeutschland:
      return "syntaxhervorhebung"
    }
  })

  private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Language specifier missing. Specify a language for syntax colouring."
    case .deutschDeutschland:
      return "Das Sprachkennzeichen fehlt. Eine Sprache für Syntaxhervorhebung angeben."
    }
  })

  internal static func check(
    _ node: ExtendedSyntax,
    context: ExtendedSyntaxContext,
    file: TextFile,
    project: PackageRepository,
    status: ProofreadingStatus,
    output: Command.Output
  ) {

    if let codeDelimiter = node as? ExtendedTokenSyntax,
      codeDelimiter.kind == .codeDelimiter,
      let codeBlock = codeDelimiter.parent as? CodeBlockSyntax,
      codeBlock.openingDelimiter.indexInParent == codeDelimiter.indexInParent
    {

      if codeBlock.language == nil {
        reportViolation(
          in: file,
          at: codeDelimiter.range(in: context),
          message: message,
          status: status
        )
      }
    }
  }
}
