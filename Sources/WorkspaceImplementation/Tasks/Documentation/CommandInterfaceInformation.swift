/*
 CommandInterfaceInformation.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGExportedCommandLineInterface

import WorkspaceConfiguration

internal struct CommandInterfaceInformation {

  // MARK: - Initialization

  internal init() {}

  // MARK: - Properties

  internal var interfaces: [LocalizationIdentifier: CommandInterface] = [:]
  internal var relativePagePath: [LocalizationIdentifier: StrictString] = [:]

  internal func pageURL(
    in outputDirectory: URL,
    for localization: LocalizationIdentifier
  ) -> URL {
    return outputDirectory.appendingPathComponent(String(relativePagePath[localization]!))
  }
}
