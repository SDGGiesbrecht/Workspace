/*
 PackageRepository + GitHub.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

  import Foundation

import SDGCollections
import SDGText

import SDGCommandLine

import SDGSwift

  extension PackageRepository {

    // MARK: - Locations

    private var gitHubDirectory: URL {
      return location.appendingPathComponent(".github")
    }

    private var depricatedContributingInstructions: URL {
      return location.appendingPathComponent("CONTRIBUTING.md")
    }
    private var contributingInstructionsLocation: URL {
      return gitHubDirectory.appendingPathComponent("CONTRIBUTING.md")
    }

    private var depricatedIssueTemplateLocation: URL {
      return gitHubDirectory.appendingPathComponent("ISSUE_TEMPLATE.md")
    }
    private var issueTemplatesDirectory: URL {
      return gitHubDirectory.appendingPathComponent("ISSUE_TEMPLATE")
    }
    private func issueTemplateLocation(for title: StrictString) -> URL {
      return issueTemplatesDirectory.appendingPathComponent(String(title + ".md"))
    }

    private var pullRequestTemplateLocation: URL {
      return gitHubDirectory.appendingPathComponent("PULL_REQUEST_TEMPLATE.md")
    }

    // MARK: - Refreshment

    internal func refreshGitHubConfiguration(output: Command.Output) throws {
      try refreshContributingInstructions(output: output)
      try refreshIssueTemplates(output: output)

      #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
      var pullRequestTemplateFile = try TextFile(possiblyAt: pullRequestTemplateLocation)
      pullRequestTemplateFile.contents = String(
        try configuration(output: output).gitHub.pullRequestTemplate
      )
      try pullRequestTemplateFile.writeChanges(for: self, output: output)
      #endif
    }

    private func refreshContributingInstructions(output: Command.Output) throws {

      #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
      var contributingInstructionsFile = try TextFile(
        possiblyAt: contributingInstructionsLocation
      )
      contributingInstructionsFile.body = String(
        try constructedContributingInstructions(output: output)
      )
      try contributingInstructionsFile.writeChanges(for: self, output: output)
      #endif

      // Remove deprecated.
      delete(depricatedContributingInstructions, output: output)
    }

    private func constructedContributingInstructions(output: Command.Output) throws -> StrictString
    {
      let configuration = try self.configuration(output: output)
      let entries = try contributingInstructions(output: output)
      if entries.count == 1 {  // No separation of localizations needed.
        for (_, entry) in entries {
          return entry
        }
      }

      var file: [StrictString] = []
      for localization in configuration.documentation.localizations {
        if let entry = entries[localization] {
          file.append("<details>")
          file.append("<summary>\(localization._iconOrCode)</summary>")
          file.append(entry)
          file.append("</details>")
        }
      }

      return file.joinedAsLines()
    }

    private func refreshIssueTemplates(output: Command.Output) throws {
      var validFiles: Set<URL> = []
      let templateSet = try issueTemplates(output: output)
      for localization in templateSet.keys.sorted(by: { $0._iconOrCode < $1._iconOrCode }) {
        let templates = templateSet[localization]!
        for template in templates {
          let modifiedName: StrictString = "\(localization._iconOrCode) \(template.name)"
          let fileLocation = issueTemplateLocation(for: modifiedName)
          validFiles.insert(fileLocation)

          var fileContents: [StrictString] = [
            "\u{2D}\u{2D}\u{2D}",
            "name: \u{27}\(modifiedName)\u{27}",
            "about: \u{27}\(template.description)\u{27}",
            "title: \u{27}\(template.title ?? "")\u{27}",
            "labels: \u{27}\(template.labels.joined(separator: ", "))\u{27}",
            "assignees: \u{27}\(template.assignees.joined(separator: ", "))\u{27}",
            "",
            "\u{2D}\u{2D}\u{2D}",
            "",
          ]
          fileContents.append(template.content)

          #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
          var issueTemplateFile = try TextFile(possiblyAt: fileLocation)
          issueTemplateFile.contents = String(fileContents.joinedAsLines())
          try issueTemplateFile.writeChanges(for: self, output: output)
          #endif
        }
      }

      delete(depricatedIssueTemplateLocation, output: output)
      if let files = try? FileManager.default.deepFileEnumeration(in: issueTemplatesDirectory) {
        for file in files where file ∉ validFiles {
          delete(file, output: output)
        }
      }
    }
  }
