/*
 PackageRepository + Git.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import WSGeneralImports

// #workaround(Swift 5.2.4, Web lacks Foundation.)
#if !os(WASI)
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
        "Packages",
        ".swiftpm",
      ]
    }

    private static var ignoreEntriesForWorkspace: [String] {
      return [
        "Validate\\ (macOS).command",
        "Validate\\ (Linux).sh",
      ]
    }

    private static var ignoreEntriesForXcode: [String] {
      return [
        "*.xcodeproj",
        "IDEWorkspaceChecks.plist",
        "xcuserdata",
        "*.profraw",
      ]
    }

    private static var ignoreEntries: [String] {
      return ignoreEntriesForMacOS
        + ignoreEntriesForLinux
        + ignoreEntriesForSwiftProjectManager
        + ignoreEntriesForWorkspace
        + ignoreEntriesForXcode
    }

    internal func refreshGitConfiguration(output: Command.Output) throws {

      let entries =
        try PackageRepository.ignoreEntries
        + configuration(output: output).git.additionalGitIgnoreEntries

      var gitIgnore = try TextFile(possiblyAt: location.appendingPathComponent(".gitignore"))
      gitIgnore.body = entries.joinedAsLines()
      try gitIgnore.writeChanges(for: self, output: output)

      var gitAttributes = try TextFile(
        possiblyAt: location.appendingPathComponent(".gitattributes")
      )
      if let deprecatedManagedSection = gitAttributes.contents.scalars.firstMatch(
        for: "# [_Begin Workspace Section_]".scalars
          + RepetitionPattern(ConditionalPattern({ _ in true }))
          + "# [_End Workspace Section]".scalars
      ) {
        if gitAttributes.contents.scalars[deprecatedManagedSection.range.upperBound...]
          .contains(where: { $0 ∉ CharacterSet.whitespacesAndNewlines })
        {
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
#endif
