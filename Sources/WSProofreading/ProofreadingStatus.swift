/*
 ProofreadingStatus.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

internal class ProofreadingStatus {

    // MARK: - Initialization

    internal init(reporter: ProofreadingReporter) {
        self.reporter = reporter
    }

    // MARK: - Properties

    private let reporter: ProofreadingReporter
    internal private(set) var passing: Bool = true

    // MARK: - Usage

    internal func report(violation: StyleViolation, to output: Command.Output) {
        if ¬violation.noticeOnly {
            passing = false
        }
        reporter.report(violation: violation, to: output)
    }

    internal func failExternalPhase() {
        passing = false
    }
}
