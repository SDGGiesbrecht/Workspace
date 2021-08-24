/*
 RefreshReadMe.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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

  extension Workspace.Refresh {

    internal enum ReadMe {

      private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "read‐me"
        case .deutschDeutschland:
          return "lies‐mich"
        }
      })

      private static let description = UserFacing<StrictString, InterfaceLocalization>(
        { localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "regenerates the project’s read‐me file."
          case .deutschDeutschland:
            return "erstellt die Lies‐mich‐Datei des Projekts neu."
          }
        })

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
                  return "Refreshing read‐me..."
                case .deutschDeutschland:
                  return "Lies‐mich wird aufgefrischt ..."
                }
              }).resolved().formattedAsSectionHeader()
            )

            try options.project.refreshReadMe(output: output)
            try output.listWarnings(for: options.project)
          }
        )
    }
  }
#endif
