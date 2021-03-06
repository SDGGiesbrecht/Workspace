/*
 PackageRepository + Proofreading.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGControlFlow
import SDGLogic
import SDGCollections

import SDGCommandLine

import SDGSwift
import SDGSwiftSource
// #workaround(SwiftSyntax 0.50300.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  import SwiftSyntax
#endif

// #workaround(SwiftSyntax 0.50300.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  import SwiftFormat
#endif
#if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_FORMAT_SWIFT_FORMAT_CONFIGURATION
  import SwiftFormatConfiguration
#endif

import WorkspaceLocalizations

extension PackageRepository {

  internal func proofread(reporter: ProofreadingReporter, output: Command.Output) throws -> Bool {
    let status = ProofreadingStatus(reporter: reporter, output: output)

    // #workaround(SwiftSyntax 0.50300.0, Cannot build.)
    #if os(Windows) || os(WASI) || os(Android)
      var linter: Bool?
    #else
      var linter: SwiftLinter?
      if let formatConfiguration = try configuration(output: output).proofreading
        .swiftFormatConfiguration
      {
        let diagnostics = DiagnosticEngine()
        diagnostics.addConsumer(status)
        linter = SwiftLinter(configuration: formatConfiguration, diagnosticEngine: diagnostics)
      }
    #endif

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
      #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
        for target in try cachedPackage().targets {
          let setting: Setting?
          switch target.type {
          case .library, .binary:
            setting = .library
          case .executable, .test:
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
      #endif

      for url in sourceURLs
      where FileType(url: url) ≠ nil
        ∧ FileType(url: url) ≠ .xcodeProject
      {
        #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
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
                // #workaround(SwiftSyntax 0.50300.0, Cannot build.)
                #if !(os(Windows) || os(Android))
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
                #endif
              }
            }
          }
        #endif
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
