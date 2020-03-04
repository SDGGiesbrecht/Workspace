/*
 RepositoryRoot.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

let repositoryRoot: URL = {
  if let overridden = ProcessInfo.processInfo.environment["SWIFTPM_PACKAGE_ROOT"] {
    // @exempt(from: tests)
    return URL(fileURLWithPath: overridden)
  } else {
    var result = URL(fileURLWithPath: #file)
    for _ in 1...3 {
      result.deleteLastPathComponent()
    }
    return result
  }
}()
