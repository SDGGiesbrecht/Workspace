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

            func isConditionalCompilationOperator() -> Bool {
                return token.ancestors().contains(where: { ancestor in
                    if let parent = ancestor.parent as? IfConfigClauseSyntax,
                        parent.condition?.indexInParent == ancestor.indexInParent {
                        return true
                    } else {
                        return false
                    }
                })
            }

            check(
                token.text, range: token.syntaxRange(in: context),
                textFreedom: token.textFreedom,
                isPrefix: isPrefix(),
                isInfix: isInfix(),
                isConditionalCompilationOperator: isConditionalCompilationOperator(),
                file: file, project: project, status: status, output: output)
        }
    }

    internal static func check(_ node: ExtendedSyntax, context: ExtendedSyntaxContext, file: TextFile, project: PackageRepository, status: ProofreadingStatus, output: Command.Output) {
        if let token = node as? ExtendedTokenSyntax {

            func isCommentText() -> Bool {
                if case .commentText = token.kind {
                    return true
                } else {
                    return false
                }
            }

            check(
                token.text, range: token.range(in: context),
                textFreedom: token.kind.textFreedom,
                isPrefix: false,
                isInfix: false,
                isConditionalCompilationOperator: false,
                file: file, project: project, status: status, output: output)
        }
    }

    private static func check(
        _ node: String,
        range: @escaping @autoclosure () -> Range<String.ScalarView.Index>,
        textFreedom: TextFreedom,
        isPrefix: @escaping @autoclosure () -> Bool,
        isInfix: @escaping @autoclosure () -> Bool,
        isConditionalCompilationOperator: @escaping @autoclosure () -> Bool,
        file: TextFile,
        project: PackageRepository,
        status: ProofreadingStatus,
        output: Command.Output) {

        if textFreedom == .invariable {
            return
        }

        func check(for obsolete: String, replacement: StrictString? = nil,
                   onlyProhibitPrefixUse: Bool = false,
                   onlyProhibitInfixUse: Bool = false,
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

            if allowAsConditionalCompilationOperator ∧ isConditionalCompilationOperator() {
                return
            }

            if allowInToolsVersion {
                if file.fileType == .swiftPackageManifest,
                    let endOfFirstLine = file.contents.lines.first?.line.endIndex,
                    endOfFirstLine ≥ range().upperBound {
                    return
                }
            }

            for match in node.scalars.matches(for: obsolete.scalars) {
                let resolvedRange = range()
                let startOffset = node.scalars.distance(from: node.scalars.startIndex, to: match.range.lowerBound)
                let length = node.scalars.distance(from: match.range.lowerBound, to: match.range.upperBound)
                let lowerBound = file.contents.scalars.index(resolvedRange.lowerBound, offsetBy: startOffset)
                let upperBound = file.contents.scalars.index(lowerBound, offsetBy: length)
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
                            #warning("Temporarily disabled.")
                            //result += " " + aliasMessage.resolved(for: localization)
                        }
                        return result
                    }), status: status, output: output)
            }
        }

        check(for: "\u{2D}",
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

        check(for: "\u{2F}",
              replacement: "÷",
              onlyProhibitInfixUse: true,
              message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Use the division sign (÷)."
                }
              }), status: status, output: output)
    }
}
