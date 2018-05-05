/*
 Mark.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic
import SDGCollections

import SDGCommandLine

import SDGSwift

struct Mark : Rule {

    static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Mark"
        }
    })

    static let expectedSyntax: StrictString = "/\u{2F} MAR\u{4B}: \u{2D} "

    static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return StrictString("Incomplete heading syntax. Use “\(expectedSyntax)”.")
        }
    })

    static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        for match in file.contents.scalars.matches(for: "MAR\u{4B}".scalars) {

            var errorExists = false
            var errorStart = match.range.lowerBound
            var errorEnd = match.range.upperBound

            let line = file.contents.lineRange(for: match.range)
            if file.contents.scalars[line].hasPrefix(CompositePattern([
                RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces })),
                LiteralPattern("//".scalars)
                ])) {

                if ¬file.contents.scalars[..<match.range.lowerBound].hasSuffix(CompositePattern([
                    NotPattern(LiteralPattern("/".scalars)),
                    LiteralPattern("/\u{2F} ".scalars)
                    ])) {
                    errorExists = true

                    var possibleStart = match.range.lowerBound
                    while possibleStart ≠ file.contents.scalars.startIndex {
                        let previous = file.contents.scalars.index(before: possibleStart)
                        if file.contents.scalars[previous] ∈ CharacterSet.whitespaces ∪ ["/"] {
                            possibleStart = previous
                        } else {
                            break
                        }
                    }
                    errorStart = possibleStart
                }

                if ¬file.contents.scalars[match.range.upperBound...].hasPrefix(CompositePattern([
                    LiteralPattern(": \u{2D} ".scalars),
                    NotPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces }))
                    ])) {
                    errorExists = true

                    file.contents.scalars.advance(&errorEnd, over: CompositePattern([
                        RepetitionPattern(LiteralPattern(":".scalars), count: 0 ... 1),
                        RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces })),
                        RepetitionPattern(LiteralPattern("\u{2D}".scalars), count: 0 ... 1),
                        RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces }))
                        ]))
                }

                if errorExists {
                    reportViolation(in: file, at: errorStart ..< errorEnd, replacementSuggestion: expectedSyntax, message: message, status: status, output: output)
                }
            }
        }
    }
}
