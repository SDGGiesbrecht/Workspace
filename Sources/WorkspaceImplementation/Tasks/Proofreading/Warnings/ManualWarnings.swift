/*
 ManualWarnings.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift

  import WorkspaceLocalizations

  internal struct ManualWarnings: Warning {

    internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "manualWarnings"
        case .deutschDeutschland:
          return "warnungenVonHand"
        }
      })

    internal static let trigger = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "warning"
      case .deutschDeutschland:
        return "warnung"
      }
    })

    internal static func message(
      for details: StrictString,
      in project: PackageRepository,
      output: Command.Output
    ) -> UserFacing<StrictString, InterfaceLocalization>? {
      return UserFacing({ _ in details })
    }
  }
#endif
