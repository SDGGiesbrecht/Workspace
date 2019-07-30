/*
 Resources.swift

 This source file is part of the SDG open source project.
 Diese Quelldatei ist Teil des qeulloffenen SDG‐Projekt.
 https://example.github.io/SDG/SDG

 Copyright ©2019 John Doe and the SDG project contributors.
 ©2019

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

internal enum Resources {}

extension Resources {
    enum Namespace {
        static let dataResource = Data(base64Encoded: "")!
    }
    static let _2001_01_01_NamedWithNumbers = String(data: Data(base64Encoded: "SGVsbG8sIHdvcmxkIQ==")!, encoding: String.Encoding.utf8)!
    static let _namedWithPunctuation = String(data: Data(base64Encoded: "SGVsbG8sIHdvcmxkIQ==")!, encoding: String.Encoding.utf8)!
    static let textResource = String(data: Data(base64Encoded: "SGVsbG8sIHdvcmxkIQ==")!, encoding: String.Encoding.utf8)!

}
