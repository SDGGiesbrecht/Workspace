/*
 CommandLineProofreadingReporter.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

class CommandLineProofreadingReporter : ProofreadingReporter {

    // MARK: - Static Properties

    static let `default` = CommandLineProofreadingReporter()

    // MARK: - Initialization

    private init() {

    }

    // MARK: - ProofreadingReporter

    func reportParsing(file: String, to output: inout Command.Output) {
        print(file.in(FontWeight.bold), to: &output)
    }

    func report(violation: StyleViolation, to output: inout Command.Output) {

        func highlight<S : StringFamily>(_ problem: S) -> S {
            if violation.noticeOnly {
                return problem.formattedAsWarning()
            } else {
                return problem.formattedAsError()
            }
        }

        let description = highlight(violation.message.resolved()) + " (" + violation.ruleIdentifier.resolved() + ")"

        let lines = violation.file.contents.lines
        let lineRange = violation.range.lines(in: lines)
        let lineNumber = lines.distance(from: lines.startIndex, to: lineRange.lowerBound) + 1
        let lineMessage = UserFacingText<InterfaceLocalization, Void>({ localization, _ in
            switch localization {
            case .englishCanada:
                return "Line " + lineNumber.inDigits()
            }
        }).resolved()

        let context = lineRange.sameRange(in: violation.file.contents.clusters)!
        let preceding = String(violation.file.contents.clusters[context.lowerBound ..< violation.range.lowerBound])
        let problem = highlight(String(violation.file.contents.clusters[violation.range])).in(Underline.underlined)
        let following = String(violation.file.contents.clusters[violation.range.upperBound ..< context.upperBound])
        var display = preceding + problem + following

        if let suggestion = violation.replacementSuggestion {
            display += preceding + String(suggestion).formattedAsSuccess() + following
        }

        let message = [
            String(lineMessage),
            String(description),
            display
            ].joinAsLines()

        print(message, to: &output)
    }
}
