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
    internal static let dataResource = Data(base64Encoded: "")!
  }
  internal static let _2001_01_01_NamedWithNumbers = String(
    data: Data(base64Encoded: "SGVsbG8sIHdvcmxkIQ==")!,
    encoding: String.Encoding.utf8
  )!
  internal static let _namedWithPunctuation = String(
    data: Data(base64Encoded: "SGVsbG8sIHdvcmxkIQ==")!,
    encoding: String.Encoding.utf8
  )!
  internal static let textResource = String(
    data: Data(base64Encoded: "SGVsbG8sIHdvcmxkIQ==")!,
    encoding: String.Encoding.utf8
  )!

}
