/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports
import WSProject

extension PackageRepository {

  public func refreshScripts(output: Command.Output) throws {

    for deprecated in Script.deprecatedFileNames {
      delete(location.appendingPathComponent(String(deprecated)), output: output)
    }

    for script in Script.allCases where script.isCheckedIn ∨ script.isRelevantOnCurrentDevice {
      try autoreleasepool {

        var file = try TextFile(
          possiblyAt: location.appendingPathComponent(String(script.fileName)),
          executable: true
        )
        file.contents.replaceSubrange(
          file.contents.startIndex..<file.headerStart,
          with: String(script.shebang())
        )
        file.header = file.header
        file.body = String(try script.source(for: self, output: output))
        try file.writeChanges(for: self, output: output)
      }
    }
  }
}
