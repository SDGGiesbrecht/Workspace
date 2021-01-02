/*
 Workspace.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGText
import SDGLocalization
import SDGVersioning

import SDGCommandLine

import WorkspaceLocalizations
import WorkspaceProjectConfiguration

public enum Workspace: Tool {

  private static let projectName = UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "project"
    case .deutschDeutschland:
      return "projekt"
    }
  })
  private static let projectDescription = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return
          "The location of the target project if it is not at the current working directory."
      case .deutschDeutschland:
        return
          "Die Standort von dem Zielprojekt, wenn es nicht in dem aktuellen Arbeitsverzeichnis ist."
      }
    })
  // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
  #if !os(WASI)
    internal static let projectOption = Option(
      name: projectName,
      description: projectDescription,
      type: ArgumentType.path
    )
  #endif

  // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
  #if os(WASI)
    internal static let standardOptions: [AnyOption] = []
  #else
    internal static let standardOptions: [AnyOption] = [projectOption]
  #endif

  private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "workspace"
    case .deutschDeutschland:
      return "arbeitsbereich"
    }
  })

  private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
    switch localization {
    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
      return "automates management of Swift projects."
    case .deutschDeutschland:
      return "automatisiert die Verwaltung von Swift‐Projekten."
    }
  })

  public static let command = Command(
    name: name,
    description: description,
    subcommands: [

      // Primary Workflow
      Workspace.Refresh.command,
      Workspace.Validate.command,
      Workspace.Document.command,

      // Xcode Build Phase
      Workspace.Proofread.command,

      // Individual Steps
      Workspace.Normalize.command,
      Workspace.Test.command,

      // Other
      Workspace.CheckForUpdates.command,
    ]
  )

  // MARK: - Tool

  public static let applicationIdentifier: StrictString = "ca.solideogloria.Workspace"
  public static let version: Version? = Metadata.thisVersion
  public static let packageURL: URL? = Metadata.packageURL
  public static let rootCommand: Command = command
}
