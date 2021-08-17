/*
 RefreshContinuousIntegration.swift

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

    internal enum ContinuousIntegration {

      private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "continuous‐integration"
        case .deutschDeutschland:
          return "fortlaufende‐einbindung"
        }
      })

      private static let description = UserFacing<StrictString, InterfaceLocalization>(
        { localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "regenerates the project’s continuous integration configuration files."
          case .deutschDeutschland:
            return
              "erstellt die Konfigurationsdateien des Projekts, die fortlaufende Einbindung einrichten."
          }
        })

      private static let discussion = UserFacing<StrictString, InterfaceLocalization>(
        { localization in
          switch localization {
          case .englishUnitedKingdom:
            return [
              "Workspace will create GitHub workflow files which configure GitHub to run all the tests from ‘Validate’ on every operating system supported by the project.",
              "",
              "Special Thanks:",
              "",
              "• GitHub (https://github.com)",
            ].joinedAsLines()
          case .englishUnitedStates, .englishCanada:
            return [
              "Workspace will create GitHub workflow files which configure GitHub to run all the tests from “Validate” on every operating system supported by the project.",
              "",
              "Special Thanks:",
              "",
              "• GitHub (https://github.com)",
            ].joinedAsLines()
          case .deutschDeutschland:
            return [
              "Arbeitsbereich erstellt GitHub‐Arbeitsablaufdateien, die GitHub konfigurieren, alle Teste von ‘Validate’ auf jede unterstützte Betriebssystem auszuführen.",
              "",
              "Besonderer Dank:",
              "",
              "• GitHub (https://github.com)",
            ].joinedAsLines()
          }
        })

      #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
        internal static let command = Command(
          name: name,
          description: description,
          discussion: discussion,
          directArguments: [],
          options: Workspace.standardOptions,
          execution: { (_, options: Options, output: Command.Output) throws in

            output.print(
              UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                  return "Refreshing continuous integration configuration..."
                case .deutschDeutschland:
                  return "Konfiguration für fortlaufende Einbindung wird aufgefrischt ..."
                }
              }).resolved().formattedAsSectionHeader()
            )

            try options.project.refreshContinuousIntegration(output: output)
          }
        )
      #endif
    }
  }
#endif
