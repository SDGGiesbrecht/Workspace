/*
 RefreshGit.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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

    internal enum Git {

      private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "git"
        }
      })

      private static let description = UserFacing<StrictString, InterfaceLocalization>(
        { localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "regenerates the project’s Git configuration files."
          case .deutschDeutschland:
            return "erstellt die Git‐Konfiguration des Projekts neu."
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
                return "Refreshing Git configuration..."
              case .deutschDeutschland:
                return "Git‐Konfiguration wird aufgefrischt ..."
              }
            }).resolved().formattedAsSectionHeader()
          )

          try options.project.refreshGitConfiguration(output: output)
        }
      )
    }
  }
#endif
