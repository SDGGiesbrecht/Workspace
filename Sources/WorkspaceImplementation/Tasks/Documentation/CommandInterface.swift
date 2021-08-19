/*
 CommandInterface.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGExportedCommandLineInterface

  extension CommandInterface {

    internal mutating func sentenceCaseDescriptions() {
      if let first = description.first,
        first.properties.isLowercase
      {
        description.scalars.removeFirst()
        description.scalars.prepend(
          contentsOf: first.properties.titlecaseMapping.scalars
        )
      }
      for index in subcommands.indices {
        subcommands[index].sentenceCaseDescriptions()
      }
    }
  }
#endif
