/*
 ProofreadGenerateXcodeProject.swift

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

  extension Workspace.Proofread {

    internal enum GenerateXcodeProject {

      private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "generate‐xcode‐project"
        case .deutschDeutschland:
          return "xcode‐projekt‐erstellen"
        }
      })

      private static let description = UserFacing<StrictString, InterfaceLocalization>(
        { localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "generates an Xcode project that can display proofreading results inline."
          case .deutschDeutschland:
            return
              "erstellt ein Xcode‐Projekt, das Eregebnisse vom Korrekturlesen in den Dateien zeigt."
          }
        })

      internal static let command = Command(
        name: name,
        description: description,
        directArguments: [],
        options: Workspace.standardOptions,
        execution: { (_, options: Options, output: Command.Output) throws in
          try executeAsStep(options: options, output: output)
        }
      )

      internal static func executeAsStep(options: Options, output: Command.Output) throws {

        output.print(
          UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Generating Xcode project..."
            case .deutschDeutschland:
              return "Xcode‐Projekt wird erstellt ..."
            }
          }).resolved().formattedAsSectionHeader()
        )

        try options.project.refreshProofreadingXcodeProject(output: output)
      }
    }
  }
#endif
