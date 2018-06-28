/*
 AbsolutePath.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

struct AbsolutePath : ExpressibleByStringLiteral, Path {

    // MARK: - Initialization

    init(_ string: String) {
        self.string = string
    }

    // MARK: - Properties

    var string: String

    var url: URL {
        return URL(fileURLWithPath: string)
    }

    // MARK: - ExpressibleByStringLiteral

    init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}
