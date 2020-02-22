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
    #warning("Debugging...")
    print("Here.");
    #warning("Debugging...")
    try {
      var directory: URL

      let volume = try? FileManager.default.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
      )
      #warning("Debugging...")
      print("Volume:", volume?.path)

      #warning("Debugging...")
      let experiment = try FileManager.default.url(
        for: .itemReplacementDirectory,
        in: .userDomainMask,
        appropriateFor: volume,
        create: true
      )
      print("Volume:", experiment.path)

      #warning("Debugging...")
      #if !os(Android)
        if let itemReplacement = try? FileManager.default.url(
          for: .itemReplacementDirectory,
          in: .userDomainMask,
          appropriateFor: volume,
          create: true
        ) {
          print("Volume‐specific:", itemReplacement.path)
          directory = itemReplacement
        } else {
          print("No volume‐specific.")
          #if !os(Android)
            if let anyVolume = try? FileManager.default.url(
              for: .itemReplacementDirectory,
              in: .userDomainMask,
              appropriateFor: nil,
              create: true
            ) {
              print("Volume‐agnostic:", anyVolume.path)
              directory = anyVolume
            } else {
              if #available(macOS 10.12, iOS 10, watchOS 3, tvOS 10, *) {
                directory = FileManager.default.temporaryDirectory
                print("Generic temporary:", directory.path)
              } else {
                directory = URL(fileURLWithPath: NSTemporaryDirectory())
              }
            }
          #endif
        }
        print("Directory:", directory.path)

        directory.appendPathComponent(UUID().uuidString)
        print("UUID:", directory.path)
        defer { try? FileManager.default.removeItem(at: directory) }
        print("Executing closure...")
      #endif
    }()

    #if !os(Android)
      #warning("Debugging...")
      try FileManager.default.withTemporaryDirectory(appropriateFor: nil) { directory in

        #warning("Debugging...")
        print(directory.path)

        try "text".save(to: directory.appendingPathComponent("Text.txt"))
      }
    #endif
  }
}
