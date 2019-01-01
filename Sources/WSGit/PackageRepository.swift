/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import WSGeneralImports

import WSProject

extension PackageRepository {

    // MARK: - Lists

    private static var ignoreEntriesForMacOS: [String] {
        return [
            ".DS_Store"
        ]
    }

    private static var ignoreEntriesForLinux: [String] {
        return [
            "*~"
        ]
    }

    private static var ignoreEntriesForSwiftProjectManager: [String] {
        return [
            ".build",
            "Packages"
        ]
    }

    private static var ignoreEntriesForWorkspace: [String] {
        return [
            "Validate\\ (macOS).command",
            "Validate\\ (Linux).sh"
        ]
    }

    private static var ignoreEntriesForXcode: [String] {
        return [
            "*.xcodeproj",
            "IDEWorkspaceChecks.plist",
            "xcuserdata",
            "*.profraw"
        ]
    }

    private static var ignoreEntries: [String] {
        return ignoreEntriesForMacOS
            + ignoreEntriesForLinux
            + ignoreEntriesForSwiftProjectManager
            + ignoreEntriesForWorkspace
            + ignoreEntriesForXcode
    }

    public func refreshGitConfiguration(output: Command.Output) throws {

        let entries = try PackageRepository.ignoreEntries + configuration(output: output).git.additionalGitIgnoreEntries

        var gitIgnore = try TextFile(possiblyAt: location.appendingPathComponent(".gitignore"))
        gitIgnore.body = entries.joinedAsLines()
        try gitIgnore.writeChanges(for: self, output: output)

        var gitAttributes = try TextFile(possiblyAt: location.appendingPathComponent(".gitattributes"))
        if let deprecatedManagedSection = gitAttributes.contents.scalars.firstMatch(for: [
            LiteralPattern("# [_Begin Workspace Section_]".scalars),
            RepetitionPattern(ConditionalPattern({ _ in true })),
            LiteralPattern("# [_End Workspace Section]".scalars)
            ]) {
            if gitAttributes.contents.scalars[deprecatedManagedSection.range.upperBound...].contains(where: { $0 ∉ CharacterSet.whitespacesAndNewlines }) {
                // Custom attributes present.
                gitAttributes.contents.scalars.removeSubrange(deprecatedManagedSection.range)
                try gitAttributes.writeChanges(for: self, output: output)
            } else {
                // Only deprecated Workspace entries.
                delete(gitAttributes.location, output: output)
            }
        }
    }
}
