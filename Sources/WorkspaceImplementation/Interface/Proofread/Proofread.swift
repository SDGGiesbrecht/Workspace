/*
 Proofread.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift

import WorkspaceLocalizations

extension Workspace {
  internal enum Proofread {

    internal static let command = Command(
      name: Workspace.Proofread.Proofread.name,
      description: Workspace.Proofread.Proofread.description,
      subcommands: [
        Workspace.Proofread.Proofread.command,
        Workspace.Proofread.GenerateXcodeProject.command,
      ],
      defaultSubcommand: Workspace.Proofread.Proofread.command
    )
  }
}
