/*
 FileHeaders.swift

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

struct FileHeaders {

    static func copyright(fromText text: String) -> StrictString {

        var oldStartDate: String?
        for symbol in ["©", "(C)", "(c)"] {
            for space in ["", " "] {
                if let range = text.scalars.firstMatch(for: (symbol + space).scalars)?.range {
                    var numberEnd = range.upperBound
                    text.scalars.advance(&numberEnd, over: RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.decimalDigits })))
                    let number = text.scalars[range.upperBound ..< numberEnd]
                    if number.count == 4 {
                        oldStartDate = String(number)
                        break
                    }
                }
            }
        }
        let currentDate = Date()
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let currentYear = "\(calendar.component(.year, from: currentDate))"
        let copyrightStart = oldStartDate ?? currentYear

        var copyright = "©"
        if currentYear == copyrightStart {
            copyright.append(currentYear)
        } else {
            copyright.append(copyrightStart + "–" + currentYear)
        }

        return StrictString(copyright)
    }

    static func refreshFileHeaders(output: Command.Output) throws {

        let template = try Repository.packageRepository.fileHeader()

        var skippedFiles: Set<String> = []
        skippedFiles.insert("LICENSE.md")
        skippedFiles.insert(".github/ISSUE_TEMPLATE.md")
        skippedFiles.insert(".github/PULL_REQUEST_TEMPLATE.md")

        func shouldManageHeader(path: RelativePath) -> Bool {
            if path.string ∈ skippedFiles {
                return false
            }

            return true
        }

        for path in Repository.sourceFiles.filter({ shouldManageHeader(path: $0) }) {
            try autoreleasepool {

                if let type = FileType(url: path.url),
                    type.syntax.hasComments {

                    var file = require { try TextFile(alreadyAt: path.url) }
                    let oldHeader = file.header
                    var header = template

                    header = header.replacingMatches(for: "#filename", with: StrictString(path.filename))
                    header = header.replacingMatches(for: "#dates", with: FileHeaders.copyright(fromText: oldHeader))

                    file.header = String(header)
                    try file.writeChanges(for: Repository.packageRepository, output: output)
                }
            }
        }
    }
}
