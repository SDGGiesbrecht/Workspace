/*
 Git.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic

struct Git {

    static let ignoreEntriesForMacOS = [
        ".DS_Store"
        ]

    static let ignoreEntriesForSwiftProjectManager = [
        "/.build",
        "/Packages"
        ]

    static let ignoreEntriesForWorkspace = [
        "/.Workspace",
        "/Validate\\ Changes\\ (macOS).command",
        "/Validate\\ Changes\\ (Linux).sh",
        "/.Linked Repositories",
        "/.Test\\ Zone"
        ]

    static let requiredIgnoreEntries = ignoreEntriesForMacOS
        + ignoreEntriesForSwiftProjectManager
        + ignoreEntriesForWorkspace

    static let ignoreEntriesForXcode = [
        "/*.xcodeproj"
        ]

    static func updateGitConfiguraiton() {

        let startToken = "# [_Begin Workspace Section_]"
        let endToken = "# [_End Workspace Section]"

        let managementWarning = File.managmentWarning(section: true, documentation: .git)
        let managementComment = FileType.gitignore.syntax.comment(contents: managementWarning)

        func replaceManagedSection(in file: File, with contents: [String]) {
            var updatedFile = file

            var body = updatedFile.body

            var managedRange: Range<String.Index>
            if let section = body.range(of: (startToken, endToken)) {
                managedRange = section
            } else {
                if Command.current == .initialize {
                    managedRange = body.startIndex ..< body.endIndex
                } else {
                    managedRange = body.startIndex ..< body.startIndex
                }
            }

            let updatedLines: [String] = [
                startToken,
                "",
                managementComment,
                ""
                ] + contents + [
                    "",
                    endToken
            ]

            body.replaceSubrange(managedRange, with: join(lines: updatedLines))
            updatedFile.body = body
            require() {try updatedFile.write() }
        }

        // .gitignore

        let gitIgnore = require() { try File(at: RelativePath(".gitignore")) }

        var updatedLines: [String] = requiredIgnoreEntries
        if Configuration.manageXcode {
            updatedLines += ignoreEntriesForXcode
        }

        replaceManagedSection(in: gitIgnore, with: updatedLines)

        // .gitattributes

        let gitAttributes = File(possiblyAt: RelativePath(".gitattributes"))

        let updatedAttributes = [
            "/Refresh?Workspace* linguist-vendored=true"
            ]

        replaceManagedSection(in: gitAttributes, with: updatedAttributes)

    }
}
