/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

// #workaround(SwiftSyntax 0.50200.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  import SwiftSyntax
#endif
import SDGSwiftSource

import WSProject
import WSCustomTask

// #workaround(SwiftSyntax 0.50200.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  import SwiftFormat
#endif
// #workaround(swift-format 0.50200.0, Cannot build.)
#if !os(WASI)
  import SwiftFormatConfiguration
#endif

// #workaround(Swift 5.2.2, Web lacks Foundation.)
#if !os(WASI)
  extension PackageRepository {

    public func proofread(reporter: ProofreadingReporter, output: Command.Output) throws -> Bool {
      let status = ProofreadingStatus(reporter: reporter, output: output)

      #if os(Windows) || os(Android)  // #workaround(SwiftSyntax 0.50100.0, Cannot build.)
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

        for url in try sourceFiles(output: output)
        where FileType(url: url) ≠ nil
          ∧ FileType(url: url) ≠ .xcodeProject
        {
          try autoreleasepool {

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
                // #workaround(SwiftSyntax 0.50100.0, Cannot build.)
                #if !(os(Windows) || os(Android))
                  let syntax = try SyntaxParser.parseAndRetry(url)
                  try RuleSyntaxScanner(
                    rules: syntaxRules,
                    file: file,
                    project: self,
                    status: status,
                    output: output
                  ).scan(syntax)

                  try linter?.lint(syntax: syntax, assumingFileURL: url)
                #endif
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
