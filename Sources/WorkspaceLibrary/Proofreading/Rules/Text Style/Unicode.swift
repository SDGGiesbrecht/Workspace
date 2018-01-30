/*
 Unicode.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

struct UnicodeRule : Rule {

    static let name = UserFacingText<InterfaceLocalization, Void>({ (localization, _) in
        switch localization {
        case .englishCanada:
            return "Unicode"
        }
    })

    static func check(_ file: TextFile, for obsolete: String, replacement: StrictString? = nil,
                      allowTrailing: Bool = false,
                      allowInSwiftSource: Bool = false,
                      allowInShellSource: Bool = false,
                      allowInSampleCode: Bool = false,
                      allowInMarkdownList: Bool = false,
                      allowInURLs: Bool = false,
                      allowInConditionalCompilationStatement: Bool = false,
                      allowedAliasDefinitions: [StrictString] = [],
                      allowedDefaultImplementations: [String] = [],
                      allowInReturnArrow: Bool = false,
                      allowInHTMLComment: Bool = false,
                      allowInHeading: Bool = false,
                      allowInFloatLiteral: Bool = false,
                      allowInToolsVersion: Bool = false,
                      message: UserFacingText<InterfaceLocalization, Void>, status: ProofreadingStatus, output: inout Command.Output) {

        for protocolName in allowedDefaultImplementations where file.location.lastPathComponent == protocolName + ".swift" {
            return
        }

        matchesLoop: for match in file.contents.scalars.matches(for: obsolete.scalars) {

            if allowTrailing {
                if match.range.upperBound ≠ file.contents.scalars.endIndex {
                    if file.contents.scalars[match.range.upperBound] ∈ CharacterSet.whitespacesAndNewlines ∪ [
                        "!", "\u{22}", "\u{27}", ")", "*", ",", ".", "/",
                        ":", ";", "?",
                        "\u{5C}", "]", "\u{5F}",
                        "|", "}",
                        "„", "“", "”", "«", "»", "‚", "‘", "’", "‹", "›"] {
                        continue
                    }
                }
            }

            if allowInSwiftSource {
                switch file.fileType {
                case .swift, .swiftPackageManifest:
                    if ¬fromStartOfLine(to: match, in: file).contains("/\u{2F} ".scalars) /* Not a comment */
                        ∧ ¬fromStartOfFile(to: match, in: file).hasSuffix("\u{5C}".scalars) /* Not a string literal (escaped) */ {
                        continue
                    }
                default:
                    break
                }
            }

            if allowInShellSource {
                if fromStartOfLine(to: match, in: file).contains("[\u{5F}Workaround".scalars) {
                    continue
                }

                switch file.fileType {
                case .shell, .yaml, .gitignore:
                    if ¬fromStartOfLine(to: match, in: file).contains("#".scalars) /* Not a comment */ {
                        continue
                    }
                case .markdown, .workspaceConfiguration:
                    if fromStartOfFile(to: match, in: file).contains("```shell".scalars) ∧ upToEndOfFile(from: match, in: file).contains("```".scalars) {
                        continue
                    }
                default:
                    break
                }
            }

            if allowInSampleCode {
                switch file.fileType {
                case .markdown, .swift, .workspaceConfiguration:
                    if fromStartOfFile(to: match, in: file).contains("```".scalars)
                        ∧ upToEndOfFile(from: match, in: file).contains("```".scalars) {
                        continue
                    }
                    if fromStartOfLine(to: match, in: file).contains("`")
                        ∧ upToEndOfLine(from: match, in: file).contains("`") {
                        continue
                    }
                default:
                    break
                }
            }

            if allowInMarkdownList {
                switch file.fileType {
                case .markdown, .yaml:
                    if ¬fromStartOfLine(to: match, in: file).contains(where: { $0 ≠ " " }) {
                        continue
                    }
                case .swift:
                    if fromStartOfLine(to: match, in: file).hasSuffix(CompositePattern([
                        LiteralPattern("///".scalars),
                        RepetitionPattern(" ".scalars)
                        ])) {
                        continue
                    }
                case .workspaceConfiguration:
                    if fromStartOfFile(to: match, in: file).contains("[_Begin Feature List_]".scalars)
                        ∧ upToEndOfFile(from: match, in: file).contains("[_End_]".scalars) {
                        continue
                    }
                    if fromStartOfFile(to: match, in: file).contains("[_Begin Other Read‐Me Content_]".scalars)
                        ∧ upToEndOfFile(from: match, in: file).contains("[_End_]".scalars) {
                        continue
                    }
                default:
                    break
                }
            }

            if allowInURLs {
                if line(of: match, in: file).contains("http".scalars) {
                    continue
                }
                switch file.fileType {
                case .markdown, .workspaceConfiguration:
                    if line(of: match, in: file).contains("](".scalars) {
                        continue
                    }
                default:
                    break
                }
            }

            if allowInConditionalCompilationStatement {
                if line(of: match, in: file).contains("\u{23}if".scalars) ∨ line(of: match, in: file).contains("\u{23}elseif".scalars) {
                    continue
                }
            }

            for alias in allowedAliasDefinitions {
                if line(before: match, in: file).contains(("func " + String(alias)).scalars) {
                    continue matchesLoop
                } else if line(of: match, in: file).contains("RecommendedOver".scalars) {
                    continue matchesLoop
                }
            }

            for implementation in allowedDefaultImplementations {
                if line(of: match, in: file).contains(implementation.scalars) {
                    continue matchesLoop
                }
            }

            if allowInReturnArrow {
                switch file.fileType {
                case .swift, .swiftPackageManifest:
                    if upToEndOfFile(from: match, in: file).hasPrefix(">".scalars) {
                        continue
                    }
                default:
                    break
                }
            }

            if allowInHTMLComment {
                if line(of: match, in: file).contains("<\u{21}\u{2D}\u{2D}".scalars)
                    ∨ line(of: match, in: file).contains("\u{2D}\u{2D}>".scalars) {
                    continue
                }
            }

            if allowInHeading {
                if fromStartOfFile(to: match, in: file).hasSuffix("MAR\u{4B}: ".scalars) {
                    continue
                }
            }

            if allowInFloatLiteral {
                if file.fileType == .swift {
                    if fromStartOfLine(to: match, in: file).contains("let ln2".scalars) {
                        continue
                    }
                }
            }

            if allowInToolsVersion {
                if file.fileType == .swiftPackageManifest {
                    if lineRange(for: match, in: file).lowerBound == file.contents.lines.startIndex {
                        continue
                    }
                }
            }

            reportViolation(in: file, at: match.range, replacementSuggestion: replacement, message:
                UserFacingText<InterfaceLocalization, Void>({ localization, _ in
                    let obsoleteMessage = UserFacingText<InterfaceLocalization, Void>({ localization, _ in
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
                            return error + " is obsolete."
                        }
                    })

                    return obsoleteMessage.resolved(for: localization) + " " + message.resolved(for: localization)
            }), status: status, output: &output)
        }
    }

    static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: inout Command.Output) {

        check(file, for: "\u{2D}",
              allowInShellSource: true,
              allowInSampleCode: true,
              allowInMarkdownList: true,
              allowInURLs: true,
              allowedAliasDefinitions: ["−", "subtract"],
              allowedDefaultImplementations: ["Negatable", "Numeric", "SignedNumeric"],
              allowInReturnArrow: true,
              allowInHTMLComment: true,
              allowInHeading: true,
              allowInFloatLiteral: true,
              allowInToolsVersion: true,
              message: UserFacingText<InterfaceLocalization, Void>({ localization, _ in
                switch localization {
                // Note to localizers: Adapt the recommendations for the target localization.
                case .englishCanada:
                    return "Use a hyphen (‐), minus sign (−), dash (—), bullet (•) or range symbol (–)."
                }
              }), status: status, output: &output)

        check(file, for: "\u{22}",
              allowInSwiftSource: true,
              allowInShellSource: true,
              allowInSampleCode: true,
              message: UserFacingText<InterfaceLocalization, Void>({ localization, _ in
            switch localization {
            // Note to localizers: Adapt the recommendations for the target localization.
            case .englishCanada:
                return "Use quotation marks (“, ”) or double prime (′′)."
            }
        }), status: status, output: &output)

        check(file, for: "\u{27}",
              allowInShellSource: true,
              allowInSampleCode: true,
              message: UserFacingText<InterfaceLocalization, Void>({ localization, _ in
                switch localization {
                // Note to localizers: Adapt the recommendations for the target localization.
                case .englishCanada:
                    return "Use an apostrophe (’), quotation marks (‘, ’), degrees (°) or prime (′)."
                }
              }), status: status, output: &output)

        check(file, for: "\u{21}\u{3D}",
              replacement: "≠",
              allowInShellSource: true,
              allowedAliasDefinitions: ["≠"],
              message: UserFacingText<InterfaceLocalization, Void>({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Use the not equal sign (≠)."
                }
              }), status: status, output: &output)

        check(file, for: "!",
              replacement: "¬",
              allowTrailing: true,
              allowInConditionalCompilationStatement: true,
              allowedAliasDefinitions: ["¬", "≠"],
              allowInHTMLComment: true,
              message: UserFacingText<InterfaceLocalization, Void>({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Use the not sign (¬)."
                }
              }), status: status, output: &output)

        check(file, for: "&\u{26}",
              replacement: "∧",
              allowInConditionalCompilationStatement: true,
              allowedAliasDefinitions: ["∧"],
              message: UserFacingText<InterfaceLocalization, Void>({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Use the conjunction sign (∧)."
                }
              }), status: status, output: &output)

        check(file, for: "\u{7C}|",
              replacement: "∨",
              allowInConditionalCompilationStatement: true,
              allowedAliasDefinitions: ["∨"],
              message: UserFacingText<InterfaceLocalization, Void>({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Use the disjunction sign (∨)."
                }
              }), status: status, output: &output)

        check(file, for: "\u{3C}=",
              replacement: "≤",
              allowInConditionalCompilationStatement: true,
              allowedAliasDefinitions: ["≤"],
              message: UserFacingText<InterfaceLocalization, Void>({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Use the less‐than‐or‐equal sign (≤)."
                }
              }), status: status, output: &output)

        check(file, for: "\u{3E}=",
              replacement: "≥",
              allowInConditionalCompilationStatement: true,
              allowedAliasDefinitions: ["≥"],
              message: UserFacingText<InterfaceLocalization, Void>({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Use the greater‐than‐or‐equal sign (≥)."
                }
              }), status: status, output: &output)

        check(file, for: " \u{2A} ",
              replacement: " × ",
              allowInConditionalCompilationStatement: true,
              allowedAliasDefinitions: ["×"],
              allowedDefaultImplementations: ["Numeric"],
              message: UserFacingText<InterfaceLocalization, Void>({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Use the multiplication sign (×)."
                }
              }), status: status, output: &output)

        check(file, for: "\u{2A}=",
              replacement: "×=",
              allowInConditionalCompilationStatement: true,
              allowedAliasDefinitions: ["×"],
              allowedDefaultImplementations: ["Numeric"],
              message: UserFacingText<InterfaceLocalization, Void>({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Use the multiplication sign (×)."
                }
              }), status: status, output: &output)

        check(file, for: " \u{2F} ",
              replacement: " ÷ ",
              allowInConditionalCompilationStatement: true,
              allowedAliasDefinitions: ["÷", "divide"],
              message: UserFacingText<InterfaceLocalization, Void>({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Use the division sign (÷)."
                }
              }), status: status, output: &output)

        check(file, for: "\u{2F}=",
              replacement: "÷=",
              allowInConditionalCompilationStatement: true,
              allowedAliasDefinitions: ["÷", "divide"],
              message: UserFacingText<InterfaceLocalization, Void>({ localization, _ in
                switch localization {
                case .englishCanada:
                    return "Use the division sign (÷)."
                }
              }), status: status, output: &output)
    }
}
