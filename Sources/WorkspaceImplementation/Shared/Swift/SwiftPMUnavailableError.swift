/*
 SwiftPMAvailabilityError.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import WorkspaceLocalizations

struct SwiftPMUnavailableError: PresentableError {

  func presentableDescription() -> StrictString {
    return UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedStates, .englishUnitedKingdom, .englishCanada:
        return "SwiftPM is unavailable; the platform is too old."
      case .deutschDeutschland:
        return "SwiftPM ist nicht verfügbar; die Schicht ist zu alt."
      }
    }).resolved()
  }
}