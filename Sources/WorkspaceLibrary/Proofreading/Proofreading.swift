/*
 Proofreading.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

enum Proofreading {

    static func proofread(project: PackageRepository, reporter: ProofreadingReporter, output: inout Command.Output) throws -> Bool {
        let status = ProofreadingStatus(reporter: reporter)

        let disabledRules: Set<StrictString> = try project.configuration.disabledProofreadingRules()
        let activeRules = (rules + manualWarnings as [Rule.Type]).filter { rule in
            for name in InterfaceLocalization.cases.lazy.map({ rule.name.resolved(for: $0) }) where  name ∈ disabledRules {
                return false
            } // [_Exempt from Test Coverage_] False positive in Xcode 9.2.
            return true
        }

        for url in try project.sourceFiles(output: &output)
            where (try? FileType(url: url)) ≠ nil
                ∧ (try? FileType(url: url)) ≠ .xcodeProject {
                    try autoreleasepool {

                        let file = try TextFile(alreadyAt: url)

                        reporter.reportParsing(file: file.location.path(relativeTo: project.location), to: &output)

                        for rule in activeRules {
                            try rule.check(file: file, in: project, status: status, output: &output)
                        }
                    }
        }

        try proofreadWithSwiftLint(project: project, status: status, forXcode: reporter is XcodeProofreadingReporter, output: &output)

        return status.passing
    }

    private static func proofreadWithSwiftLint(project: PackageRepository, status: ProofreadingStatus, forXcode: Bool, output: inout Command.Output) throws {

        #if os(Linux)
        // [_Workaround: SwiftLint requires elaborate proping on Linux. (swiftlint version 0.24.2)_]
        do {
            try Shell.default.run(command: ["swiftlint", "version"], silently: true)
            // Use SwiftLint if it has been manually installed...
        } catch {
            return // ...otherwise skip.
        }
        #endif

        try FileManager.default.do(in: project.location) {

            let configuration: URL?
            if SwiftLint.default.isConfigured() {
                configuration = nil
            } else {
                let standard = FileManager.default.url(in: .cache, at: "SwiftLint/Configuration.yml")
                configuration = standard
                try SwiftLint.default.standardConfiguration().save(to: standard)
            }

            if ¬(try SwiftLint.default.proofread(withConfiguration: configuration, forXcode: forXcode, output: &output)) {
                status.failExternalPhase()
            }
        }
    }
}
