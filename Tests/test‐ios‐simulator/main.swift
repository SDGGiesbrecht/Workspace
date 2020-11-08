/*
 main.swift

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

import SDGExternalProcess

import WorkspaceImplementation

do {
  // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
  #if !os(WASI)
    ProcessInfo.applicationIdentifier = "ca.solideogloria.Workspace.Tests"

    let repositoryRoot = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
      .deletingLastPathComponent().deletingLastPathComponent()

    let mockProject = repositoryRoot.appendingPathComponent("Tests/Mock Projects/After/Default")
    try FileManager.default.do(in: mockProject) {
      _ = try Shell.default.run(command: [
        "swift", "package", "generate\u{2D}xcodeproj",
        "\u{2D}\u{2D}enable\u{2D}code\u{2D}coverage",
      ]).get()
      _ = try Workspace.command.execute(with: ["validate", "test‐coverage", "•job", "ios"]).get()
    }
  #endif

} catch {
  print(error)
  // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
  #if !os(WASI)
    print(error.localizedDescription)
    exit(1)
  #endif
}
