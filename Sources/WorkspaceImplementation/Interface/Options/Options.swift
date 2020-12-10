/*
 Options.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
#if !os(WASI)
  import Foundation
#endif

import SDGCommandLine

import SDGSwift

extension Options {

  // MARK: - General

  internal var job: ContinuousIntegrationJob? {
    return value(for: ContinuousIntegrationJob.option)
  }

  // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
  #if !os(WASI)
    internal var project: PackageRepository {
      let url =
        value(for: Workspace.projectOption)
        ?? URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
      return PackageRepository(at: url)
    }
  #endif

  // MARK: - Proofreading

  internal var runAsXcodeBuildPhase: Bool {
    return value(for: Workspace.Proofread.Proofread.runAsXcodeBuildPhase)
  }
}
