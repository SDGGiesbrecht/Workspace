/*
 InternalTests.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2016–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2016–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift

import WorkspaceLocalizations
import WorkspaceConfiguration
@testable import WorkspaceImplementation

import XCTest

import SDGXCTestUtilities

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
      String(Script.refreshMacOS.fileName(localization: .englishCanada)),
      String(Script.refreshLinux.fileName(localization: .englishCanada)),
      "Resources",

      // Git
      ".gitignore",

      // GitHub
      "README.md",
      "LICENSE.md",
      ".github",
    ]

    // #workaround(Swift 5.3.3, Emulator lacks Git.)
    #if !os(Android)
      _ = try Command(
        name: UserFacing<StrictString, InterfaceLocalization>({ _ in "" }),
        description: UserFacing<StrictString, InterfaceLocalization>({ _ in "" }),
        directArguments: [],
        options: [],
        execution: { (_, _, output: Command.Output) in

          #if !PLATFORM_LACKS_FOUNDATION_PROCESS_INFO
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
                unexpected.joinedAsLines(),
              ].joinedAsLines()
            )
          #endif

        }
      ).execute(with: []).get()
    #endif
  }

  func testPlatform() {
    for platform in Platform.allCases {
      for localization in ContentLocalization.allCases {
        _ = platform._isolatedName(for: localization)
      }
    }
  }

  func testXcodeProjectFormat() {
    // .gitignore interferes with testing this reliably in a mock project.
    _ = FileType.xcodeProject.syntax
  }
}
