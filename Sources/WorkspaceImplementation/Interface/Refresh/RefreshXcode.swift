/*
 RefreshXcode.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !os(Linux)

  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift

  import WSLocalizations

  extension Workspace.Refresh {

    internal enum Xcode {

      private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
          .deutschDeutschland:
          return "xcode"
        }
      })

      private static let description = UserFacing<StrictString, InterfaceLocalization>(
        { localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "regenerates the project’s Xcode set‐up."
          case .deutschDeutschland:
            return "erstellt die Xcode‐Einrichtung des Projekts neu."
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
              return "Refreshing Xcode project..."
            case .deutschDeutschland:
              return "Xcode‐Projekt wird aufgefrischt ..."
            }
          }).resolved().formattedAsSectionHeader()
        )

        // #workaround(Swift 5.2.4, Web lacks Foundation.)
        #if !os(WASI)
          try options.project.refreshXcodeProject(output: output)
        #endif
      }
    }
  }
#endif
