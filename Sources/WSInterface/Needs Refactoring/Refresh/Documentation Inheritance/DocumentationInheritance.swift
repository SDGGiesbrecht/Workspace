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
import WSDocumentation

struct DocumentationInheritance {


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
                        guard let replacement = try Repository.packageRepository.documentationDefinitions(output: output)[StrictString(documentationIdentifier)] else {
                            fatalError(message: [
                                "There is no documenation named “\(documentationIdentifier)”."
                                ])
                        }

                        let nextLineStart = file.contents.lineRange(for: range).upperBound
                        let nextLine = file.contents.lineRange(for: nextLineStart ..< file.contents.index(after: nextLineStart))
                        if let commentRange = documentationSyntax.rangeOfFirstComment(in: nextLineStart ..< file.contents.endIndex, of: file),
                            nextLine.contains(commentRange.lowerBound) {

                            let indent = String(file.contents[nextLineStart ..< commentRange.lowerBound])

                            file.contents.replaceSubrange(commentRange, with: lineDocumentationSyntax.comment(contents: String(replacement), indent: indent))
                        } else {
                            var location: String.ScalarView.Index = nextLineStart.samePosition(in: file.contents.scalars)
                            file.contents.scalars.advance(&location, over: RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces })))

                            let indent = String(file.contents[nextLineStart ..< location.cluster(in: file.contents.clusters)])

                            let result = lineDocumentationSyntax.comment(contents: String(replacement), indent: indent) + "\n" + indent

                            file.contents.scalars.replaceSubrange(location ..< location, with: result.scalars)
                        }
                    }

                    try file.writeChanges(for: Repository.packageRepository, output: output)
                }
            }
        }
    }
}
