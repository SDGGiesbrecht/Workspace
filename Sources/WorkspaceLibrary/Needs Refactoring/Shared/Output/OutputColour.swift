/*
 OutputColour.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

enum OutputColour : String {

    // MARK: - Cases

    case red = "31"
    case green = "32"
    case yellow = "33"
    case blue = "34"

    // MARK: - Usage

    private var code: String {
        return rawValue
    }

    var start: String {
        return "\u{1B}[0;\(code)m"
    }

    static let end: String = "\u{1B}[0;30m"
}
