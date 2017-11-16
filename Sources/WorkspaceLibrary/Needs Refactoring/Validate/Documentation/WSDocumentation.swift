/*
 WSDocumentation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

struct WSDocumentation {

    static let operatorCharacters: CharacterSet = {
        let sections: [CharacterSet] = [
            ["\u{2F}", "=", "\u{2D}", "+", "\u{21}", "\u{2A}", "%", "<", ">", "&", "|", "^", "~", "?"],
            CharacterSet(charactersIn: "\u{A1}" ..< "\u{A7}"),
            ["©", "«", "¬", "®", "°", "±", "¶", "»", "¿", "×", "÷", "‖", "\u{2017}"],
            CharacterSet(charactersIn: "\u{2020}" ..< "\u{2027}"),
            CharacterSet(charactersIn: "\u{2030}" ..< "\u{203E}"),
            CharacterSet(charactersIn: "\u{2041}" ..< "\u{2053}"),
            CharacterSet(charactersIn: "\u{2055}" ..< "\u{205E}"),
            CharacterSet(charactersIn: "\u{2190}" ..< "\u{23FF}"),
            CharacterSet(charactersIn: "\u{2500}" ..< "\u{2775}"),
            CharacterSet(charactersIn: "\u{2794}" ..< "\u{2BFF}"),
            CharacterSet(charactersIn: "\u{2E00}" ..< "\u{2E7F}"),
            CharacterSet(charactersIn: "\u{3001}" ..< "\u{3003}"),
            CharacterSet(charactersIn: "\u{3008}" ..< "\u{3030}"),

            ["."]
        ]
        return sections.reduce(CharacterSet()) { $0 ∪ $1 }
    }()

    static func generate(job: ContinuousIntegration.Job?, individualSuccess: @escaping (String) -> Void, individualFailure: @escaping (String) -> Void, output: inout Command.Output) {

    }
}
