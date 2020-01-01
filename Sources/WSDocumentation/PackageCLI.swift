/*
 PackageCLI.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import WSGeneralImports

import SDGExportedCommandLineInterface

import WSProject

internal struct PackageCLI {

  // MARK: - Static Methods

  private static func toolsDirectory(for localization: LocalizationIdentifier) -> StrictString {
    var result = localization._directoryName + "/"
    if let match = localization._reasonableMatch {
      switch match {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        result += "Tools"
      case .deutschDeutschland:
        result += "Programme"
      }
    } else {
      result += "executable"
    }
    return result
  }

  // MARK: - Initialization

  internal init(tools: [URL], localizations: [LocalizationIdentifier]) {
    var commands: [StrictString: CommandInterfaceInformation] = [:]
    for tool in tools {
      for localization in localizations {
        if let interface = try? CommandInterface.loadInterface(
          of: tool,
          in: localization.code
        ).get() {
          var modifiedInterface = interface
          modifiedInterface.sentenceCaseDescriptions()

          commands[
            interface.identifier,
            default: CommandInterfaceInformation()].interfaces[localization] = modifiedInterface

          let directory = PackageCLI.toolsDirectory(for: localization)
          let filename = Page.sanitize(fileName: interface.name)
          let path = directory + "/" + filename + ".html"

          commands[interface.identifier]!.relativePagePath[localization] = path
        }
      }
    }
    self.commands = commands
  }

  // MARK: - Properties

  let commands: [StrictString: CommandInterfaceInformation]
}
