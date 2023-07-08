/*
 PackageCLI.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGCollections

  import SDGExportedCommandLineInterface

  import WorkspaceConfiguration

  internal struct PackageCLI {

    // MARK: - Initialization

    internal init(
      tools: [URL],
      localizations: [LocalizationIdentifier]
    ) {
      var commands: [StrictString: CommandInterfaceInformation] = [:]
      for tool in tools {
        for localization in localizations {
          if let interface = try? CommandInterface.loadInterface(
            of: tool,
            in: localization.code
          ).get() {
            var modifiedInterface = interface
            modifiedInterface.sentenceCaseDescriptions()
            commands[interface.identifier, default: CommandInterfaceInformation()]
              .interfaces[localization] = modifiedInterface
          }
        }
      }
      self.commands = commands
    }

    // MARK: - Properties

    internal let commands: [StrictString: CommandInterfaceInformation]
  }
#endif
