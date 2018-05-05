/*
 DGit.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

struct DGit {

    static let ignoreEntriesForMacOS = [
        ".DS_Store"
        ]
    static let ignoreEntriesForLinux = [
        "*~"
    ]

    static let ignoreEntriesForSwiftProjectManager = [
        ".build",
        "Packages"
        ]

    static let ignoreEntriesForWorkspace = [
        "Validate\\ (macOS).command",
        "Validate\\ (Linux).sh"
        ]

    static let ignoreEntriesForXcode = [
        "*.profraw"
    ]
    static let dependentIgnoreEntriesForXcode = [
        "*.xcodeproj"
    ]

    static let ignoreEntriesForJazzy = [
        "undocumented.json",
        // [_Workaround: Jazzy gzips undocumented.json. (jazzy --version 0.7.5)_]
        "*.tgz"
    ]

    static let requiredIgnoreEntries = ignoreEntriesForMacOS
        + ignoreEntriesForLinux
        + ignoreEntriesForSwiftProjectManager
        + ignoreEntriesForXcode
        + ignoreEntriesForWorkspace
        + ignoreEntriesForJazzy

    static func updateGitConfiguraiton(output: Command.Output) {

        let startToken = "# [_Begin Workspace Section_]"
        let endToken = "# [_End Workspace Section]"

        let managementWarning = File.managmentWarning(section: true, documentation: .git)
        let managementComment = FileType.gitignore.syntax.comment(contents: managementWarning)

        func replaceManagedSection(in file: File, with contents: [String]) {
            var updatedFile = file

            var body = updatedFile.body

            let existsAlready: Bool
            var managedRange: Range<String.Index>
            if let section = body.scalars.firstNestingLevel(startingWith: startToken.scalars, endingWith: endToken.scalars)?.container.range.clusters(in: body.clusters) {
                existsAlready = true
                managedRange = section
            } else {
                existsAlready = false
                if CommandLine.arguments[1] == "initialize" {
                    managedRange = body.startIndex ..< body.endIndex
                } else {
                    managedRange = body.startIndex ..< body.startIndex
                }
            }

            var updatedLines: [String] = [
                startToken,
                "",
                managementComment,
                ""
                ] + contents + [
                    "",
                    endToken
            ]
            if ¬existsAlready {
                updatedLines += [""]
            }

            body.replaceSubrange(managedRange, with: updatedLines.joinAsLines())
            updatedFile.body = body
            require {try updatedFile.write(output: &output) }
        }

        // .gitignore

        let gitIgnore = File(possiblyAt: RelativePath(".gitignore"))

        var updatedLines: [String] = requiredIgnoreEntries
        if Configuration.manageXcode {
            updatedLines += dependentIgnoreEntriesForXcode
        }

        replaceManagedSection(in: gitIgnore, with: updatedLines)

        // .gitattributes

        let gitAttributes = File(possiblyAt: RelativePath(".gitattributes"))

        let updatedAttributes = [
            "/Refresh?Workspace* linguist\u{2D}vendored=true"
            ]

        replaceManagedSection(in: gitAttributes, with: updatedAttributes)

    }
}
