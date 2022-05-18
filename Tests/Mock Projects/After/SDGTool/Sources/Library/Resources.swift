/*
 Resources.swift

 This source file is part of the SDG open source project.
 Diese Quelldatei ist Teil des quelloffenen SDG‐Projekt.
 https://example.github.io/SDG/SDG

 Copyright ©[Current Date] John Doe and the SDG project contributors.
 Urheberrecht ©[Current Date] John Doe und die Mitwirkenden des SDG‐Projekts.
 ©[Current Date]

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

internal enum Resources {}
internal typealias Ressourcen = Resources

extension Resources {
  internal enum Namespace {
    internal static var dataResource: Data {
      return Data(([] as [[UInt8]]).lazy.joined())
    }
  }
  private static let _2001_01_01_NamedWithNumbers0: [UInt8] = [
    0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20,
    0x77, 0x6F, 0x72, 0x6C, 0x64, 0x21,
  ]
  internal static var _2001_01_01_NamedWithNumbers: String {
    return String(
      data: Data(([_2001_01_01_NamedWithNumbers0] as [[UInt8]]).lazy.joined()),
      encoding: String.Encoding.utf8
    )!
  }
  private static let _namedWithPunctuation0: [UInt8] = [
    0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20,
    0x77, 0x6F, 0x72, 0x6C, 0x64, 0x21,
  ]
  internal static var _namedWithPunctuation: String {
    return String(
      data: Data(([_namedWithPunctuation0] as [[UInt8]]).lazy.joined()),
      encoding: String.Encoding.utf8
    )!
  }
  private static let textResource0: [UInt8] = [
    0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20,
    0x77, 0x6F, 0x72, 0x6C, 0x64, 0x21,
  ]
  internal static var textResource: String {
    return String(
      data: Data(([textResource0] as [[UInt8]]).lazy.joined()),
      encoding: String.Encoding.utf8
    )!
  }

}
