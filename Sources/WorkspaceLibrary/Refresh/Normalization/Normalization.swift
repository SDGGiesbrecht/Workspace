/*
 Normalization.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

func normalizeFiles() {

    for path in Repository.sourceFiles {

        if let syntax = FileType(filePath: path)?.syntax {

            var file = require() { try File(at: path) }

            let lines = file.contents.linesArray
            let normalizedLines = lines.map() { (line: String) -> String in

                var normalized = line.decomposedStringWithCanonicalMapping

                var semanticWhitespace = ""
                for whitespace in syntax.semanticLineTerminalWhitespace {
                    if normalized.hasSuffix(whitespace) {
                        semanticWhitespace = whitespace
                    }
                }

                while let last = normalized.unicodeScalars.last, CharacterSet.whitespaces.contains(last) {
                    normalized.unicodeScalars.removeLast()
                }

                return normalized + semanticWhitespace
            }
            file.contents = join(lines: normalizedLines)

            require() { try file.write() }
        }
    }
}
