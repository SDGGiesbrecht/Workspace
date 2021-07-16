/*
 MarkdownHeadings.swift

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
import SDGSwiftSource

import WorkspaceLocalizations

internal struct MarkdownHeadings: SyntaxRule {

  internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "markdownHeadings"
      case .deutschDeutschland:
        return "markdownÜberschrifte"
      }
    })

  private static let message = UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Markdown headings should use number signs."
    case .deutschDeutschland:
      return "Markdown‐Überschrifte sollen Doppelkreuze verwenden."
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
        token.kind == .headingDelimiter,
        ¬token.text.contains("#")
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
