/*
 Examples.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

struct Examples {
    static let examples: [String: String] = {

        var list: [String: String] = [:]

        for path in Repository.sourceFiles {
            let file = require() { try File(at: path) }

            if let _ = file.fileType {

                let startTokens = ("[_Define Example", "_]")

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

                    guard let end = file.contents.range(of: "[_End_]", in: startTokenRange.lowerBound ..< file.contents.endIndex) else {
                        failTests(message: [
                            "Failed to find the end of “\(file.contents.substring(with: startTokenRange))”.",
                            "This may indicate a bug in Workspace."
                            ])
                    }

                    let startLineRange = file.contents.lineRange(for: startTokenRange)
                    let endLineRange = file.contents.lineRange(for: end)

                    var contents = file.contents.substring(with: startLineRange.upperBound ..< endLineRange.lowerBound).linesArray
                    while contents.first?.isWhitespace ?? false {
                        contents.removeFirst()
                    }
                    while contents.last?.isWhitespace ?? false {
                        contents.removeLast()
                    }

                    var indentEnd = startLineRange.lowerBound
                    file.contents.advance(&indentEnd, past: CharacterSet.whitespaces)
                    let indent = file.contents.substring(with: startLineRange.lowerBound ..< indentEnd)

                    contents = contents.map() { (line: String) -> String in
                        var index = line.startIndex
                        if line.advance(&index, past: indent) {
                            return line.substring(from: index)
                        } else {
                            return line
                        }
                    }

                    list[identifier] = join(lines: contents)
                }
            }
        }

        return list
    }()
}
