/*
 TextRule.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGCommandLine

  import SDGSwift
  import SDGSwiftSource

  internal protocol TextRule: RuleProtocol {
    static func check(
      file: TextFile,
      in project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) throws
  }
#endif
