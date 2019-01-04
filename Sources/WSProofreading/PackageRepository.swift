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
                                // #workaround(SDGSwift 0.4.0, This should use “parseAndRetry”)
                                let syntax = try SyntaxTreeParser.parse(url)

                                #warning("This should be refactored.")
                                try SyntaxScanner(
                                    checkSyntax: { node in
                                        for rule in syntaxRules {
                                            rule.check(node, in: file, in: self, status: status, output: output)
                                        }
                                },
                                    checkExtendedSyntax: { node in
                                        for rule in syntaxRules {
                                            rule.check(node, in: file, in: self, status: status, output: output)
                                        }
                                },
                                    checkTrivia: { trivia in
                                        for rule in syntaxRules {
                                            rule.check(trivia, in: file, in: self, status: status, output: output)
                                        }
                                },
                                    checkTriviaPiece: { trivia in
                                        for rule in syntaxRules {
                                            rule.check(trivia, in: file, in: self, status: status, output: output)
                                        }
                                }).scan(syntax)
                            }
                        }
            }
        }

        try proofreadWithSwiftLint(status: status, forXcode: reporter is XcodeProofreadingReporter, output: output)

        return status.passing
    }

    private func proofreadWithSwiftLint(status: ProofreadingStatus, forXcode: Bool, output: Command.Output) throws {

        try FileManager.default.do(in: location) {

            let configuration: URL?
            if SwiftLint.default.isConfigured() {
                configuration = nil
            } else {
                let standard = FileManager.default.url(in: .cache, at: "SwiftLint/Configuration.yml")
                configuration = standard
                try SwiftLint.default.standardConfiguration().save(to: standard)
            }

            if ¬(try SwiftLint.default.proofread(withConfiguration: configuration, forXcode: forXcode, output: output)) {
                status.failExternalPhase()
            }
        }
    }
}
