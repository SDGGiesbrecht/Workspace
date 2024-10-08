/*
 Resources 1.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2022–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2022–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

extension Resources {
  #if os(WASI)
    private static let resource0: [UInt8] = [
      0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20,
      0x77, 0x6F, 0x72, 0x6C, 0x64, 0x21,
    ]
    internal static var resource: String {
      return String(
        data: Data(([resource0] as [[UInt8]]).lazy.joined()),
        encoding: String.Encoding.utf8
      )!
    }
  #else
    internal static var resource: String {
      return String(
        data: try! Data(
          contentsOf: moduleBundle.url(forResource: "Resource", withExtension: "txt")!,
          options: [.mappedIfSafe]
        ),
        encoding: String.Encoding.utf8
      )!
    }
  #endif
}
