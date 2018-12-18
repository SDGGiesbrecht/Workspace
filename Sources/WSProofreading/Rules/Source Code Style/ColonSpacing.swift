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

    private static let precedingMessage = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Colons should not be preceded by spaces."
        }
    })

    private static let conformanceMessage = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Colons should be preceded by spaces when denoting protocols or superclasses."
        }
    })

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

                    // Trailing
                    var trailingViolation = false
                    if token.trailingTrivia.isEmpty {
                        trailingViolation = true
                    }
                    if let trivia = token.trailingTrivia.first {
                        switch trivia {
                        case .spaces, .tabs, .verticalTabs, .formfeeds, .newlines, .carriageReturns, .carriageReturnLineFeeds, .garbageText:
                            break
                        case .backticks, .lineComment, .blockComment, .docLineComment, .docBlockComment:
                            trailingViolation = true
                        }
                    }
                    if trailingViolation {
                        reportViolation(in: file, at: token.location(in: file.contents), replacementSuggestion: ": ", message: followingMessage, status: status, output: output)
                    }
                }
            })
            try scanner.scan(swift)
        }

        /*if file.fileType ∈ Set([.swift, .swiftPackageManifest]) {

            for match in file.contents.scalars.matches(for: ":".scalars) {

                if fromStartOfLine(to: match, in: file).contains("\u{22}") ∧ upToEndOfLine(from: match, in: file).contains("\u{22}") {
                    // String Literal
                    continue
                }

                if fromStartOfLine(to: match, in: file).contains("//".scalars) {
                    // Comment
                    continue
                }

                let protocolOrSuperclass: Bool

                if fromStartOfLine(to: match, in: file).contains("[") ∧ upToEndOfLine(from: match, in: file).contains("]") {
                    // Dictionary Literal
                    protocolOrSuperclass = false
                } else if fromStartOfFile(to: match, in: file).hasSuffix("_".scalars) {
                    protocolOrSuperclass = false
                } else if let startOfPreviousIdentifier = fromStartOfLine(to: match, in: file).components(separatedBy: ConditionalPattern({ $0 ∈ (CharacterSet.whitespaces ∪ CharacterSet.punctuationCharacters) ∪ CharacterSet.symbols })).filter({ ¬$0.range.isEmpty }).last?.contents.first {
                    protocolOrSuperclass = startOfPreviousIdentifier ∈ CharacterSet.uppercaseLetters
                } else {
                    protocolOrSuperclass = false
                }

                if let preceding = file.contents.scalars[..<match.range.lowerBound].last {
                    if preceding == " " {
                        if ¬protocolOrSuperclass,
                            ¬fromStartOfLine(to: match, in: file).contains(" ? ".scalars) /* Ternary Conditional Operator */ {

                            let precedingIndex = file.contents.scalars.index(before: match.range.lowerBound)
                            let errorRange = precedingIndex ..< match.range.upperBound

                            reportViolation(in: file, at: errorRange, replacementSuggestion: ":", message: precedingMessage, status: status, output: output)
                        }
                    } else if protocolOrSuperclass {
                        reportViolation(in: file, at: match.range, replacementSuggestion: " :", message: conformanceMessage, status: status, output: output)
                    }
                }

                if let following = file.contents.scalars[match.range.upperBound...].first,
                    following ∉ CharacterSet.whitespacesAndNewlines ∪ [
                        "]" /* Empty Dictionary Literal */,
                        "/" /* URL */
                    ] {

                    reportViolation(in: file, at: match.range, replacementSuggestion: ": ", message: followingMessage, status: status, output: output)
                }
            }
        }*/
    }
}
