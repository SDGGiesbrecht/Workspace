/*
 PackageRepository + Git.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGCollections
  import SDGText

  import SDGCommandLine

  import SDGSwift

  import WorkspaceLocalizations

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

    private static var ignoreEntriesForSwiftPackageManager: [String] {
      return [
        ".build",
        "Packages",
        ".swiftpm",
      ]
    }

    private static var ignoreEntriesForWorkspace: [String] {
      var entries: Set<StrictString> = []
      for localization in InterfaceLocalization.allCases {
        entries.insert(Script.validateMacOS.fileName(localization: localization))
        entries.insert(Script.validateLinux.fileName(localization: localization))
      }
      return entries.sorted().map { entry in
        let escaped = entry.replacingMatches(for: " ", with: #"\ "#)
        let patched: [ExtendedGraphemeCluster] = escaped.clusters.map { cluster in
          let string = String(cluster)
          if string.decomposedStringWithCanonicalMapping.scalars
            .elementsEqual(string.precomposedStringWithCanonicalMapping.scalars)
          {
            return cluster
          } else {
            return "*"
          }
        }
        return String(patched)
      }
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
        + ignoreEntriesForSwiftPackageManager
        + ignoreEntriesForWorkspace
        + ignoreEntriesForXcode
    }

    #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
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
    #endif
  }
#endif
