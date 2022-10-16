/*
 CrossPlatformTests.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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
    #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
      let directory = FileManager.default.url(in: .cache, at: "Directory")
      try? FileManager.default.removeItem(at: directory)
      defer { try? FileManager.default.removeItem(at: directory) }

      try "text".save(to: directory.appendingPathComponent("Text.txt"))
    #endif
  }

  func testGit() throws {
    #if !PLATFORM_LACKS_GIT
      _ = try Git.runCustomSubcommand(
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
    #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
      try? FileManager.default.removeItem(at: ignored)
      defer { try? FileManager.default.removeItem(at: ignored) }
      try "text".save(to: ignored)
    #endif
  }

  func testResources() {
    XCTAssert(getResourcePath().hasSuffix("Resource.txt"))
    #if !os(WASI)  // Web cannot actually load a resource without additional dependencies.
      XCTAssertEqual(try getResourceManually(), "Hello, world!")
    #endif
    XCTAssertEqual(getResource(), "Hello, world!")
  }

  func testTemporaryDirectoryPermissions() throws {
    #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
      try FileManager.default.withTemporaryDirectory(appropriateFor: nil) { directory in
        try "text".save(to: directory.appendingPathComponent("Text.txt"))
      }
    #endif
  }

  func testTests() {
    helloWorld()
    helloTests()
  }
}
