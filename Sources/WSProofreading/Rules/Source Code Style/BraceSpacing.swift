/*
 BraceSpacing.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGMathematics
import WSGeneralImports

import SwiftSyntax
import SDGSwiftSource

import WSProject

internal struct BraceSpacing : SyntaxRule {

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "braceSpacing"
        case .deutschDeutschland:
            return "abstandGeschweifterKlammern"
        }
    })

    private static let requiredInternalSpaceMessage = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Braces should be separated from their contents by a space."
        case .deutschDeutschland:
            return "Geschweifte Klammern sollen von ihrem Inhalt mit einem Leerzeichen getrennt sein."
        }
    })
    private static let requiredOpeningInternalSpaceSuggestion: StrictString = "{ "
    private static let requiredClosingInternalSpaceSuggestion: StrictString = " }"

    private static let prohibitedInternalSpaceMessage = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Empty braces should not contain spaces."
        case .deutschDeutschland:
            return "Leere geschweifte Klammern sollen keinen Leerzeichen beinhalten."
        }
    })
    private static let prohibitedOpeningSpaceSuggestion: StrictString = "{"
    private static let prohibitedClosingSpaceSuggestion: StrictString = "}"

    internal static func check(_ node: Syntax, context: SyntaxContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {

        if let token = node as? TokenSyntax {

            func check(
                kind: TokenKind,
                oppositeKind: TokenKind,
                getImmediateOpposite: (TokenSyntax) -> TokenSyntax?,
                getInternalTrivia: (TokenSyntax) -> Trivia,
                getOppositeInternalTrivia: (TokenSyntax) -> Trivia,
                getFirstInternalTrivia: (TokenSyntax) -> TriviaPiece?,
                extendInternalBound: (Range<String.ScalarView.Index>, Int) -> Range<String.ScalarView.Index>,
                requiredInternalSuggestion: StrictString,
                prohibitedSuggestion: StrictString) {

                if token.tokenKind == kind {

                    // Internal
                    let requiresInternalSpace: Bool
                    if let next = getImmediateOpposite(token),
                        next.tokenKind == oppositeKind,
                        getInternalTrivia(token).isEffectivelyEmpty(),
                        getOppositeInternalTrivia(next).isEffectivelyEmpty() {
                        requiresInternalSpace = false
                    } else {
                        requiresInternalSpace = true
                    }

                    var internalViolation: (message: UserFacing<StrictString, InterfaceLocalization>, suggestion: StrictString, range: Range<String.ScalarView.Index>)?
                    if let firstInternalTrivia = getFirstInternalTrivia(token) {
                        switch firstInternalTrivia {
                        case .spaces, .tabs, .verticalTabs, .formfeeds, .newlines, .carriageReturns, .carriageReturnLineFeeds:
                            if ¬requiresInternalSpace {
                                var range = token.syntaxRange(in: context)
                                range = extendInternalBound(range, firstInternalTrivia.text.scalars.count)
                                internalViolation = (prohibitedInternalSpaceMessage, prohibitedSuggestion, range)
                            }
                        case .backticks, .lineComment, .blockComment, .docLineComment, .docBlockComment, .garbageText:
                            if requiresInternalSpace {
                                internalViolation = (requiredInternalSpaceMessage, requiredInternalSuggestion, token.syntaxRange(in: context))
                            }
                        }
                    } else {
                        // No trivia.
                        if requiresInternalSpace {
                            internalViolation = (requiredInternalSpaceMessage, requiredInternalSuggestion, token.syntaxRange(in: context))
                        }
                    }
                    if let violation = internalViolation {
                        if ¬context.isFragmented() {
                            reportViolation(in: file, at: violation.range, replacementSuggestion: violation.suggestion, message: violation.message, status: status, output: output)
                        }
                    }
                }
            }

            check(
                kind: .leftBrace,
                oppositeKind: .rightBrace,
                getImmediateOpposite: { $0.nextToken() },
                getInternalTrivia: { $0.trailingTrivia },
                getOppositeInternalTrivia: { $0.leadingTrivia },
                getFirstInternalTrivia: { $0.firstFollowingTrivia() },
                extendInternalBound: { $0.lowerBound ..< file.contents.scalars.index($0.upperBound, offsetBy: $1) },
                requiredInternalSuggestion: requiredOpeningInternalSpaceSuggestion,
                prohibitedSuggestion: prohibitedOpeningSpaceSuggestion)
            check(
                kind: .rightBrace,
                oppositeKind: .leftBrace,
                getImmediateOpposite: { $0.previousToken() },
                getInternalTrivia: { $0.leadingTrivia },
                getOppositeInternalTrivia: { $0.trailingTrivia },
                getFirstInternalTrivia: { $0.firstPrecedingTrivia() },
                extendInternalBound: { file.contents.scalars.index($0.lowerBound, offsetBy: −$1) ..< $0.upperBound },
                requiredInternalSuggestion: requiredClosingInternalSpaceSuggestion,
                prohibitedSuggestion: prohibitedClosingSpaceSuggestion)
        }
    }
}
