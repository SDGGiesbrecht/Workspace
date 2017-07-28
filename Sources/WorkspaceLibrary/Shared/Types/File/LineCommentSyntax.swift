/*
 LineCommentSyntax.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

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

        return join(lines: result)
    }

    // MARK: - Parsing

    func commentExists(at location: String.Index, in string: String, countDocumentationMarkup: Bool = true) -> Bool {

        var index = location
        if ¬string.advance(&index, past: start) {
            return false
        } else {
            // Comment

            if countDocumentationMarkup {
                return true
            } else {
                // Make shure this isn’t documentation.

                if let nextCharacter = string.substring(from: index).unicodeScalars.first {

                    if nextCharacter ∈ CharacterSet.whitespacesAndNewlines {
                        return true
                    }
                }
                return false
            }
        }
    }

    private func restOfLine(at index: String.Index, in range: Range<String.Index>, of string: String) -> Range<String.Index> {

        if let newline = string.range(of: CharacterSet.newlines, in: index ..< range.upperBound) {

            return index ..< newline.lowerBound
        } else {
            return index ..< range.upperBound
        }
    }

    func rangeOfFirstComment(in range: Range<String.Index>, of string: String) -> Range<String.Index>? {

        guard let startRange = string.range(of: start, in: range) else {
            return nil
        }

        var resultEnd = restOfLine(at: startRange.lowerBound, in: range, of: string).upperBound
        var testIndex = resultEnd
        string.advance(&testIndex, pastNewlinesWithLimit: 1)
        string.advance(&testIndex, past: CharacterSet.whitespaces)

        while string.substring(from: testIndex).hasPrefix(start) {
            resultEnd = restOfLine(at: testIndex, in: range, of: string).upperBound
            testIndex = resultEnd
            string.advance(&testIndex, pastNewlinesWithLimit: 1)
            string.advance(&testIndex, past: CharacterSet.whitespaces)
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
            return string.substring(with: range)
        } else {
            return nil
        }
    }

    func contentsOfFirstComment(in range: Range<String.Index>, of string: String) -> String? {
        guard let range = rangeOfFirstComment(in: range, of: string) else {
            return nil

        }

        let comment = string.substring(with: range)
        let lines = comment.lines.map({ String($0.line) }).map() { (line: String) -> String in

            var index = line.startIndex

            line.advance(&index, past: CharacterSet.whitespaces)
            guard line.advance(&index, past: start) else {
                line.parseError(at: index, in: nil)
            }

            if stylisticSpacing {
                line.advance(&index, past: CharacterSet.whitespaces, limit: 1)
            }

            var result = line.substring(from: index)
            if let end = stylisticEnd {
                if result.hasSuffix(end) {
                    result = result.substring(to: result.index(result.endIndex, offsetBy: −end.characters.count))
                }
            }
            return result
        }
        return join(lines: lines)
    }

    func firstComment(in string: String) -> String? {
        return firstComment(in: string.startIndex ..< string.endIndex, of: string)
    }

    func contentsOfFirstComment(in string: String) -> String? {
        return contentsOfFirstComment(in: string.startIndex ..< string.endIndex, of: string)
    }
}
