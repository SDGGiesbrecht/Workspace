/*
 Normalize.swift

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

import WSNormalization

extension Workspace {
  enum Normalize {

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom:
        return "normalise"
      case .englishUnitedStates, .englishCanada:
        return "normalize"
      case .deutschDeutschland:
        return "normalisieren"
      }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>({
      localization in
      switch localization {
      case .englishUnitedKingdom:
        return
          "normalises the project’s files by removing trailing whitespace, applying Unix newlines and performing canonical decomposition."
      case .englishUnitedStates, .englishCanada:
        return
          "normalizes the project’s files by removing trailing whitespace, applying Unix newlines and performing canonical decomposition."
      case .deutschDeutschland:
        return
          "normalisiert die Dateien des Projekt, in dem Leerzeichen vom Zeilenende entfernt werden, Unix‐Zeilenumbrüche eingetauscht werden und kanonische Zersetzung ausgeführt wird."
      }
    })

    static let command = Command(
      name: name, description: description, directArguments: [], options: standardOptions,
      execution: { (_: DirectArguments, options: Options, output: Command.Output) throws in
        try executeAsStep(options: options, output: output)
      })

    static func executeAsStep(options: Options, output: Command.Output) throws {

      if ¬options.runAsXcodeBuildPhase {
        output.print(
          UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom:
              return "Normalising files..."
            case .englishUnitedStates, .englishCanada:
              return "Normalizing files..."
            case .deutschDeutschland:
              return "Deteien werden normalisiert ..."
            }
          }).resolved().formattedAsSectionHeader())
      }

      try options.project.normalize(output: output)
    }
  }
}
