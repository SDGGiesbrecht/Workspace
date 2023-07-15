/*
 Resources 2.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2022–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2022–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

extension Resources {
  #if os(WASI)
    private static let copyright0: [UInt8] = [
      0x3C, 0x21, 0x2D, 0x2D, 0x0A, 0x20,
      0x43, 0x6F, 0x70,
      0x79, 0x72, 0x69, 0x67, 0x68, 0x74, 0x2E, 0x6D, 0x64, 0x0A, 0x0A, 0x20,
      0x54, 0x68, 0x69, 0x73, 0x20,
      0x73, 0x6F, 0x75, 0x72, 0x63, 0x65, 0x20,
      0x66, 0x69, 0x6C, 0x65, 0x20,
      0x69, 0x73, 0x20,
      0x70,
      0x61, 0x72, 0x74, 0x20,
      0x6F, 0x66, 0x20,
      0x74, 0x68, 0x65, 0x20,
      0x57, 0x6F, 0x72, 0x6B, 0x73, 0x70,
      0x61, 0x63, 0x65, 0x20,
      0x6F, 0x70,
      0x65, 0x6E, 0x20,
      0x73, 0x6F, 0x75, 0x72, 0x63, 0x65, 0x20,
      0x70,
      0x72, 0x6F, 0x6A, 0x65, 0x63, 0x74, 0x2E, 0x0A, 0x20,
      0x44, 0x69, 0x65, 0x73, 0x65, 0x20,
      0x51, 0x75, 0x65, 0x6C, 0x6C, 0x64, 0x61, 0x74, 0x65, 0x69, 0x20,
      0x69, 0x73, 0x74, 0x20,
      0x54, 0x65, 0x69, 0x6C, 0x20,
      0x64, 0x65, 0x73, 0x20,
      0x71, 0x75, 0x65, 0x6C, 0x6C, 0x6F, 0x66, 0x66, 0x65, 0x6E, 0x65, 0x6E, 0x20,
      0x41, 0x72, 0x62, 0x65, 0x69, 0x74, 0x73, 0x62, 0x65, 0x72, 0x65, 0x69, 0x63, 0x68, 0xE2,
      0x80,
      0x90,
      0x50,
      0x72, 0x6F, 0x6A, 0x65, 0x6B, 0x74, 0x2E, 0x0A, 0x20,
      0x68, 0x74, 0x74, 0x70,
      0x73, 0x3A, 0x2F, 0x2F, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 0x2E, 0x63, 0x6F, 0x6D, 0x2F,
      0x53, 0x44, 0x47, 0x47, 0x69, 0x65, 0x73, 0x62, 0x72, 0x65, 0x63, 0x68, 0x74, 0x2F, 0x57,
      0x6F, 0x72, 0x6B, 0x73, 0x70,
      0x61, 0x63, 0x65, 0x23, 0x77, 0x6F, 0x72, 0x6B, 0x73, 0x70,
      0x61, 0x63, 0x65, 0x0A, 0x0A, 0x20,
      0x43, 0x6F, 0x70,
      0x79, 0x72, 0x69, 0x67, 0x68, 0x74, 0x20,
      0xC2, 0xA9, 0x32, 0x30,
      0x31, 0x37, 0xE2, 0x80,
      0x93, 0x32, 0x30,
      0x32, 0x33, 0x20,
      0x4A, 0x65, 0x72, 0x65, 0x6D, 0x79, 0x20,
      0x44, 0x61, 0x76, 0x69, 0x64, 0x20,
      0x47, 0x69, 0x65, 0x73, 0x62, 0x72, 0x65, 0x63, 0x68, 0x74, 0x20,
      0x61, 0x6E, 0x64, 0x20,
      0x74, 0x68, 0x65, 0x20,
      0x57, 0x6F, 0x72, 0x6B, 0x73, 0x70,
      0x61, 0x63, 0x65, 0x20,
      0x70,
      0x72, 0x6F, 0x6A, 0x65, 0x63, 0x74, 0x20,
      0x63, 0x6F, 0x6E, 0x74, 0x72, 0x69, 0x62, 0x75, 0x74, 0x6F, 0x72, 0x73, 0x2E, 0x0A, 0x20,
      0x55, 0x72, 0x68, 0x65, 0x62, 0x65, 0x72, 0x72, 0x65, 0x63, 0x68, 0x74, 0x20,
      0xC2, 0xA9, 0x32, 0x30,
      0x31, 0x37, 0xE2, 0x80,
      0x93, 0x32, 0x30,
      0x32, 0x33, 0x20,
      0x4A, 0x65, 0x72, 0x65, 0x6D, 0x79, 0x20,
      0x44, 0x61, 0x76, 0x69, 0x64, 0x20,
      0x47, 0x69, 0x65, 0x73, 0x62, 0x72, 0x65, 0x63, 0x68, 0x74, 0x20,
      0x75, 0x6E, 0x64, 0x20,
      0x64, 0x69, 0x65, 0x20,
      0x4D, 0x69, 0x74, 0x77, 0x69, 0x72, 0x6B, 0x65, 0x6E, 0x64, 0x65, 0x6E, 0x20,
      0x64, 0x65, 0x73, 0x20,
      0x41, 0x72, 0x62, 0x65, 0x69, 0x74, 0x73, 0x62, 0x65, 0x72, 0x65, 0x69, 0x63, 0x68, 0xE2,
      0x80,
      0x90,
      0x50,
      0x72, 0x6F, 0x6A, 0x65, 0x6B, 0x74, 0x73, 0x2E, 0x0A, 0x0A, 0x20,
      0x53, 0x6F, 0x6C, 0x69, 0x20,
      0x44, 0x65, 0x6F, 0x20,
      0x67, 0x6C, 0x6F, 0x72, 0x69, 0x61, 0x2E, 0x0A, 0x0A, 0x20,
      0x4C, 0x69, 0x63, 0x65, 0x6E, 0x73, 0x65, 0x64, 0x20,
      0x75, 0x6E, 0x64, 0x65, 0x72, 0x20,
      0x74, 0x68, 0x65, 0x20,
      0x41, 0x70,
      0x61, 0x63, 0x68, 0x65, 0x20,
      0x4C, 0x69, 0x63, 0x65, 0x6E, 0x63, 0x65, 0x2C, 0x20,
      0x56, 0x65, 0x72, 0x73, 0x69, 0x6F, 0x6E, 0x20,
      0x32, 0x2E, 0x30,
      0x2E, 0x0A, 0x20,
      0x53, 0x65, 0x65, 0x20,
      0x68, 0x74, 0x74, 0x70,
      0x3A, 0x2F, 0x2F, 0x77, 0x77, 0x77, 0x2E, 0x61, 0x70,
      0x61, 0x63, 0x68, 0x65, 0x2E, 0x6F, 0x72, 0x67, 0x2F, 0x6C, 0x69, 0x63, 0x65, 0x6E, 0x73,
      0x65, 0x73, 0x2F, 0x4C, 0x49, 0x43, 0x45, 0x4E, 0x53, 0x45, 0x2D, 0x32, 0x2E, 0x30,
      0x20,
      0x66, 0x6F, 0x72, 0x20,
      0x6C, 0x69, 0x63, 0x65, 0x6E, 0x63, 0x65, 0x20,
      0x69, 0x6E, 0x66, 0x6F, 0x72, 0x6D, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x2E, 0x0A, 0x20,
      0x2D, 0x2D, 0x3E, 0x0A, 0x0A, 0x43, 0x6F, 0x70,
      0x79, 0x72, 0x69, 0x67, 0x68, 0x74, 0x20,
      0x23, 0x63, 0x6F, 0x70,
      0x79, 0x72, 0x69, 0x67, 0x68, 0x74, 0x20,
      0x23, 0x61, 0x75, 0x74, 0x68, 0x6F, 0x72, 0x73, 0x2E, 0x20,
      0x41, 0x6C, 0x6C, 0x20,
      0x72, 0x69, 0x67, 0x68, 0x74, 0x73, 0x20,
      0x72, 0x65, 0x73, 0x65, 0x72, 0x76, 0x65, 0x64, 0x2E, 0x0A, 0x0A, 0x2A, 0x2A, 0x54, 0x68,
      0x69, 0x73, 0x20,
      0x73, 0x6F, 0x66, 0x74, 0x77, 0x61, 0x72, 0x65, 0x20,
      0x69, 0x73, 0x20,
      0x73, 0x75, 0x62, 0x6A, 0x65, 0x63, 0x74, 0x20,
      0x74, 0x6F, 0x20,
      0x63, 0x6F, 0x70,
      0x79, 0x72, 0x69, 0x67, 0x68, 0x74, 0x20,
      0x6C, 0x61, 0x77, 0x2E, 0x20,
      0x49, 0x74, 0x20,
      0x6D, 0x61, 0x79, 0x20,
      0x6E, 0x6F, 0x74, 0x20,
      0x62, 0x65, 0x20,
      0x75, 0x73, 0x65, 0x64, 0x2C, 0x20,
      0x63, 0x6F, 0x70,
      0x69, 0x65, 0x64, 0x2C, 0x20,
      0x64, 0x69, 0x73, 0x74, 0x72, 0x69, 0x62, 0x75, 0x74, 0x65, 0x64, 0x20,
      0x6F, 0x72, 0x20,
      0x6D, 0x6F, 0x64, 0x69, 0x66, 0x69, 0x65, 0x64, 0x20,
      0x77, 0x69, 0x74, 0x68, 0x6F, 0x75, 0x74, 0x20,
      0x66, 0x69, 0x72, 0x73, 0x74, 0x20,
      0x6F, 0x62, 0x74, 0x61, 0x69, 0x6E, 0x69, 0x6E, 0x67, 0x20,
      0x61, 0x20,
      0x70,
      0x72, 0x69, 0x76, 0x61, 0x74, 0x65, 0x20,
      0x6C, 0x69, 0x63, 0x65, 0x6E, 0x63, 0x65, 0x20,
      0x66, 0x72, 0x6F, 0x6D, 0x20,
      0x74, 0x68, 0x65, 0x20,
      0x63, 0x6F, 0x70,
      0x79, 0x72, 0x69, 0x67, 0x68, 0x74, 0x20,
      0x68, 0x6F, 0x6C, 0x64, 0x65, 0x72, 0x28, 0x73, 0x29, 0x2E, 0x2A, 0x2A, 0x0A,
    ]
    internal static var copyright: String {
      return String(
        data: Data(([copyright0] as [[UInt8]]).lazy.joined()),
        encoding: String.Encoding.utf8
      )!
    }
  #else
    internal static var copyright: String {
      return String(
        data: try! Data(
          contentsOf: moduleBundle.url(forResource: "Copyright", withExtension: "md")!,
          options: [.mappedIfSafe]
        ),
        encoding: String.Encoding.utf8
      )!
    }
  #endif
}
