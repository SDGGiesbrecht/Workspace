/*
 DocumentationInheritance.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports
import WSProject

struct DocumentationInheritance {
    static let documentation: [String: String] = {

        requireBash(["swift", "package", "resolve"], silent: false)

        var list: [String: String] = [:]

        for url in (try? Repository.packageRepository.allFiles()) ?? []
            where (url.is(in: Repository.packageRepository.location.appendingPathComponent("Packages"))
                ∨ url.is(in: Repository.packageRepository.location.appendingPathComponent(".build/checkouts")))
                ∧ ¬(url.path.contains(".git") ∨ ¬url.path.contains("/docs/")) {

                    autoreleasepool {

                        if FileType(url: url) == .swift {
                            let file = require { try TextFile(alreadyAt: url) }

                            let startTokens = ("[\u{5F}Define Documentation", "_]")

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

                                let nextLineStart = file.contents.lineRange(for: startTokenRange).upperBound
                                if let comment = FileType.swiftDocumentationSyntax.contentsOfFirstComment(in: nextLineStart ..< file.contents.endIndex, of: file) {
                                    list[identifier] = comment
                                }
                            }
                        }
                    }
        }

        return list
    }()

    static func refreshDocumentation(output: Command.Output) throws {

        for url in try Repository.packageRepository.sourceFiles(output: output) {
            try autoreleasepool {

                if FileType(url: url) == .swift {
                    let documentationSyntax = FileType.swiftDocumentationSyntax
                    guard let lineDocumentationSyntax = documentationSyntax.lineCommentSyntax else {
                        unreachable()
                    }

                    var file = require { try TextFile(alreadyAt: url) }

                    var index = file.contents.startIndex
                    while let range = file.contents.scalars.firstMatch(for: "[\u{5F}Inherit Documentation".scalars, in: (index ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.range.clusters(in: file.contents.clusters) {
                        index = range.upperBound

                        func syntaxError() -> Never {
                            fatalError(message: [
                                "Syntax error in example:",
                                "",
                                String(file.contents[file.contents.lineRange(for: range)])
                                ])
                        }

                        guard let detailsSubSequence = file.contents.scalars.firstNestingLevel(startingWith: "[\u{5F}Inherit Documentation".scalars, endingWith: "_]".scalars, in: (range.lowerBound ..< file.contents.endIndex).sameRange(in: file.contents.scalars))?.contents.contents else {
                            syntaxError()
                        }
                        let details = String(detailsSubSequence)
                        guard let colon = details.range(of: ": ") else {
                            syntaxError()
                        }
                        let documentationIdentifier = String(details[colon.upperBound...])
                        guard let replacement = documentation[documentationIdentifier] else {
                            fatalError(message: [
                                "There are is no documenation named “\(documentationIdentifier)”."
                                ])
                        }

                        let nextLineStart = file.contents.lineRange(for: range).upperBound
                        let nextLine = file.contents.lineRange(for: nextLineStart ..< file.contents.index(after: nextLineStart))
                        if let commentRange = documentationSyntax.rangeOfFirstComment(in: nextLineStart ..< file.contents.endIndex, of: file),
                            nextLine.contains(commentRange.lowerBound) {

                            let indent = String(file.contents[nextLineStart ..< commentRange.lowerBound])

                            file.contents.replaceSubrange(commentRange, with: lineDocumentationSyntax.comment(contents: replacement, indent: indent))
                        } else {
                            var location: String.ScalarView.Index = nextLineStart.samePosition(in: file.contents.scalars)
                            file.contents.scalars.advance(&location, over: RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces })))

                            let indent = String(file.contents[nextLineStart ..< location.cluster(in: file.contents.clusters)])

                            let result = lineDocumentationSyntax.comment(contents: replacement, indent: indent) + "\n" + indent

                            file.contents.scalars.replaceSubrange(location ..< location, with: result.scalars)
                        }
                    }

                    try file.writeChanges(for: Repository.packageRepository, output: output)
                }
            }
        }
    }
}
