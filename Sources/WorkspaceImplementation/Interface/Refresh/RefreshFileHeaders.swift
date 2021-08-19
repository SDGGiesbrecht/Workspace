/*
 RefreshFileHeaders.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import WorkspaceLocalizations

  extension Workspace.Refresh {

    internal enum FileHeaders {

      private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "file‐headers"
        case .deutschDeutschland:
          return "dateivorspänne"
        }
      })

      private static let description = UserFacing<StrictString, InterfaceLocalization>(
        { localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "re‐applies the project file header to each of the project’s files."
          case .deutschDeutschland:
            return "wendet die Dateivorspann des Projekts zu jeder Datei neu an."
          }
        })

      #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
        internal static let command = Command(
          name: name,
          description: description,
          directArguments: [],
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
              }).resolved().formattedAsSectionHeader()
            )

            try options.project.refreshFileHeaders(output: output)
          }
        )
      #endif
    }
  }
#endif
