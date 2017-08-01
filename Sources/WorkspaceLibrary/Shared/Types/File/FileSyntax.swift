/*
 FileSyntax.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

struct FileSyntax {

    // MARK: - Initialization

    init(blockCommentSyntax: BlockCommentSyntax? = nil, lineCommentSyntax: LineCommentSyntax? = nil, requiredFirstLineToken: String? = nil, semanticLineTerminalWhitespace: [String] = []) {
        self.blockCommentSyntax = blockCommentSyntax
        self.lineCommentSyntax = lineCommentSyntax
        self.requiredFirstLineToken = requiredFirstLineToken
        self.semanticLineTerminalWhitespace = semanticLineTerminalWhitespace
    }

    // MARK: - Properties

    let requiredFirstLineToken: String?

    let blockCommentSyntax: BlockCommentSyntax?
    let lineCommentSyntax: LineCommentSyntax?

    let semanticLineTerminalWhitespace: [String]

    // MARK: - Output

    func comment(contents: [String]) -> String {
        return comment(contents: join(lines: contents))
    }

    func comment(contents: String) -> String {
        if let blockSyntax = blockCommentSyntax {
            return blockSyntax.comment(contents: contents)
        } else if let lineSyntax = lineCommentSyntax {
            return lineSyntax.comment(contents: contents)
        } else {
            fatalError(message: ["No comment syntax available."])
        }
    }

    func generateHeader(contents: [String]) -> String {
        return comment(contents: contents)
    }

    func generateHeader(contents: String) -> String {
        return comment(contents: contents)
    }

    func insert(header: String, into file: inout File) {

        var first = file.contents.substring(to: file.headerStart)
        if ¬first.isEmpty {
            var firstLines = first.lines.map({ String($0.line) })
            while let last = firstLines.last, last.isWhitespace {
                firstLines.removeLast()
            }
            firstLines.append("")
            firstLines.append("") // Header starts in this line.
            first = join(lines: firstLines)
        }

        var body = file.contents.substring(from: file.headerEnd)
        while let firstCharacter = body.unicodeScalars.first, firstCharacter ∈ CharacterSet.whitespacesAndNewlines {
            body.unicodeScalars.removeFirst()
        }
        body = join(lines: [
            "", // Line at end of header
            "",
            "" // Body starts in this line
            ]) + body

        let contents = first + generateHeader(contents: header) + body

        file.contents = contents
    }

    // MARK: - Parsing

    func rangeOfFirstComment(in range: Range<String.Index>, of file: File) -> Range<String.Index>? {
        let possibleBlock = blockCommentSyntax?.rangeOfFirstComment(in: range, of: file.contents)
        let possibleLine = lineCommentSyntax?.rangeOfFirstComment(in: range, of: file.contents)

        if let block = possibleBlock {
            if let line = possibleLine {
                if block.lowerBound < line.lowerBound {
                    return block
                } else {
                    return line
                }
            } else {
                return block
            }
        } else {
            if let line = possibleLine {
                return line
            } else {
                return nil

            }
        }
    }

    func requireRangeOfFirstComment(in range: Range<String.Index>, of file: File) -> Range<String.Index> {
        if let result = rangeOfFirstComment(in: range, of: file) {
            return result
        } else {
            fatalError(message: [
                "No comments in...",
                file.path.string,
                "...in \(range)",
                "This may indicate a bug in Workspace."
                ])
        }
    }

    func requireContentsOfFirstComment(in range: Range<String.Index>, of file: File) -> String {
        if let block = blockCommentSyntax?.contentsOfFirstComment(in: range, of: file.contents) {
            return block
        } else if let line = lineCommentSyntax?.contentsOfFirstComment(in: range, of: file.contents) {
            return line
        } else {
            fatalError(message: [
                "No comments in...",
                file.path.string,
                "...in \(range)",
                "This may indicate a bug in Workspace."
                ])
        }
    }

    private static func advance(_ index: inout String.Index, pastLayoutSpacingIn string: String) {
        var scalar = index.samePosition(in: string.scalars)

        let newline = AlternativePatterns([
            LiteralPattern("\u{D}\u{A}".scalars),
            ConditionalPattern(condition: { $0 ∈ CharacterSet.newlines })
            ])

        string.scalars.advance(&scalar, over: RepetitionPattern(newline, count: 0 ... 1))
        string.scalars.advance(&scalar, over: RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.whitespaces })))
        string.scalars.advance(&scalar, over: RepetitionPattern(newline, count: 0 ... 1))

        index = scalar.cluster(in: string.clusters)
    }

    func headerStart(file: File) -> String.Index {

        var index = file.contents.startIndex

        if let required = requiredFirstLineToken {

            if file.contents.hasPrefix(required),
                let endOfLine = file.contents.range(of: "\n") {
                index = endOfLine.lowerBound
            }
            FileSyntax.advance(&index, pastLayoutSpacingIn: file.contents)
        }

        return index
    }

    private func headerEndWithoutSpacing(file: File) -> String.Index {

        let start = file.headerStart

        if let blockSyntax = blockCommentSyntax {

            if blockSyntax.startOfCommentExists(at: start, in: file.contents, countDocumentationMarkup: false) {

                return blockSyntax.requireRangeOfFirstComment(in: start ..< file.contents.endIndex, of: file).upperBound
            }
        }

        if let lineSyntax = lineCommentSyntax {

            if lineSyntax.commentExists(at: start, in: file.contents, countDocumentationMarkup: false) {

                return lineSyntax.requireRangeOfFirstComment(in: start ..< file.contents.endIndex, of: file).upperBound
            }
        }

        return start
    }

    func headerEnd(file: File) -> String.Index {
        var result = headerEndWithoutSpacing(file: file)
        FileSyntax.advance(&result, pastLayoutSpacingIn: file.contents)
        return result
    }

    func header(file: File) -> String {
        let markup = file.contents.substring(with: file.headerStart ..< file.headerEnd)

        if markup.lines.map({ String($0.line) }).filter({ ¬$0.isWhitespace }).isEmpty {
            return markup
        }

        if let blockSyntax = blockCommentSyntax {
            if let result = blockSyntax.contentsOfFirstComment(in: markup) {
                return result
            }
        }
        if let lineSyntax = lineCommentSyntax {
            if let result = lineSyntax.contentsOfFirstComment(in: markup) {
                return result
            }
        }

        fatalError(message: [
            "Malformed header in \(file.path.filename):",
            "",
            "",
            markup,
            "",
            "",
            "This may indicate a bug in Workspace."
            ])
    }
}
