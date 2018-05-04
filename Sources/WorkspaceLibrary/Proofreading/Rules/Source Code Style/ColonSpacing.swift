/*
 ColonSpacing.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

struct ColonSpacing : Rule {

    static let name = UserFacingText<InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Colon Spacing"
        }
    })

    static let precedingMessage = UserFacingText<InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Colons should not be preceded by spaces."
        }
    })

    static let conformanceMessage = UserFacingText<InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Colons should be preceded by spaces when denoting protocols or superclasses."
        }
    })

    static let followingMessage = UserFacingText<InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "Colons should be followed by spaces."
        }
    })

    static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: inout Command.Output) {
        if file.fileType == .swift {

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

                            reportViolation(in: file, at: errorRange, replacementSuggestion: ":", message: precedingMessage, status: status, output: &output)
                        }
                    } else if protocolOrSuperclass {
                        reportViolation(in: file, at: match.range, replacementSuggestion: " :", message: conformanceMessage, status: status, output: &output)
                    }
                }

                if let following = file.contents.scalars[match.range.upperBound...].first,
                    following ∉ CharacterSet.whitespacesAndNewlines ∪ [
                        "]" /* Empty Dictionary Literal */,
                        "/" /* URL */
                    ] {

                    reportViolation(in: file, at: match.range, replacementSuggestion: ": ", message: followingMessage, status: status, output: &output)
                }
            }
        }
    }
}
