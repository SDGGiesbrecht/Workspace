/*
 CrossPlatformTests.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGPersistence
import SDGExternalProcess
import SDGVersioning
import SDGSwift

@testable import CrossPlatform

import XCTest

import SDGXCTestUtilities
import SDGPersistenceTestUtilities

final class Tests: TestCase {

  func testCachePermissions() throws {
    let directory = FileManager.default.url(in: .cache, at: "Directory")
    try? FileManager.default.removeItem(at: directory)
    defer { try? FileManager.default.removeItem(at: directory) }

    try "text".save(to: directory.appendingPathComponent("Text.txt"))
  }

  func testGit() throws {
    #if !os(WASI)  // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
      #if !os(Android)  // #workaround(Swift 5.3, Emulator lacks Git.)
        #if os(Windows)
          // #workaround(SDGSwift 3.0.2, The standard way hits a segmentation fault.)
          guard
            let git = ExternalProcess(
              searching: [],
              commandName: "git",
              validate: { _ in true }
            )
          else {
            XCTFail("Failed to locate Git.")
            return
          }
          print(try git.run(["\u{2D}\u{2D}version"]).get())
        #else
          _ = try Git.runCustomSubcommand(
            ["\u{2D}\u{2D}version"],
            versionConstraints: Version(0)..<Version(Int.max)
          ).get()
        #endif
      #endif
    #endif
  }

  func
    testReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyLongTestName()
  {}

  func testRepositoryPresence() throws {
    compare(
      "Android",
      against: testSpecificationDirectory().appendingPathComponent("Android.txt"),
      overwriteSpecificationInsteadOfFailing: false
    )

    let ignored = testSpecificationDirectory()
      .deletingPathExtension().deletingPathExtension()
      .appendingPathComponent(".build/SDG/Ignored/Text.txt")
    try? FileManager.default.removeItem(at: ignored)
    defer { try? FileManager.default.removeItem(at: ignored) }
    try "text".save(to: ignored)
  }

  func testTemporaryDirectoryPermissions() throws {
    try FileManager.default.withTemporaryDirectory(appropriateFor: nil) { directory in
      try "text".save(to: directory.appendingPathComponent("Text.txt"))
    }
  }

  func testTests() {
    helloWorld()
    helloTests()
  }
}
