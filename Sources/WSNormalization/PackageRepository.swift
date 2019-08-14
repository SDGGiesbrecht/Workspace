/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import WSGeneralImports
import WSProject

extension PackageRepository {

    public func normalize(output: Command.Output) throws {

        for url in try sourceFiles(output: output) {
            try autoreleasepool {

                if let syntax = FileType(url: url)?.syntax {
                    var file = try TextFile(alreadyAt: url)

                    let lines = file.contents.lines.map({ String($0.line) })
                    let normalizedLines = lines.map { (line: String) -> String in

                        var normalized = line.decomposedStringWithCanonicalMapping

                        var semanticWhitespace = ""
                        for whitespace in syntax.semanticLineTerminalWhitespace {
                            if normalized.hasSuffix(whitespace) {
                                semanticWhitespace = whitespace
                            }
                        }

                        while let last = normalized.unicodeScalars.last, last ∈ CharacterSet.whitespaces {
                            normalized.unicodeScalars.removeLast()
                        }

                        return normalized + semanticWhitespace
                    }

                    file.contents = normalizedLines.joinedAsLines()
                    try file.writeChanges(for: self, output: output)
                }
            }
        }
    }
}
