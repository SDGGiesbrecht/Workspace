/*
 RelativePath.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

struct RelativePath : ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByStringLiteral, ExpressibleByUnicodeScalarLiteral, Path {

    // MARK: - Initialization

    init(_ string: String) {
        self.string = string
    }

    // MARK: - Properties

    var string: String
    var url: URL {
        return Repository.absolute(self).url
    }

    // MARK: - ExpressibleByExtendedGraphemeClusterLiteral

    init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterType) {
        self.init(value)
    }

    // MARK: - ExpressibleByStringLiteral

    init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }

    // MARK: - ExpressibleByUnicodeScalarLiteral

    init(unicodeScalarLiteral value: UnicodeScalarType) {
        self.init(value)
    }
}
