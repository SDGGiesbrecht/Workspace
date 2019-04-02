/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import SDGSwiftSource

import WSProject

extension PackageRepository {

    public func proofread(reporter: ProofreadingReporter, output: Command.Output) throws -> Bool {
        let status = ProofreadingStatus(reporter: reporter)

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

                            if ¬syntaxRules.isEmpty,
                                file.fileType == .swift ∨ file.fileType == .swiftPackageManifest {
                                let syntax = try SyntaxTreeParser.parseAndRetry(url)
                                try RuleSyntaxScanner(
                                    rules: syntaxRules,
                                    file: file,
                                    project: self,
                                    status: status,
                                    output: output).scan(syntax)
                            }
                        }
            }
        }
        
        if false {
            status.failExternalPhase()
        }

        return status.passing
    }
}
