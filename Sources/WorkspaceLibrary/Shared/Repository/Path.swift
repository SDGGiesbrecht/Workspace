/*
 Path.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

protocol Path : CustomStringConvertible, Equatable, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByStringLiteral, ExpressibleByUnicodeScalarLiteral {

    // MARK: - Initialization

    init(_ string: String)

    // MARK: - Properties

    var string: String { get }
}

extension Path {

    // MARK: - Properties

    var filename: String {
        let url = URL(fileURLWithPath: string)
        return url.lastPathComponent
    }

    var directory: String {
        let url = URL(fileURLWithPath: string)
        return url.deletingLastPathComponent().path
    }

    // MARK: - Usage

    func subfolderOrFile(_ path: String) -> Self {
        return Self(string + "/" + path)
    }

    // MARK: - CustomStringConvertible

    var description: String {
        return string
    }

    // MARK: - Equatable

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.string == rhs.string
    }
}
