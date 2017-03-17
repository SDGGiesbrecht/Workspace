/*
 ReadMe.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

struct ReadMe {

    static let readMePath = RelativePath("README.md")

    private static let managementComment: String = {
        let managementWarning = File.managmentWarning(section: false, documentation: .readMe)
        return FileType.markdown.syntax.comment(contents: managementWarning)
    }()

    static let defaultReadMeTemplate: String = {
        var instructions: [String] = [
            "# [_Project_]"
        ]

        return join(lines: instructions)
    }()

    static func refreshReadMe() {

        func key(_ name: String) -> String {
            return "[_\(name)_]"
        }

        var body = join(lines: [
            managementComment,
            "",
            ReadMe.defaultReadMeTemplate
            ])

        body = body.replacingOccurrences(of: key("Project"), with: Configuration.projectName)

        var readMe = File(possiblyAt: readMePath)
        readMe.body = body
        require() { try readMe.write() }
    }

    static func relinquishControl() {

        var readMe = File(possiblyAt: readMePath)
        if let range = readMe.contents.range(of: managementComment) {
            printHeader(["Cancelling read‐me management..."])
            readMe.contents.removeSubrange(range)
            force() { try readMe.write() }
        }
    }
}
