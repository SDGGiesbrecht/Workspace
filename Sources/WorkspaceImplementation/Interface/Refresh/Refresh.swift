/*
 Refresh.swift

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

  import WorkspaceLocalizations

  extension Workspace {
    internal enum Refresh {

      private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "refresh"
        case .deutschDeutschland:
          return "auffrischen"
        }
      })

      private static let description = UserFacing<StrictString, InterfaceLocalization>(
        { localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return
              "refreshes the project by updating its components and readying it for development (provided any such tasks have been configured)."
          case .deutschDeutschland:
            return
              "frischt das Projekt auf, durch Aktualisierungen der Bestandteile und Vorbereitungen für Entwicklung (vorausgesetzt, solche Aufgaben konfiguriert sind)."
          }
        })

      private static var subcommands: [Command] {
        return [
          All.command,
          Scripts.command,
          Git.command,
          ReadMe.command,
          Licence.command,
          GitHub.command,
          ContinuousIntegration.command,
          Resources.command,
          FileHeaders.command,
          Examples.command,
          InheritedDocumentation.command,
        ]
      }

      internal static let command = Command(
        name: name,
        description: description,
        subcommands: subcommands,
        defaultSubcommand: All.command
      )
    }
  }
#endif
