/*
 Examples.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

struct Examples {
    static let examples: [String: String] = {

        var list: [String: String] = [:]

        for path in Repository.sourceFiles {
            if let file = try? File(at: path) {

                if file.fileType ≠ nil {

                    let startTokens = ("[_Define Example", "_]")

                    var index = file.contents.startIndex
                    while let startTokenRange = file.contents.scalars.firstNestingLevel(startingWith: startTokens.0.scalars, endingWith: startTokens.1.scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.container.range.clusters(in: file.contents.clusters) {
                        index = startTokenRange.upperBound

                        guard let identifierSubsequence = file.contents.scalars.firstNestingLevel(startingWith: startTokens.0.scalars, endingWith: startTokens.1.scalars, in: startTokenRange.sameRange(in: file.contents.scalars))?.contents.contents else {
                            failTests(message: [
                                "Failed to parse “\(String(file.contents[startTokenRange]))”.",
                                "This may indicate a bug in Workspace."
                                ])
                        }
                        var identifier = String(identifierSubsequence)

                        if identifier.hasPrefix(":") {
                            identifier.unicodeScalars.removeFirst()
                        }
                        if identifier.hasPrefix(" ") {
                            identifier.unicodeScalars.removeFirst()
                        }

                        guard let end = file.contents.scalars.firstMatch(for: "[_End_]".scalars, in: (startTokenRange.lowerBound ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) else {
                            failTests(message: [
                                "Failed to find the end of “\(String(file.contents[startTokenRange]))”.",
                                "This may indicate a bug in Workspace."
                                ])
                        }

                        let startLineRange = file.contents.lineRange(for: startTokenRange)
                        let endLineRange = file.contents.lineRange(for: end)

                        if startLineRange ≠ endLineRange {

                            var contents = String(file.contents[startLineRange.upperBound ..< endLineRange.lowerBound]).lines.map({ String($0.line) })
                            while contents.first?.isWhitespace ?? false {
                                contents.removeFirst()
                            }
                            while contents.last?.isWhitespace ?? false {
                                contents.removeLast()
                            }

                            var indentEnd: String.ScalarView.Index = startLineRange.lowerBound.samePosition(in: file.contents.scalars)
                            file.contents.scalars.advance(&indentEnd, over: RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.whitespaces })))
                            let indent = String(file.contents[startLineRange.lowerBound ..< indentEnd.cluster(in: file.contents.clusters)])

                            contents = contents.map() { (line: String) -> String in
                                var index = line.startIndex
                                if line.clusters.advance(&index, over: indent.clusters) {
                                    return String(line[index...])
                                } else {
                                    return line
                                }
                            }

                            list[identifier] = join(lines: contents)
                        }
                    }
                }
            }
        }

        return list
    }()

    static func refreshExamples(output: inout Command.Output) {

        for path in Repository.sourceFiles {

            if FileType(filePath: path) == .swift {
                let documentationSyntax = FileType.swiftDocumentationSyntax
                guard let lineDocumentationSyntax = documentationSyntax.lineCommentSyntax else {
                    fatalError(message: [
                        "Line documentation syntax missing.",
                        "This may indicate a bug in Workspace."
                        ])
                }

                var file = require() { try File(at: path) }

                var index = file.contents.startIndex
                while let range = file.contents.scalars.firstMatch(for: "[\u{5F}Example".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
                    index = range.upperBound

                    func syntaxError() -> Never {
                        fatalError(message: [
                            "Syntax error in example:",
                            "",
                            String(file.contents[file.contents.lineRange(for: range)])
                            ])
                    }

                    guard let detailsSubsequence = file.contents.scalars.firstNestingLevel(startingWith: "[\u{5F}Example ".scalars, endingWith: "_]".scalars, in: (range.lowerBound ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.contents.contents else {
                        syntaxError()
                    }
                    let details = String(detailsSubsequence)
                    guard let colon = details.range(of: ": ") else {
                        syntaxError()
                    }
                    guard let exampleIndex = Int(String(details[..<colon.lowerBound])) else {
                        syntaxError()
                    }
                    let exampleName = String(details[colon.upperBound...])
                    guard let example = examples[exampleName] else {
                        fatalError(message: [
                            "There are no examples named “\(exampleName)”."
                            ])
                    }

                    let nextLineStart = file.contents.lineRange(for: range).upperBound
                    let commentRange = documentationSyntax.requireRangeOfFirstComment(in: nextLineStart ..< file.contents.endIndex, of: file)
                    let indent = String(file.contents[nextLineStart ..< commentRange.lowerBound])

                    var commentValue = documentationSyntax.requireContentsOfFirstComment(in: commentRange, of: file)

                    var countingExampleIndex = 0
                    var searchIndex = commentValue.startIndex
                    exampleSearch: while let startRange = commentValue.scalars.firstMatch(for: "```".scalars, in: (searchIndex ..< commentValue.endIndex).sameRange(in: commentValue.scalars))?.range.clusters(in: commentValue.clusters), let endRange = commentValue.scalars.firstMatch(for: "```".scalars, in: (startRange.upperBound ..< commentValue.endIndex).sameRange(in: commentValue.scalars))?.range.clusters(in: commentValue.clusters) {
                        let exampleRange = startRange.lowerBound ..< endRange.upperBound

                        searchIndex = exampleRange.upperBound
                        countingExampleIndex += 1

                        let startLine = commentValue.lineRange(for: exampleRange.lowerBound ..< exampleRange.lowerBound)
                        let internalIndent = String(commentValue[startLine.lowerBound ..< exampleRange.lowerBound])

                        var exampleLines = join(lines: [
                            "```swift",
                            example,
                            "```"
                            ]).lines.map({ String($0.line) })

                        for index in exampleLines.startIndex ..< exampleLines.endIndex where index ≠ exampleLines.startIndex {
                            exampleLines[index] = internalIndent + exampleLines[index]
                        }

                        if countingExampleIndex == exampleIndex {
                            commentValue.replaceSubrange(exampleRange, with: join(lines: exampleLines))

                            file.contents.replaceSubrange(commentRange, with: lineDocumentationSyntax.comment(contents: commentValue, indent: indent))

                            break exampleSearch
                        }
                    }
                }

                require() { try file.write(output: &output) }
            }
        }
    }
}
