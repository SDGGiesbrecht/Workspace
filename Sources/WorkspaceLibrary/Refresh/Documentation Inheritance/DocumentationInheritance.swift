/*
 DocumentationInheritance.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

struct DocumentationInheritance {
    static let documentation: [String: String] = {

        requireBash(["swift", "package", "fetch"], silent: false)

        var list: [String: String] = [:]

        for path in (Repository.allFiles(at: RelativePath("Packages")) + Repository.allFiles(at: RelativePath(".build/checkouts"))).filter({
        ¬$0.string.contains(".git") ∧ ¬$0.string.contains("/docs/") }) + Repository.sourceFiles {
            if FileType(filePath: path) == .swift {
                let file = require() { try File(at: path) }

                let startTokens = ("[\u{5F}Define Documentation", "_]")

                var index = file.contents.startIndex
                while let startTokenRange = file.contents.scalars.firstNestingLevel(startingWith: startTokens.0.scalars, endingWith: startTokens.1.scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.container.range.clusters(in: file.contents.clusters) {
                    index = startTokenRange.upperBound

                    guard let identifierSubsequence = file.contents.scalars.firstNestingLevel(startingWith: startTokens.0.scalars, endingWith: startTokens.1.scalars, in: startTokenRange.sameRange(in: file.contents.scalars))?.contents.contents else {
                        failTests(message: [
                            "Failed to parse “\(file.contents.substring(with: startTokenRange))”.",
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

                    let nextLineStart = file.contents.lineRange(for: startTokenRange).upperBound
                    let comment = FileType.swiftDocumentationSyntax.requireContentsOfFirstComment(in: nextLineStart ..< file.contents.endIndex, of: file)

                    list[identifier] = comment
                }
            }
        }

        return list
    }()

    static func refreshDocumentation() {

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
                while let range = file.contents.scalars.firstMatch(for: "[\u{5F}Inherit Documentation".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
                    index = range.upperBound

                    func syntaxError() -> Never {
                        fatalError(message: [
                            "Syntax error in example:",
                            "",
                            file.contents.substring(with: file.contents.lineRange(for: range))
                            ])
                    }

                    guard let detailsSubSequence = file.contents.scalars.firstNestingLevel(startingWith: "[\u{5F}Inherit Documentation".scalars, endingWith: "_]".scalars, in: (range.lowerBound ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.contents.contents else {
                        syntaxError()
                    }
                    let details = String(detailsSubSequence)
                    guard let colon = details.range(of: ": ") else {
                        syntaxError()
                    }
                    let documentationIdentifier = details.substring(from: colon.upperBound)
                    guard let replacement = documentation[documentationIdentifier] else {
                        fatalError(message: [
                            "There are is no documenation named “\(documentationIdentifier)”."
                            ])
                    }

                    let nextLineStart = file.contents.lineRange(for: range).upperBound
                    let nextLine = file.contents.lineRange(for: nextLineStart ..< file.contents.index(after: nextLineStart))
                    if let commentRange = documentationSyntax.rangeOfFirstComment(in: nextLineStart ..< file.contents.endIndex, of: file),
                        nextLine.contains(commentRange.lowerBound) {

                        let indent = file.contents.substring(with: nextLineStart ..< commentRange.lowerBound)

                        file.contents.replaceSubrange(commentRange, with: lineDocumentationSyntax.comment(contents: replacement, indent: indent))
                    } else {
                        var location = nextLineStart
                        file.contents.advance(&location, past: CharacterSet.whitespaces)

                        let indent = file.contents.substring(with: nextLineStart ..< location)

                        let result = lineDocumentationSyntax.comment(contents: replacement, indent: indent) + "\n" + indent

                        file.contents.replaceSubrange(location ..< location, with: result)
                    }
                }

                require() { try file.write() }
            }
        }
    }
}
