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

        for url in try sourceFiles(output: output)
            where FileType(url: url) ≠ nil
                ∧ FileType(url: url) ≠ .xcodeProject {
                    try autoreleasepool {

                        let file = try TextFile(alreadyAt: url)
                        var syntax: SourceFileSyntax?
                        if file.fileType == .swift ∨ file.fileType == .swiftPackageManifest {
                            syntax = try SyntaxTreeParser.parse(url)
                        }

                        reporter.reportParsing(file: file.location.path(relativeTo: location), to: output)

                        for rule in activeRules {
                            try rule.parser.check(file: file, syntax: syntax, in: self, status: status, output: output)
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
