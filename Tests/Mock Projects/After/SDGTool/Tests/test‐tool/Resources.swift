/*
 Resources.swift

 This source file is part of the SDG open source project.
 Diese Quelldatei ist Teil des qeulloffenen SDG‐Projekt.
 https://example.github.io/SDG/SDG

 Copyright ©2020 John Doe and the SDG project contributors.
 Urheberrecht ©2020 John Doe und die Mitwirkenden des SDG‐Projekts.
 ©2020

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

internal enum Resources {}
internal typealias Ressourcen = Resources

extension Resources {
  static let textResource = String(
    data: Data(base64Encoded: "SGVsbG8sIHdvcmxkIQ==")!,
    encoding: String.Encoding.utf8
  )!

}
