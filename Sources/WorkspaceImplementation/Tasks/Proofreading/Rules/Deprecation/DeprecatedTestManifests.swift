/*
 DeprecatedTestManifests.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift

import WSLocalizations

internal struct DeprecatedTestManifests: TextRule {
  // Deprecated in 0.25.0 (2019‐11‐03)

  internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "deprecatedTestManifests"
      case .deutschDeutschland:
        return "überholteTestlisten"
      }
    })

  private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "Test manifests are no longer necessary."
    case .deutschDeutschland:
      return "Testlisten werden nicht mehr benötigt."
    }
  })

  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    internal static func check(
      file: TextFile,
      in project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {
      if file.location.lastPathComponent == "XCTestManifests.swift" {
        reportViolation(in: file, at: file.contents.bounds, message: message, status: status)
      }
    }
  #endif
}
