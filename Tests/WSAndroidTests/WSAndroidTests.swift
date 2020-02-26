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

final class AndroidTests: TestCase {

  func testTemporaryDirectoryPermissions() throws {
    // #workaround(SDGCornerstone 4.3.2, SDGCornerstone method crashes.)
    try {
      var directory: URL
      if #available(macOS 10.12, iOS 10, watchOS 3, tvOS 10, *) {
        directory = FileManager.default.temporaryDirectory
      } else {
        directory = URL(fileURLWithPath: NSTemporaryDirectory())
      }
      directory.appendPathComponent(UUID().uuidString)
      defer { try? FileManager.default.removeItem(at: directory) }

      try "text".save(to: directory.appendingPathComponent("Text.txt"))
    }()

    #if !os(Android)  // #workaround(SDGCornerstone 4.3.2, Crashes for other reasons.)
      try FileManager.default.withTemporaryDirectory(appropriateFor: nil) { directory in
        try "text".save(to: directory.appendingPathComponent("Text.txt"))
      }
    #endif
  }

  func testCachePermissions() throws {
    var directory = FileManager.default.url(in: .cache, at: "Directory")
    try? FileManager.default.removeItem(at: directory)
    defer { try? FileManager.default.removeItem(at: directory) }

    try "text".save(to: directory.appendingPathComponent("Text.txt"))
  }
}
