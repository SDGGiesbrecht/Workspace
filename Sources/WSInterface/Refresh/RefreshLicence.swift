/*
 RefreshLicence.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSLicence

extension Workspace.Refresh {

  enum Licence {

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishCanada:
        return "licence"
      case .englishUnitedStates:
        return "license"
      case .deutschDeutschland:
        return "lizenz"
      }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishCanada:
          return "regenerates the project’s licence file."
        case .englishUnitedStates:
          return "regenerates the project’s license file."
        case .deutschDeutschland:
          return "erstellt die Lizenzdatei der Projekt neu."
        }
      })

    static let command = Command(
      name: name,
      description: description,
      directArguments: [],
      options: Workspace.standardOptions,
      execution: { (_, options: Options, output: Command.Output) throws in

        output.print(
          UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishCanada:
              return "Refreshing licence..."
            case .englishUnitedStates:
              return "Refreshing license..."
            case .deutschDeutschland:
              return "Lizenz wird aufgefrischt ..."
            }
          }).resolved().formattedAsSectionHeader()
        )

        try options.project.refreshLicence(output: output)
      }
    )
  }
}
