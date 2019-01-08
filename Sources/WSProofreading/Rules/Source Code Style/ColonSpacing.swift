/*
 ColonSpacing.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import SDGSwiftSource

import WSProject

internal struct ColonSpacing : SyntaxRule {

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "colonSpacing"
        }
    })

    private static let prohibitedPrecedingSpaceMessage = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Colons should not be preceded by spaces."
        }
    })
    private static let prohibitedPrecedingSpaceSuggestion: StrictString = ":"

    private static let requiredPrecedingSpaceMessage = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Colons should be preceded by spaces when denoting conformance, inheritance or a ternary condition."
        }
    })
    private static let requiredPrecedingSpaceSuggestion: StrictString = " :"

    private static let requiredFollowingSpaceMessage = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Colons should be followed by spaces."
        }
    })
    private static let requiredFollowingSpaceSuggestion: StrictString = ": "

    private static let prohibitedFollowingSpaceMessage = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Colons should not be followed by spaces when denoting an empty dictionary literal or a function name."
        }
    })
    private static let prohibitedFollowingSpaceSuggestion: StrictString = ":"

    internal static func check(_ node: Syntax, in file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {

        if let token = node as? TokenSyntax,
            token.tokenKind == .colon {

            // Preceding
            let requiresPrecedingSpace: Bool
            if let inheritanceClause = token.parent as? TypeInheritanceClauseSyntax,
                inheritanceClause.colon.indexInParent == token.indexInParent {
                requiresPrecedingSpace = true
            } else if let conformanceRequirement = token.parent as? ConformanceRequirementSyntax,
                conformanceRequirement.colon.indexInParent == token.indexInParent {
                requiresPrecedingSpace = true
            } else if let genericParameter = token.parent as? GenericParameterSyntax,
                genericParameter.colon?.indexInParent == token.indexInParent {
                requiresPrecedingSpace = true
            } else if let ternaryExpression = token.parent as? TernaryExprSyntax,
                ternaryExpression.colonMark.indexInParent == token.indexInParent {
                requiresPrecedingSpace = true
            } else {
                requiresPrecedingSpace = false
            }

            var precedingViolation: (message: UserFacing<StrictString, InterfaceLocalization>, suggestion: StrictString, range: Range<String.ScalarView.Index>)?
            if let precedingTrivia = token.firstPrecedingTrivia() {
                switch precedingTrivia {
                case .spaces, .tabs, .verticalTabs, .formfeeds, .newlines, .carriageReturns, .carriageReturnLineFeeds:
                    if ¬requiresPrecedingSpace {
                        var range = token.syntaxRange(in: file.contents)
                        range = file.contents.scalars.index(range.lowerBound, offsetBy: −precedingTrivia.text.scalars.count) ..< range.upperBound
                        precedingViolation = (prohibitedPrecedingSpaceMessage, prohibitedPrecedingSpaceSuggestion, range)
                    }
                case .backticks, .lineComment, .blockComment, .docLineComment, .docBlockComment, .garbageText:
                    if requiresPrecedingSpace {
                        precedingViolation = (requiredPrecedingSpaceMessage, requiredPrecedingSpaceSuggestion, token.syntaxRange(in: file.contents))
                    }
                }
            } else {
                // No trivia.
                if requiresPrecedingSpace {
                    precedingViolation = (requiredPrecedingSpaceMessage, requiredPrecedingSpaceSuggestion, token.syntaxRange(in: file.contents))
                }
            }
            if let violation = precedingViolation {
                reportViolation(in: file, at: violation.range, replacementSuggestion: violation.suggestion, message: violation.message, status: status, output: output)
            }

            // Trailing
            let requiresFollowingSpace: Bool
            if let dictionary = token.parent as? DictionaryExprSyntax,
                dictionary.content.indexInParent == token.indexInParent {
                requiresFollowingSpace = false
            } else if let nameArgument = token.parent as? DeclNameArgumentSyntax,
                nameArgument.colon.indexInParent == token.indexInParent {
                requiresFollowingSpace = false
            } else {
                requiresFollowingSpace = true
            }

            var trailingViolation: (message: UserFacing<StrictString, InterfaceLocalization>, suggestion: StrictString, range: Range<String.ScalarView.Index>)?
            if let followingTrivia = token.firstFollowingTrivia() {
                switch followingTrivia {
                case .spaces, .tabs, .verticalTabs, .formfeeds, .newlines, .carriageReturns, .carriageReturnLineFeeds, .garbageText:
                    if ¬requiresFollowingSpace {
                        var range = token.syntaxRange(in: file.contents)
                        range = range.lowerBound ..< file.contents.scalars.index(range.upperBound, offsetBy: −followingTrivia.text.scalars.count)
                        trailingViolation = (prohibitedFollowingSpaceMessage, prohibitedFollowingSpaceSuggestion, token.syntaxRange(in: file.contents))
                    }
                case .backticks, .lineComment, .blockComment, .docLineComment, .docBlockComment:
                    if requiresFollowingSpace {
                        trailingViolation = (requiredFollowingSpaceMessage, requiredFollowingSpaceSuggestion, token.syntaxRange(in: file.contents))
                    }
                }
            } else {
                // No trivia.
                if requiresFollowingSpace {
                    trailingViolation = (requiredFollowingSpaceMessage, requiredFollowingSpaceSuggestion, token.syntaxRange(in: file.contents))
                }
            }

            if let violation = trailingViolation {
                reportViolation(in: file, at: violation.range, replacementSuggestion: violation.suggestion, message: violation.message, status: status, output: output)
            }
        }
    }
}
