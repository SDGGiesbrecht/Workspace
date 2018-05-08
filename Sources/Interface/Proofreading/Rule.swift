/*
 Rule.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import GeneralImports

protocol Rule {
    static var name: UserFacing<StrictString, InterfaceLocalization> { get }
    static var noticeOnly: Bool { get }
    static func check(file: TextFile, in project: PackageRepository, status: ProofreadingStatus, output: Command.Output) throws
}

extension Rule {

    // MARK: - Default Implementations

    static var noticeOnly: Bool {
        return false
    }

    // MARK: - Reporting

    static func reportViolation(in file: TextFile, at location: Range<String.ScalarView.Index>, replacementSuggestion: StrictString? = nil, message: UserFacing<StrictString, InterfaceLocalization>, status: ProofreadingStatus, output: Command.Output) {
        status.report(violation: StyleViolation(in: file, at: location, replacementSuggestion: replacementSuggestion, noticeOnly: noticeOnly, ruleIdentifier: Self.name, message: message), to: output)
    }

    // MARK: - Parsing Utilities

    static func lineRange(for match: PatternMatch<String.ScalarView>, in file: TextFile) -> Range<LineView<String>.Index> {
        return match.range.lines(in: file.contents.lines)
    }

    static func line(of match: PatternMatch<String.ScalarView>, in file: TextFile) -> String.ScalarView.SubSequence {
        let line = lineRange(for: match, in: file)
        return file.contents.lines[line.lowerBound].line
    }

    static func line(before match: PatternMatch<String.ScalarView>, in file: TextFile) -> String.ScalarView.SubSequence? {
        let line = lineRange(for: match, in: file)
        guard line.lowerBound ≠ file.contents.lines.startIndex else {
            return nil
        }
        return file.contents.lines[file.contents.lines.index(before: line.lowerBound)].line
    }

    static func line(after match: PatternMatch<String.ScalarView>, in file: TextFile) -> String.ScalarView.SubSequence? {
        let line = lineRange(for: match, in: file)
        guard line.upperBound ≠ file.contents.lines.endIndex else { // [_Exempt from Test Coverage_] Would require additional SwiftLint violations (final empty line), whose order is not deterministic.
            return nil
        }
        return file.contents.lines[line.upperBound].line
    }

    static func fromStartOfLine(to match: PatternMatch<String.ScalarView>, in file: TextFile) -> String.ScalarView.SubSequence {
        let line = lineRange(for: match, in: file)
        let range = line.sameRange(in: file.contents.scalars).lowerBound ..< match.range.lowerBound
        return file.contents.scalars[range]
    }

    static func upToEndOfLine(from match: PatternMatch<String.ScalarView>, in file: TextFile) -> String.ScalarView.SubSequence {
        let line = lineRange(for: match, in: file)
        let range = match.range.upperBound ..< line.sameRange(in: file.contents.scalars).upperBound
        return file.contents.scalars[range]
    }

    static func fromStartOfFile(to match: PatternMatch<String.ScalarView>, in file: TextFile) -> String.ScalarView.SubSequence {
        return file.contents.scalars[..<match.range.lowerBound]
    }

    static func upToEndOfFile(from match: PatternMatch<String.ScalarView>, in file: TextFile) -> String.ScalarView.SubSequence {
        return file.contents.scalars[match.range.upperBound...]
    }

    static func from(_ match: PatternMatch<String.ScalarView>, toNext searchTerm: StrictString, in file: TextFile) -> String.ScalarView.SubSequence? {
        return file.contents.scalars[match.range.upperBound...].prefix(upTo: String(searchTerm).scalars)?.contents
    }
}
