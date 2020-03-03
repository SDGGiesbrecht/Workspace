/*
 WSAndroidTests.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGPersistence

import XCTest

import SDGXCTestUtilities
import SDGPersistenceTestUtilities

final class AndroidTests: TestCase {

  func testCachePermissions() throws {
    var directory = FileManager.default.url(in: .cache, at: "Directory")
    try? FileManager.default.removeItem(at: directory)
    defer { try? FileManager.default.removeItem(at: directory) }

    try "text".save(to: directory.appendingPathComponent("Text.txt"))
  }

  func testRepositoryPresence() throws {
    compare("Android", against: testSpecificationDirectory().appendingPathComponent("Android.txt"), overwriteSpecificationInsteadOfFailing: false)

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
}
