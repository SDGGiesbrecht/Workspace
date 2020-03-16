/*
 MissingImplementation.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

internal struct MissingImplementation: TextRule {

  internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "missingImplementation"
      case .deutschDeutschland:
        return "fehlendeImplementierung"
      }
    })

  private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Missing implementation."
    case .deutschDeutschland:
      return "Fehlende Implementierung."
    }
  })

  internal static func check(
    file: TextFile,
    in project: PackageRepository,
    status: ProofreadingStatus,
    output: Command.Output
  ) {
    for match in file.contents.scalars.matches(for: "\u{6E}otImplementedYet".scalars) {
      reportViolation(in: file, at: match.range, message: message, status: status)
    }
  }
}
