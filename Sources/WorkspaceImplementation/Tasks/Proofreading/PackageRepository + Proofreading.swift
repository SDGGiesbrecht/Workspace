/*
 PackageRepository + Proofreading.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGControlFlow
  import SDGLogic
  import SDGCollections

  import SDGCommandLine

  import SDGSwift
  import SDGSwiftSource
  import SwiftSyntax
  import SwiftSyntaxParser

  import SwiftFormat
  import SwiftFormatConfiguration

  import WorkspaceLocalizations

  extension PackageRepository {

    internal func proofread(reporter: ProofreadingReporter, output: Command.Output) throws -> Bool {
      let status = ProofreadingStatus(reporter: reporter, output: output)

      var linter: SwiftLinter?
      if let formatConfiguration = try configuration(output: output).proofreading
        .swiftFormatConfiguration
      {
        linter = SwiftLinter(
          configuration: formatConfiguration,
          findingConsumer: { finding in
            status.handle(finding)
          }
        )
      }

      let activeRules = try configuration(output: output).proofreading.rules.sorted()
      if ¬activeRules.isEmpty ∨ linter ≠ nil {

        var textRules: [TextRule.Type] = []
        var syntaxRules: [SyntaxRule.Type] = []
        for rule in activeRules.lazy.map({ $0.parser }) {
          switch rule {
          case .text(let textParser):
            textRules.append(textParser)
          case .syntax(let syntaxParser):
            syntaxRules.append(syntaxParser)
          }
        }

        let sourceURLs = try sourceFiles(output: output)

        var settings: [URL: Setting] = [
          location.appendingPathComponent("Package.swift"): .topLevel
        ]
        for name in InterfaceLocalization.allCases
          .map({ PackageRepository.workspaceConfigurationNames.resolved(for: $0) })
        {
          settings[location.appendingPathComponent(String(name) + ".swift")] = .topLevel
        }
        guard #available(macOS 10.15, *) else {
          throw SwiftPMUnavailableError()  // @exempt(from: tests)
        }
        for target in try cachedPackage().targets {
          let setting: Setting?
          switch target.type {
          case .library, .binary:
            setting = .library
          case .executable, .plugin, .test, .snippet:
            setting = .topLevel
          case .systemModule:  // @exempt(from: tests)
            setting = nil
          }
          if let determined = setting {
            for source in target.sources.paths {
              settings[source.asURL] = determined
            }
          }
        }

        for url in sourceURLs
        where FileType(url: url) ≠ nil
          ∧ FileType(url: url) ≠ .xcodeProject
        {
          try purgingAutoreleased {

            let file = try TextFile(alreadyAt: url)
            reporter.reportParsing(
              file: file.location.path(relativeTo: location),
              to: output
            )
            status.currentFile = file

            for rule in textRules {
              try rule.check(file: file, in: self, status: status, output: output)
            }

            if file.fileType == .swift ∨ file.fileType == .swiftPackageManifest {
              if ¬syntaxRules.isEmpty ∨ linter ≠ nil {
                let syntax = try SyntaxParser.parseAndRetry(url)
                try RuleSyntaxScanner(
                  rules: syntaxRules,
                  file: file,
                  setting: settings[url] ?? .unknown,
                  project: self,
                  status: status,
                  output: output
                ).scan(syntax)

                try linter?.lint(syntax: syntax, assumingFileURL: url)
              }
            }
          }
        }
      }

      for task in try configuration(output: output).customProofreadingTasks {
        do {
          try task.execute(output: output)
        } catch {
          status.failExternalPhase()
        }
      }

      return status.passing
    }
  }
#endif
