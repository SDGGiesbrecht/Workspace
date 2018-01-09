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

import SDGCornerstone
import SDGCommandLine

struct Mark : Rule {
    
    static let name = UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
        switch localization {
        case .englishCanada:
            return "Mark"
        }
    })
    
    static let expectedSyntax: StrictString = "// MAR\u{4B}: \u{2D}"
    
    static let message = UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
        switch localization {
        case .englishCanada:
            return StrictString("Did you mean “\(expectedSyntax)”?")
        }
    })
    
    static func check(file: TextFile, status: ProofreadingStatus, output: inout Command.Output) {
        for match in file.contents.scalars.matches(for: "MAR\u{4B}".scalars) {
            
            var errorExists = false
            var errorStart = match.range.lowerBound
            var errorEnd = match.range.upperBound
            
            let line = file.contents.lineRange(for: match.range)
            if file.contents.scalars[line].hasPrefix(CompositePattern([
                RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.whitespaces })),
                LiteralPattern("//".scalars)
                ])) {
                
                if ¬file.contents.scalars[..<match.range.lowerBound].hasSuffix(CompositePattern([
                    NotPattern(LiteralPattern("/".scalars)),
                    LiteralPattern("// ".scalars)
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
                    NotPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.whitespaces })),
                    ])) {
                    errorExists = true
                    
                    file.contents.scalars.advance(&errorEnd, over: CompositePattern([
                        RepetitionPattern(LiteralPattern(":".scalars), count: 0 ... 1),
                        RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.whitespaces })),
                        RepetitionPattern(LiteralPattern("\u{2D}".scalars), count: 0 ... 1),
                        RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.whitespaces })),
                        ]))
                }
                
                if errorExists {
                    reportViolation(in: file, at: errorStart ..< errorEnd, replacementSuggestion: expectedSyntax, message: message, status: status, output: &output)
                }
            }
        }
    }
}
