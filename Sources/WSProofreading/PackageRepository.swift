/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import SwiftSyntax
import SDGSwiftSource

import WSProject
import WSCustomTask

import SwiftFormat
import SwiftFormatConfiguration

extension PackageRepository {

    public func proofread(reporter: ProofreadingReporter, output: Command.Output) throws -> Bool {
        let status = ProofreadingStatus(reporter: reporter)

        let formatConfiguration = SwiftFormatConfiguration.Configuration()
        #warning("This needs to be plugged into something?")
        let diagnostics = DiagnosticEngine()
        let linter = SwiftLinter(configuration: formatConfiguration, diagnosticEngine: diagnostics)

        let activeRules = try configuration(output: output).proofreading.rules.sorted()
        if ¬activeRules.isEmpty {

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
                    ∧ FileType(url: url) ≠ .xcodeProject {
                        try autoreleasepool {

                            let file = try TextFile(alreadyAt: url)
                            reporter.reportParsing(file: file.location.path(relativeTo: location), to: output)

                            for rule in textRules {
                                try rule.check(file: file, in: self, status: status, output: output)
                            }

                            if file.fileType == .swift ∨ file.fileType == .swiftPackageManifest {
                                if ¬syntaxRules.isEmpty {
                                    let syntax = try SyntaxParser.parseAndRetry(url)
                                    try RuleSyntaxScanner(
                                        rules: syntaxRules,
                                        file: file,
                                        project: self,
                                        status: status,
                                        output: output).scan(syntax)
                                    try linter.lint(syntax: syntax, assumingFileURL: url)
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
