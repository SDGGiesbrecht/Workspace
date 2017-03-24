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

import SDGLogic

struct DocumentationInheritance {
    static let documentation: [String: String] = {

        var list: [String: String] = [:]

        for path in Repository.allFiles(at: RelativePath("Packages")) + Repository.sourceFiles {
            if FileType(filePath: path) == .swift {
                let file = require() { try File(at: path) }

                let startTokens = ("[_Define Documentation", "_]")

                var index = file.contents.startIndex
                while let startTokenRange = file.contents.range(of: startTokens, in: index ..< file.contents.endIndex) {
                    index = startTokenRange.upperBound

                    guard var identifier = file.contents.contents(of: startTokens, in: startTokenRange) else {
                        failTests(message: [
                            "Failed to parse “\(file.contents.substring(with: startTokenRange))”.",
                            "This may indicate a bug in Workspace."
                            ])
                    }

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
                while let range = file.contents.range(of: "[\u{5F}Inherit Documentation", in: index ..< file.contents.endIndex) {
                    index = range.upperBound

                    func syntaxError() -> Never {
                        fatalError(message: [
                            "Syntax error in example:",
                            "",
                            file.contents.substring(with: file.contents.lineRange(for: range))
                            ])
                    }

                    guard let details = file.contents.contents(of: ("[\u{5F}Inherit Documentation", "_]"), in: range.lowerBound ..< file.contents.endIndex) else {
                        syntaxError()
                    }
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
                    let commentRange = documentationSyntax.requireRangeOfFirstComment(in: nextLineStart ..< file.contents.endIndex, of: file)
                    let indent = file.contents.substring(with: nextLineStart ..< commentRange.lowerBound)

                    file.contents.replaceSubrange(commentRange, with: lineDocumentationSyntax.comment(contents: replacement, indent: indent))
                }

                require() { try file.write() }
            }
        }
    }
}
