/*
 ColonSpacing.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import SDGSwiftSource

import WSProject

internal struct ColonSpacing : Rule {

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "colonSpacing"
        }
    })

    private static let prohibitedSpaceMessage = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Colons should not be preceded by spaces."
        }
    })
    private static let prohibitedSpaceSuggestion: StrictString = ":"

    private static let requiredSpaceMessage = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Colons should be preceded by spaces when denoting conformance, inheritance or a ternary conditional."
        }
    })
    private static let requiredSpaceSuggestion: StrictString = " :"

    private static let followingMessage = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Colons should be followed by spaces."
        }
    })

    internal static func check(file: TextFile, syntax: SourceFileSyntax?, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) throws {

        if let swift = syntax {
            let scanner = SyntaxScanner(checkSyntax: { node in
                if let token = node as? TokenSyntax,
                    token.tokenKind == .colon {

                    // Preceding
                    let requiresPrecedingSpace = false

                    var precedingViolation: (message: UserFacing<StrictString, InterfaceLocalization>, suggestion: StrictString, range: Range<String.ScalarView.Index>)?
                    if let precedingTrivia = token.firstPrecedingTrivia() {
                        switch precedingTrivia {
                        case .spaces, .tabs, .verticalTabs, .formfeeds, .newlines, .carriageReturns, .carriageReturnLineFeeds, .garbageText:
                            if ¬requiresPrecedingSpace {
                                var range = token.tokenRange(in: file.contents)
                                range = file.contents.scalars.index(range.lowerBound, offsetBy: −precedingTrivia.text.scalars.count) ..< range.upperBound
                                precedingViolation = (prohibitedSpaceMessage, prohibitedSpaceSuggestion, range)
                            }
                        case .backticks, .lineComment, .blockComment, .docLineComment, .docBlockComment:
                            if requiresPrecedingSpace {
                                precedingViolation = (requiredSpaceMessage, requiredSpaceSuggestion, token.tokenRange(in: file.contents))
                            }
                        }
                    } else {
                        // No trivia.
                        if requiresPrecedingSpace {
                            precedingViolation = (requiredSpaceMessage, requiredSpaceSuggestion, token.tokenRange(in: file.contents))
                        }
                    }
                    if let violation = precedingViolation {
                        reportViolation(in: file, at: violation.range, replacementSuggestion: violation.suggestion, message: violation.message, status: status, output: output)
                    }

                    // Trailing
                    var trailingViolation = false
                    if let followingTrivia = token.firstFollowingTrivia() {
                        switch followingTrivia {
                        case .spaces, .tabs, .verticalTabs, .formfeeds, .newlines, .carriageReturns, .carriageReturnLineFeeds, .garbageText:
                            break
                        case .backticks, .lineComment, .blockComment, .docLineComment, .docBlockComment:
                            trailingViolation = true
                        }
                    } else {
                        // No trivia.
                        if token.nextToken()?.tokenKind ≠ .rightSquareBracket /* Empty Dictionary Literal */ {
                            trailingViolation = true
                        }
                    }

                    if trailingViolation {
                        reportViolation(in: file, at: token.tokenRange(in: file.contents), replacementSuggestion: ": ", message: followingMessage, status: status, output: output)
                    }
                }
            })
            try scanner.scan(swift)
        }
    }
}
