/*
 Unicode.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGMathematics
import SDGCollections
import WSGeneralImports

import WSProject

import SDGSwiftSource

internal struct UnicodeRule : SyntaxRule {

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "unicode"
        }
    })

    private enum EitherTokenKind {
        case syntax(TokenKind)
        case extended(ExtendedTokenKind)
    }

    internal static func check(_ node: Syntax, context: SyntaxContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        if let token = node as? TokenSyntax {

            func isPrefix() -> Bool {
                if case .prefixOperator = token.tokenKind {
                    return true
                } else {
                    return false
                }
            }

            func isInfix() -> Bool {
                switch token.tokenKind {
                case .spacedBinaryOperator, .unspacedBinaryOperator:
                    return true
                default:
                    return false
                }
            }

            func isFloatLiteral() -> Bool {
                if case .floatingLiteral = token.tokenKind {
                    return true
                } else {
                    return false
                }
            }

            check(
                token.text, range: token.syntaxRange(in: context),
                textFreedom: token.textFreedom,
                kind: .syntax(token.tokenKind),
                isPrefix: isPrefix(),
                isInfix: isInfix(),
                isFloatLiteral: isFloatLiteral(),
                isMarkdownEntity: false,
                file: file, project: project, status: status, output: output)
        }
    }

    internal static func check(_ node: ExtendedSyntax, context: ExtendedSyntaxContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        if let token = node as? ExtendedTokenSyntax {

            func isMarkdownEntity() -> Bool {
                if token.kind == .documentationText,
                    token.nextToken()?.kind == .documentationText,
                    token.previousToken()?.kind == .documentationText {
                    return true
                } else {
                    return false
                }
            }

            check(
                token.text, range: token.range(in: context),
                textFreedom: token.kind.textFreedom,
                kind: .extended(token.kind),
                isPrefix: false,
                isInfix: false,
                isFloatLiteral: false,
                isMarkdownEntity: isMarkdownEntity(),
                file: file, project: project, status: status, output: output)
        }
    }

    private static func check(
        _ node: String,
        range: @escaping @autoclosure () -> Range<String.ScalarView.Index>,
        textFreedom: TextFreedom,
        kind: @escaping @autoclosure () -> EitherTokenKind,
        isPrefix: @escaping @autoclosure () -> Bool,
        isInfix: @escaping @autoclosure () -> Bool,
        isFloatLiteral: @escaping @autoclosure () -> Bool,
        isMarkdownEntity: @escaping @autoclosure() -> Bool,
        file: TextFile,
        project: PackageRepository,
        status: ProofreadingStatus,
        output: Command.Output) {

        if textFreedom == .invariable {
            return
        }
        let scope: UnicodeRuleScope
        switch kind() {
        case .syntax(let kind):
            switch kind {
            case .eof, .associatedtypeKeyword, .classKeyword, .deinitKeyword, .enumKeyword, .extensionKeyword, .funcKeyword, .importKeyword, .initKeyword, .inoutKeyword, .letKeyword, .operatorKeyword, .precedencegroupKeyword, .protocolKeyword, .structKeyword, .subscriptKeyword, .typealiasKeyword, .varKeyword, .fileprivateKeyword, .internalKeyword, .privateKeyword, .publicKeyword, .staticKeyword, .deferKeyword, .ifKeyword, .guardKeyword, .doKeyword, .repeatKeyword, .elseKeyword, .forKeyword, .inKeyword, .whileKeyword, .returnKeyword, .breakKeyword, .continueKeyword, .fallthroughKeyword, .switchKeyword, .caseKeyword, .defaultKeyword, .whereKeyword, .catchKeyword, .throwKeyword, .asKeyword, .anyKeyword, .falseKeyword, .isKeyword, .nilKeyword, .rethrowsKeyword, .superKeyword, .selfKeyword, .capitalSelfKeyword, .trueKeyword, .tryKeyword, .throwsKeyword, .__file__Keyword, .__line__Keyword, .__column__Keyword, .__function__Keyword, .__dso_handle__Keyword, .wildcardKeyword, .leftParen, .rightParen, .leftBrace, .rightBrace, .leftSquareBracket, .rightSquareBracket, .leftAngle, .rightAngle, .period, .prefixPeriod, .comma, .colon, .semicolon, .equal, .atSign, .pound, .prefixAmpersand, .arrow, .backtick, .backslash, .exclamationMark, .postfixQuestionMark, .infixQuestionMark, .stringQuote, .multilineStringQuote, .poundKeyPathKeyword, .poundLineKeyword, .poundSelectorKeyword, .poundFileKeyword, .poundColumnKeyword, .poundFunctionKeyword, .poundDsohandleKeyword, .poundAssertKeyword, .poundSourceLocationKeyword, .poundWarningKeyword, .poundErrorKeyword, .poundIfKeyword, .poundElseKeyword, .poundElseifKeyword, .poundAvailableKeyword, .poundFileLiteralKeyword, .poundImageLiteralKeyword, .poundColorLiteralKeyword, .unknown, .identifier, .unspacedBinaryOperator, .spacedBinaryOperator, .postfixOperator, .prefixOperator, .dollarIdentifier, .contextualKeyword, .stringInterpolationAnchor, .yield, .poundEndifKeyword:
                scope = .machineIdentifiers
            case .integerLiteral, .floatingLiteral:
                scope = .humanLanguage
            case .stringLiteral, .stringSegment:
                scope = .ambiguous
            }
        case .extended(let kind):
            switch kind {
            case .quotationMark, .escape, .lineCommentDelimiter, .openingBlockCommentDelimiter, .closingBlockCommentDelimiter, .commentURL, .mark, .lineDocumentationDelimiter, .openingBlockDocumentationDelimiter, .closingBlockDocumentationDelimiter, .bullet, .codeDelimiter, .language, .source, .headingDelimiter, .asterism, .fontModificationDelimiter, .linkDelimiter, .linkURL, .imageDelimiter, .quotationDelimiter, .callout, .parameter, .colon, .lineSeparator:
                scope = .machineIdentifiers
            case .string, .whitespace, .newlines:
                scope = .ambiguous
            case .commentText, .documentationText:
                scope = .humanLanguage
            }
        }

        func check(for obsolete: String, replacement: StrictString? = nil,
                   onlyProhibitPrefixUse: Bool = false,
                   onlyProhibitInfixUse: Bool = false,
                   allowInFloatLiteral: Bool = false,
                   allowAsConditionalCompilationOperator: Bool = false,
                   allowInToolsVersion: Bool = false,
                   allowInWorkarounds: Bool = false,
                   message: UserFacing<StrictString, InterfaceLocalization>, status: ProofreadingStatus, output: Command.Output) {

            if onlyProhibitPrefixUse ∧ ¬isPrefix() {
                return
            }

            if onlyProhibitInfixUse ∧ ¬isInfix() {
                return
            }

            if allowInFloatLiteral ∧ isFloatLiteral() {
                return
            }

            if isMarkdownEntity() {
                return
            }

            matchSearch: for match in node.scalars.matches(for: obsolete.scalars) {
                let resolvedRange = range()
                let startOffset = node.scalars.distance(from: node.scalars.startIndex, to: match.range.lowerBound)
                let length = node.scalars.distance(from: match.range.lowerBound, to: match.range.upperBound)
                let lowerBound = file.contents.scalars.index(resolvedRange.lowerBound, offsetBy: startOffset)
                let upperBound = file.contents.scalars.index(lowerBound, offsetBy: length)

                if allowInToolsVersion {
                    if file.fileType == .swiftPackageManifest,
                        let endOfFirstLine = file.contents.lines.first?.line.endIndex,
                        endOfFirstLine ≥ upperBound {
                        continue matchSearch
                    }
                }
                reportViolation(in: file, at: lowerBound ..< upperBound, replacementSuggestion: replacement, message:
                    UserFacing<StrictString, InterfaceLocalization>({ localization in
                        let obsoleteMessage = UserFacing<StrictString, InterfaceLocalization>({ localization in
                            switch localization {
                            case .englishCanada:
                                let error: StrictString
                                switch String(match.contents) {
                                case "\u{2D}":
                                    error = "U+002D"
                                case "\u{22}":
                                    error = "U+0022"
                                case "\u{27}":
                                    error = "U+0027"
                                default:
                                    error = StrictString("“\(StrictString(match.contents))”")
                                }
                                if match.contents.count == 1 {
                                    return "The character " + error + " is obsolete."
                                } else {
                                    return "The character sequence " + error + " is obsolete."
                                }
                            }
                        })

                        let aliasMessage = UserFacing<StrictString, InterfaceLocalization>({ localization in
                            switch localization {
                            case .englishCanada:
                                return "(Create an alias if necessary.)"
                            }
                        })

                        var result = obsoleteMessage.resolved(for: localization) + " " + message.resolved(for: localization)
                        if textFreedom == .aliasable {
                            result += " " + aliasMessage.resolved(for: localization)
                        }
                        return result
                    }), status: status, output: output)
            }
        }

        check(for: "\u{2D}",
              allowInFloatLiteral: true,
              allowInToolsVersion: true,
              allowInWorkarounds: true,
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                // Note to localizers: Adapt the recommendations for the target localization.
                case .englishCanada:
                    return "Use a hyphen (‐), minus sign (−), dash (—), bullet (•) or range symbol (–)."
                }
              }), status: status, output: output)

        check(for: "\u{22}",
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                // Note to localizers: Adapt the recommendations for the target localization.
                case .englishCanada:
                    return "Use quotation marks (“, ”) or double prime (′′)."
                }
              }), status: status, output: output)

        check(for: "\u{27}",
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                // Note to localizers: Adapt the recommendations for the target localization.
                case .englishCanada:
                    return "Use an apostrophe (’), quotation marks (‘, ’), degrees (°) or prime (′)."
                }
              }), status: status, output: output)

        check(for: "\u{21}\u{3D}",
              replacement: "≠",
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Use the not equal sign (≠)."
                }
              }), status: status, output: output)

        check(for: "!",
              replacement: "¬",
              onlyProhibitPrefixUse: true,
              allowAsConditionalCompilationOperator: true,
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Use the not sign (¬)."
                }
              }), status: status, output: output)

        check(for: "&\u{26}",
              replacement: "∧",
              allowAsConditionalCompilationOperator: true,
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Use the conjunction sign (∧)."
                }
              }), status: status, output: output)

        check(for: "\u{7C}|",
              replacement: "∨",
              allowAsConditionalCompilationOperator: true,
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Use the disjunction sign (∨)."
                }
              }), status: status, output: output)

        check(for: "\u{3C}=",
              replacement: "≤",
              allowAsConditionalCompilationOperator: true,
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Use the less‐than‐or‐equal sign (≤)."
                }
              }), status: status, output: output)

        check(for: "\u{3E}=",
              replacement: "≥",
              allowAsConditionalCompilationOperator: true,
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Use the greater‐than‐or‐equal sign (≥)."
                }
              }), status: status, output: output)

        check(for: "\u{2A}",
              replacement: "×",
              onlyProhibitInfixUse: true,
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Use the multiplication sign (×)."
                }
              }), status: status, output: output)

        check(for: "\u{2A}=",
              replacement: "×=",
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Use the multiplication sign (×)."
                }
              }), status: status, output: output)

        check(for: "\u{2F}",
              replacement: "÷",
              onlyProhibitInfixUse: true,
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Use the division sign (÷)."
                }
              }), status: status, output: output)

        check(for: "\u{2F}=",
              replacement: "÷=",
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Use the division sign (÷)."
                }
              }), status: status, output: output)
    }
}
