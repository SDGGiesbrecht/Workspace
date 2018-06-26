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

    static func refreshFileHeaders(output: Command.Output) throws {

        let template = try Repository.packageRepository.fileHeader(output: output)

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
                    header = header.replacingMatches(for: "#dates", with: copyright(fromText: oldHeader))

                    file.header = String(header)
                    try file.writeChanges(for: Repository.packageRepository, output: output)
                }
            }
        }
    }
}
