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

@testable import WSCrossPlatform

import XCTest

import SDGXCTestUtilities
import SDGPersistenceTestUtilities

final class CrossPlatformTests: TestCase {

  func testCachePermissions() throws {
    var directory = FileManager.default.url(in: .cache, at: "Directory")
    try? FileManager.default.removeItem(at: directory)
    defer { try? FileManager.default.removeItem(at: directory) }

    try "text".save(to: directory.appendingPathComponent("Text.txt"))
  }

  func testGit() throws {
    #if os(Windows)  // #workaround(SDGSwift 1.0.0, Git cannot find itself.)
      let locations = try Shell.default.run(command: ["where", "git"]).get()
      let path = String(locations.lines.first!.line)
      let process = ExternalProcess(at: URL(fileURLWithPath: path))
      try process.run(["\u{2D}\u{2D}version"]).get()
    #elseif os(WASI)  // #workaround(Swift 5.2.2, Web lacks Foundation.)
    #elseif os(Android)  // #workaround(Swift 5.2.2, Process doesn’t work.)
    #else
      try Git.runCustomSubcommand(
        ["\u{2D}\u{2D}version"],
        versionConstraints: Version(0)..<Version(Int.max)
      ).get()
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
