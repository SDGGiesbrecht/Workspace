/*
 InternalTests.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2016–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2016–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

@testable import WSScripts
import WSGeneralTestImports

import WSProject

class InternalTests: TestCase {

  func testGitIgnoreCoverage() throws {

    let expectedPrefixes = [

      // Swift Package Manager
      "Package.swift",
      "Sources",
      "Tests",
      "Package.resolved",

      // Workspace
      "Workspace.swift",
      String(Script.refreshMacOS.fileName),
      String(Script.refreshLinux.fileName),
      "Resources",

      // Git
      ".gitignore",

      // GitHub
      "README.md",
      "LICENSE.md",
      ".github",

      // Travis CI
      ".travis.yml"
    ]

    _ = try Command(
      name: UserFacing<StrictString, InterfaceLocalization>({ _ in "" }),
      description: UserFacing<StrictString, InterfaceLocalization>({ _ in "" }),
      directArguments: [],
      options: [],
      execution: { (_, _, output: Command.Output) in

        let tracked = try PackageRepository(at: repositoryRoot).trackedFiles(output: output)
        let relative = tracked.map { $0.path(relativeTo: repositoryRoot) }
        let unexpected = relative.filter { path in

          for prefix in expectedPrefixes {
            if path.hasPrefix(prefix) {
              return false
            }
          }

          return true
        }

        XCTAssert(
          unexpected.isEmpty,
          [
            "Unexpected files are being tracked by Git:",
            unexpected.joinedAsLines()
          ].joinedAsLines()
        )

      }
    ).execute(with: []).get()
  }

  func testXcodeProjectFormat() {
    // .gitignore interferes with testing this reliably in a mock project.
    _ = FileType.xcodeProject.syntax
  }
}
