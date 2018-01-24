/*
 CalloutCasing.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

struct CalloutCasing : Rule {

    static let name = UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
        switch localization {
        case .englishCanada:
            return "Callout Casing"
        }
    })

    static let message = UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
        switch localization {
        case .englishCanada:
            return "Callouts should be capitalized."
        }
    })

    static func check(file: TextFile, status: ProofreadingStatus, output: inout Command.Output) {
        if file.fileType == .swift {
            for match in file.contents.scalars.matches(for: "//\u{2F} \u{2D} ".scalars) {
                if let next = upToEndOfFile(from: match, in: file).first,
                    next ∈ CharacterSet.lowercaseLetters {

                    var endOfWord = match.range.upperBound
                    file.contents.scalars.advance(&endOfWord, over: RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.letters })))
                    if endOfWord ≠ file.contents.scalars.endIndex,
                        file.contents.scalars[endOfWord] == ":" {

                        let replacement = StrictString(String(next).uppercased())
                        reportViolation(in: file, at: match.range, replacementSuggestion: replacement, message: message, status: status, output: &output)
                    }
                }
            }
        }
    }
}
