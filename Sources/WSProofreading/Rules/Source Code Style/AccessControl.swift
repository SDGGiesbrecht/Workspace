/*
 AccessControl.swift

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
import WSGeneralImports

import WSProject

import SwiftSyntax
import SDGSwiftSource

internal struct AccessControl: SyntaxRule {

  internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "accessControl"
      case .deutschDeutschland:
        return "zugriffskontrolle"
      }
    })

  private static let libraryMessage = UserFacing<StrictString, InterfaceLocalization>({
    localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Every symbol in a library should have access control."
    case .deutschDeutschland:
      return "Jedes Symbol in einer Bibliotek soll Zugriffskontrolle haben."
    }
  })

  private static let extensionMessage = UserFacing<StrictString, InterfaceLocalization>({
    localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Access control belongs on individual symbols, not extensions."
    case .deutschDeutschland:
      return "Zugriffskontrolle gehört bei einzelne Sombole, nicht bei Erweiterungen."
    }
  })

  private static let otherMessage = UserFacing<StrictString, InterfaceLocalization>({
    localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Executables and tests should not contain access control."
    case .deutschDeutschland:
      return "Ausfürbare Dateien und Testen sollen keine Zugriffskontrolle enthalten."
    }
  })

  // #workaround(SwiftSyntax 0.50200.0, Cannot build.)
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
      reportViolation(
        in: file,
        at: node.syntaxRange(in: context),
        message: libraryMessage,
        status: status
      )
    }
  #endif
}
