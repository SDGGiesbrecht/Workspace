/*
 RefreshScripts.swift

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
import WSScripts

extension Workspace.Refresh {

  enum Scripts {

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "scripts"
      case .deutschDeutschland:
        return "skripte"
      }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "regenerates the project’s refresh and validation scripts."
        case .deutschDeutschland:
          return "erstellt die Auffrisch‐ und Überprüfungskripte neu."
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
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Refreshing scripts..."
            case .deutschDeutschland:
              return "Skripte werden aufgefrischt ..."
            }
          }).resolved().formattedAsSectionHeader()
        )

        // #workaround(Swift 5.2.2, Web lacks Foundation.)
        #if !os(WASI)
          try options.project.refreshScripts(output: output)
        #endif
      }
    )
  }
}
