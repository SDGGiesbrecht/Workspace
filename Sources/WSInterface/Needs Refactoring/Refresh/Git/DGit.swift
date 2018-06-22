/*
 DGit.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSProject

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

    static func updateGitConfiguraiton(output: Command.Output) throws {

        let startToken = "# [_Begin Workspace Section_]"
        let endToken = "# [_End Workspace Section]"

        func replaceManagedSection(in file: TextFile, with contents: [String]) throws {
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
                ""
                ] + contents + [
                    "",
                    endToken
            ]
            if ¬existsAlready {
                updatedLines += [""]
            }

            body.replaceSubrange(managedRange, with: updatedLines.joinedAsLines())
            updatedFile.body = body
            try updatedFile.writeChanges(for: Repository.packageRepository, output: output)
        }

        // .gitignore

        let gitIgnore = try TextFile(possiblyAt: RelativePath(".gitignore").url)

        var updatedLines: [String] = requiredIgnoreEntries
        if try Repository.packageRepository.configuration().xcode.manage {
            updatedLines += dependentIgnoreEntriesForXcode
        }

        try replaceManagedSection(in: gitIgnore, with: updatedLines)

        // .gitattributes

        let gitAttributes = try TextFile(possiblyAt: RelativePath(".gitattributes").url)

        let updatedAttributes = [
            "/Refresh?Workspace* linguist\u{2D}vendored=true"
            ]

        try replaceManagedSection(in: gitAttributes, with: updatedAttributes)
    }
}
