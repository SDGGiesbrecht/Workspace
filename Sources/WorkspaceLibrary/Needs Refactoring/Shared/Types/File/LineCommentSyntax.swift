/*
 LineCommentSyntax.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic
import SDGCollections
import SDGLocalization

struct LineCommentSyntax {

    // MARK: - Initialization

    init(start: String, stylisticSpacing: Bool = true, stylisticEnd: String? = nil) {
        self.start = start
        self.stylisticSpacing = stylisticSpacing
        self.stylisticEnd = stylisticEnd
    }

    // MARK: - Properties

    private let start: String
    private let stylisticSpacing: Bool
    private let stylisticEnd: String?

    // MARK: - Output

    func comment(contents: String, indent: String = "") -> String {

        let spacing = stylisticSpacing ? " " : ""

        var first = true
        var result: [String] = []
        for line in contents.lines.map({ String($0.line) }) {
            var modified = start
            if ¬line.isWhitespace {
                modified += spacing + line
            }
            if let end = stylisticEnd {
                modified += spacing + end
            }

            if first {
                first = false
                result.append(modified)
            } else {
                result.append(indent + modified)
            }
        }

        return result.joinAsLines()
    }

    // MARK: - Parsing

    func commentExists(at location: String.Index, in string: String, countDocumentationMarkup: Bool = true) -> Bool {

        var index = location
        if ¬string.clusters.advance(&index, over: start.clusters) {
            return false
        } else {
            // Comment

            if countDocumentationMarkup {
                return true
            } else {
                // Make shure this isn’t documentation.

                if let nextCharacter = string[index...].unicodeScalars.first {

                    if nextCharacter ∈ CharacterSet.whitespacesAndNewlines {
                        return true
                    }
                }
                return false
            }
        }
    }

    private func restOfLine(at index: String.Index, in range: Range<String.Index>, of string: String) -> Range<String.Index> {

        if let newline = string.scalars.firstMatch(for: ConditionalPattern({ $0 ∈ CharacterSet.newlines }), in: (index ..< range.upperBound).sameRange(in: string.scalars))?.range.clusters(in: string.clusters) {

            return index ..< newline.lowerBound
        } else {
            return index ..< range.upperBound
        }
    }

    func rangeOfFirstComment(in range: Range<String.Index>, of string: String) -> Range<String.Index>? {

        guard let startRange = string.scalars.firstMatch(for: start.scalars, in: range.sameRange(in: string.scalars))?.range.clusters(in: string.clusters) else {
            return nil
        }

        let newline = AlternativePatterns([
            LiteralPattern("\u{D}\u{A}".scalars),
            ConditionalPattern({ $0 ∈ CharacterSet.newlines })
            ])

        var resultEnd = restOfLine(at: startRange.lowerBound, in: range, of: string).upperBound
        var testIndex: String.ScalarView.Index = resultEnd.samePosition(in: string.scalars)
        string.scalars.advance(&testIndex, over: RepetitionPattern(newline, count: 0 ... 1))

        string.scalars.advance(&testIndex, over: RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces})))

        while string.scalars.suffix(from: testIndex).hasPrefix(start.scalars) {
            resultEnd = restOfLine(at: testIndex.cluster(in: string.clusters), in: range, of: string).upperBound
            testIndex = resultEnd.samePosition(in: string.scalars)
            string.scalars.advance(&testIndex, over: RepetitionPattern(newline, count: 0 ... 1))

            string.scalars.advance(&testIndex, over: RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces})))
        }

        return startRange.lowerBound ..< resultEnd
    }

    func requireRangeOfFirstComment(in range: Range<String.Index>, of file: File) -> Range<String.Index> {

        guard let result = rangeOfFirstComment(in: range, of: file.contents) else {
            _ = file.requireRange(of: start, in: range) // Trigger error at File.
            unreachable()
        }

        return result
    }

    func firstComment(in range: Range<String.Index>, of string: String) -> String? {
        if let range = rangeOfFirstComment(in: range, of: string) {
            return String(string[range])
        } else {
            return nil
        }
    }

    func contentsOfFirstComment(in range: Range<String.Index>, of string: String) -> String? {
        guard let range = rangeOfFirstComment(in: range, of: string) else {
            return nil

        }

        let comment = String(string[range])
        let lines = comment.lines.map({ String($0.line) }).map { (line: String) -> String in

            var index = line.scalars.startIndex

            line.scalars.advance(&index, over: RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces })))
            guard line.scalars.advance(&index, over: start.scalars) else {
                line.parseError(at: index.cluster(in: line.clusters), in: nil)
            }

            if stylisticSpacing {
                line.scalars.advance(&index, over: RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces }), count: 0 ... 1))
            }

            var result = String(line.scalars.suffix(from: index))
            if let end = stylisticEnd {
                if result.hasSuffix(end) {
                    result = String(result[..<result.index(result.endIndex, offsetBy: −end.clusters.count)])
                }
            }
            return result
        }
        return lines.joinAsLines()
    }

    func firstComment(in string: String) -> String? {
        return firstComment(in: string.startIndex ..< string.endIndex, of: string)
    }

    func contentsOfFirstComment(in string: String) -> String? {
        return contentsOfFirstComment(in: string.startIndex ..< string.endIndex, of: string)
    }
}
