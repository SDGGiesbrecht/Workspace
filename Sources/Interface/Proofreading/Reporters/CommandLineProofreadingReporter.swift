/*
 CommandLineProofreadingReporter.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

class CommandLineProofreadingReporter : ProofreadingReporter {

    // MARK: - Static Properties

    static let `default` = CommandLineProofreadingReporter()

    // MARK: - Initialization

    private init() {

    }

    // MARK: - ProofreadingReporter

    func reportParsing(file: String, to output: Command.Output) {
        output.print(file.in(FontWeight.bold))
    }

    private func lineMessage(source: String, violation: Range<String.ScalarView.Index>) -> StrictString {
        let lines = source.lines
        let lineRange = violation.lines(in: lines)
        let lineNumber = lines.distance(from: lines.startIndex, to: lineRange.lowerBound) + 1
        return UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Line " + lineNumber.inDigits()
            }
        }).resolved()
    }

    private func display(source: String, violation: Range<String.ScalarView.Index>, replacementSuggestion: StrictString?, highlight: (String) -> String) -> String {
        let lines = source.lines
        let lineRange = violation.lines(in: lines)
        let context = lineRange.sameRange(in: source.clusters)
        let preceding = String(source.clusters[context.lowerBound ..< violation.lowerBound])
        let problem = highlight(String(source.clusters[violation])).in(Underline.underlined)
        let following = String(source.clusters[violation.upperBound ..< context.upperBound])
        var result = preceding + problem + following
        if let suggestion = replacementSuggestion {
            result += preceding + String(suggestion).formattedAsSuccess() + following
        }
        return result
    }

    func report(violation: StyleViolation, to output: Command.Output) {

        func highlight<S : StringFamily>(_ problem: S) -> S {
            if violation.noticeOnly {
                return problem.formattedAsWarning()
            } else {
                return problem.formattedAsError()
            }
        }

        let description = highlight(violation.message.resolved()) + " (" + violation.ruleIdentifier.resolved() + ")"

        output.print([
            String(lineMessage(source: violation.file.contents, violation: violation.range)),
            String(description),
            display(source: violation.file.contents, violation: violation.range, replacementSuggestion: violation.replacementSuggestion, highlight: highlight)
            ].joinAsLines())
    }

    // Parallel reporting style for test coverage.
    func report(violation: Range<String.ScalarView.Index>, in file: String, to output: Command.Output) {
        output.print([
            String(lineMessage(source: file, violation: violation)),
            display(source: file, violation: violation, replacementSuggestion: nil, highlight: { $0.formattedAsError() })
            ].joinAsLines())
    }
}
