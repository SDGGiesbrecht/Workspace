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

final class AndroidTests: XCTestCase {

  func testFileSystemPermissions() throws {
    // #workaround(SDGCornerstone 4.3.2, SDGCornerstone method crashes.)
    try {
      var directory: URL

      print("No volume‐specific.")
      if let anyVolume = try? FileManager.default.url(
        for: .itemReplacementDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
        ) {
        print("Volume‐agnostic:", anyVolume.path)
        directory = anyVolume
      } else {
        print("No volume‐agnostic.")
        return
        if #available(macOS 10.12, iOS 10, watchOS 3, tvOS 10, *) {
          directory = FileManager.default.temporaryDirectory
          print("Generic temporary:", directory.path)
        } else {
          directory = URL(fileURLWithPath: NSTemporaryDirectory())
        }
      }
      print("Directory:", directory.path)

      directory.appendPathComponent(UUID().uuidString)
      print("UUID:", directory.path)
      defer { try? FileManager.default.removeItem(at: directory) }
      print("Executing closure...")
    }()

    #if !os(Android)  // #workaround(SDGCornerstone 4.3.2, Crashes for other reasons.)
      try FileManager.default.withTemporaryDirectory(appropriateFor: nil) { directory in
        try "text".save(to: directory.appendingPathComponent("Text.txt"))
      }
    #endif
  }
}
