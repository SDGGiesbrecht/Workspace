/*
 RefreshFileHeaders.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSFileHeaders

extension Workspace.Refresh {

  enum FileHeaders {

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "file‐headers"
      case .deutschDeutschland:
        return "dateivorspänne"
      }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>({
      localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "re‐applies the project file header to each of the project’s files."
      case .deutschDeutschland:
        return "wendet die Dateivorspann des Projekts zu jeder Datei neu an."
      }
    })

    static let command = Command(
      name: name, description: description, directArguments: [],
      options: Workspace.standardOptions,
      execution: { (_, options: Options, output: Command.Output) throws in

        output.print(
          UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Refreshing file headers..."
            case .deutschDeutschland:
              return "Dateivorspänne werden aufgefrischt ..."
            }
          }).resolved().formattedAsSectionHeader())

        try options.project.refreshFileHeaders(output: output)
      })
  }
}
