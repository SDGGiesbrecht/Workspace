/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

import WSProject

extension PackageRepository {
    // [_Warning: Document new syntax._]
    // [_Warning: Write proofreader to catch deprectaed syntax._]

    private static let exampleAttribute: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "example"
        }
    })

    private static let endAttribute: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "endExample"
        }
    })

    private static let exampleDirective: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "example"
        }
    })

    private static var exampleDeclarationPatterns: [CompositePattern<Unicode.Scalar>] {
        return InterfaceLocalization.cases.map { localization in
            return CompositePattern<Unicode.Scalar>([
                LiteralPattern("@".scalars),
                LiteralPattern(exampleAttribute.resolved(for: localization)),
                LiteralPattern("(".scalars),
                RepetitionPattern(ConditionalPattern({ $0 ≠ ")" })),
                LiteralPattern(")".scalars),

                RepetitionPattern(ConditionalPattern({ _ in true })),

                LiteralPattern("@".scalars),
                LiteralPattern(endAttribute.resolved(for: localization))
                ])
        }
    }

    private static var exampleUsePatterns: [CompositePattern<Unicode.Scalar>] {
        return InterfaceLocalization.cases.map { localization in
            return CompositePattern<Unicode.Scalar>([
                LiteralPattern("#".scalars),
                LiteralPattern(exampleDirective.resolved(for: localization)),
                LiteralPattern("(".scalars),
                RepetitionPattern(ConditionalPattern({ $0 ≠ "," })),
                LiteralPattern(",".scalars),
                RepetitionPattern(ConditionalPattern({ $0 ≠ ")" })),
                LiteralPattern(")".scalars)
                ])
        }
    }

    public func examples(output: Command.Output) throws -> [StrictString: StrictString] {
        return try _withExampleCache {
            var list: [StrictString: StrictString] = [:]

            for url in try sourceFiles(output: output) {
                autoreleasepool {

                    if FileType(url: url) ≠ nil,
                        let file = try? TextFile(alreadyAt: url) {

                        for match in file.contents.scalars.matches(for: AlternativePatterns(PackageRepository.exampleDeclarationPatterns)) {
                            guard let openingParenthesis = match.contents.firstMatch(for: "(".scalars),
                                let closingParenthesis = match.contents.firstMatch(for: ")".scalars),
                                let at = match.contents.lastMatch(for: "@".scalars) else {
                                    unreachable()
                            }

                            var identifier = StrictString(file.contents.scalars[openingParenthesis.range.upperBound ..< closingParenthesis.range.lowerBound])
                            identifier.trimMarginalWhitespace()

                            var example = StrictString(file.contents.scalars[closingParenthesis.range.upperBound ..< at.range.lowerBound])
                            example.lines.removeFirst()
                            example.lines.removeLast()
                            example = example.strippingCommonIndentation()

                            list[identifier] = example
                        }
                    }
                }
            }

            return list
        }
    }

    public func refreshExamples(output: Command.Output) throws {

        for url in try sourceFiles(output: output) {
            try autoreleasepool {

                if FileType(url: url) == .swift {
                    let documentationSyntax = FileType.swiftDocumentationSyntax
                    let lineDocumentationSyntax = documentationSyntax.lineCommentSyntax!

                    var file = try TextFile(alreadyAt: url)

                    for match in file.contents.scalars.matches(for: AlternativePatterns(PackageRepository.exampleUsePatterns)) {
                        guard let openingParenthesis = match.contents.firstMatch(for: "(".scalars),
                            let comma = match.contents.firstMatch(for: ",".scalars),
                            let closingParenthesis = match.contents.firstMatch(for: ")".scalars) else {
                                unreachable()
                        }

                        var indexString = StrictString(file.contents.scalars[openingParenthesis.range.upperBound ..< comma.range.lowerBound])
                        indexString.trimMarginalWhitespace()

                        var identifier = StrictString(file.contents.scalars[comma.range.upperBound ..< closingParenthesis.range.lowerBound])
                        identifier.trimMarginalWhitespace()

                        let index = try Int(possibleDecimal: indexString)
                        guard let example = try examples(output: output)[identifier] else {
                            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                                switch localization {
                                case .englishCanada:
                                    return "There is no example named “" + identifier + "”."
                                }
                            }))
                        }

                        let nextLineStart = match.range.lines(in: file.contents.lines).upperBound.samePosition(in: file.contents.scalars)
                        if let commentRange = documentationSyntax.rangeOfFirstComment(in: nextLineStart ..< file.contents.scalars.endIndex, of: file) {
                            let commentIndent = String(file.contents.scalars[nextLineStart ..< commentRange.lowerBound])

                            if var commentValue = documentationSyntax.contentsOfFirstComment(in: commentRange, of: file) {

                                var countingExampleIndex = 0
                                var searchIndex = commentValue.scalars.startIndex
                                exampleSearch: while let startRange = commentValue.scalars.firstMatch(for: "```".scalars, in: searchIndex ..< commentValue.scalars.endIndex)?.range,
                                    let endRange = commentValue.scalars.firstMatch(for: "```".scalars, in: startRange.upperBound ..< commentValue.scalars.endIndex)?.range {

                                        let exampleRange = startRange.lowerBound ..< endRange.upperBound

                                        searchIndex = exampleRange.upperBound
                                        countingExampleIndex.increment()
                                        if countingExampleIndex < index {
                                            continue exampleSearch
                                        } else if countingExampleIndex == index {

                                            let lineStart = exampleRange.lowerBound.line(in: commentValue.lines).samePosition(in: commentValue.scalars)
                                            let indentCount = commentValue.scalars.distance(from: lineStart, to: exampleRange.lowerBound)
                                            let exampleIndent = StrictString(Array(repeating: " ", count: indentCount))

                                            var exampleLines = [
                                                "```swift",
                                                example,
                                                "```"
                                                ].joinedAsLines().lines.map({ StrictString($0.line) })

                                            for index in exampleLines.startIndex ..< exampleLines.endIndex where index ≠ exampleLines.startIndex {
                                                exampleLines[index] = exampleIndent + exampleLines[index]
                                            }

                                            commentValue.scalars.replaceSubrange(exampleRange, with: exampleLines.joinedAsLines())

                                            let replacementComment = lineDocumentationSyntax.comment(contents: commentValue, indent: commentIndent)
                                            file.contents.scalars.replaceSubrange(commentRange, with: replacementComment.scalars)

                                            break exampleSearch
                                        }
                                }
                            }
                        }
                    }

                    try file.writeChanges(for: self, output: output)
                }
            }
        }
    }
}
