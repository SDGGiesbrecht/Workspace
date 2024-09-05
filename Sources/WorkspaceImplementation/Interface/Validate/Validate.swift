/*
 Validate.swift

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
    internal enum Validate {

      private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "validate"
        case .deutschDeutschland:
          return "prüfen"
        }
      })

      private static let description = UserFacing<StrictString, InterfaceLocalization>(
        { localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "validates the project against a thorough battery of tests."
          case .deutschDeutschland:
            return "prüft das Projekt gegen eine gründliche Reihe von Teste."
          }
        })

      internal static let command = Command(
        name: name,
        description: description,
        subcommands: [
          All.command,
          Build.command,
          TestCoverage.command,
          DocumentationCoverage.command,
        ],
        defaultSubcommand: All.command
      )
    }
  }
#endif
