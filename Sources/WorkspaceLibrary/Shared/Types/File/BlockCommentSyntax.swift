/*
 BlockCommentSyntax.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

func join(lines: [String]) -> String {
    return lines.joined(separator: "\n")
}

struct BlockCommentSyntax {

    // MARK: - Initialization

    init(start: String, end: String, stylisticIndent: String? = nil) {
        self.start = start
        self.end = end
        self.stylisticIndent = stylisticIndent
    }

    // MARK: - Properties

    let start: String
    let end: String
    let stylisticIndent: String?

    // MARK: - Output

    func comment(contents: [String]) -> String {
        return comment(contents: join(lines: contents))
    }

    func comment(contents: String) -> String {

        let withEndToken = join(lines: [contents, end])

        var lines = withEndToken.lines.map({ String($0.line) })

        lines = lines.map() { (line: String) -> String in

            if let indent = stylisticIndent {
                if line.isWhitespace {
                    return line
                } else {
                    return indent + line
                }
            } else {
                return line
            }
        }

        lines = [start, join(lines: lines)]

        return join(lines: lines)
    }

    // MARK: - Parsing

    func startOfCommentExists(at location: String.Index, in string: String, countDocumentationMarkup: Bool = true) -> Bool {

        var index = location
        if ¬string.clusters.advance(&index, over: start.clusters) {
            return false
        } else {
            // Block comment

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

    func rangeOfFirstComment(in range: Range<String.Index>, of string: String) -> Range<String.Index>? {
        return string.scalars.firstNestingLevel(startingWith: start.scalars, endingWith: end.scalars, in: range.sameRange(in: string.scalars))?.container.range.clusters(in: string.clusters)
    }

    func requireRangeOfFirstComment(in range: Range<String.Index>, of file: File) -> Range<String.Index> {

        return file.requireRange(of: (start, end), in: range)
    }

    private func rangeOfContentsOfFirstComment(in range: Range<String.Index>, of string: String) -> Range<String.Index>? {
        return string.scalars.firstNestingLevel(startingWith: start.scalars, endingWith: end.scalars, in: range.sameRange(in: string.scalars))?.contents.range.clusters(in: string.clusters)
    }

    func firstComment(in range: Range<String.Index>, of string: String) -> String? {
        if let range = rangeOfFirstComment(in: range, of: string) {
            return string.substring(with: range)
        } else {
            return nil
        }
    }

    func contentsOfFirstComment(in range: Range<String.Index>, of string: String) -> String? {
        guard let range = rangeOfContentsOfFirstComment(in: range, of: string) else {
            return nil

        }

        var lines = string.substring(with: range).lines.map({ String($0.line) })
        while let line = lines.first, line.isWhitespace {
            lines.removeFirst()
        }

        guard let first = lines.first else {
            return ""
        }
        lines.removeFirst()

        var index = first.scalars.startIndex
        first.scalars.advance(&index, over: RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.whitespaces })))
        let indent = first.scalars.distance(from: first.scalars.startIndex, to: index)

        var result = [first.scalars.suffix(from: index)]
        for line in lines {
            var indentIndex = line.scalars.startIndex
            line.scalars.advance(&indentIndex, over: RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.whitespaces }), count: 0 ... indent))
            result.append(line.scalars.suffix(from: indentIndex))
        }

        var strings = result.map({ String($0) })
        while let last = strings.last, last.isWhitespace {
            strings.removeLast()
        }

        return join(lines: strings)
    }

    func firstComment(in string: String) -> String? {
        return firstComment(in: string.startIndex ..< string.endIndex, of: string)
    }

    func contentsOfFirstComment(in string: String) -> String? {
        return contentsOfFirstComment(in: string.startIndex ..< string.endIndex, of: string)
    }
}
