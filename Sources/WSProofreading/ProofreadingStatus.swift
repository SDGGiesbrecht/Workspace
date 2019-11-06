/*
 ProofreadingStatus.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSProject

import SwiftSyntax

internal class ProofreadingStatus : DiagnosticConsumer {

    // MARK: - Initialization

    internal init(reporter: ProofreadingReporter, output: Command.Output) {
        self.reporter = reporter
        self.output = output
    }

    // MARK: - Properties

    private let reporter: ProofreadingReporter
    private let output: Command.Output
    internal private(set) var passing: Bool = true

    // MARK: - DiagnosticConsumer

    internal func handle(_ diagnostic: Diagnostic) {
        #warning("Need access to the real file.")
        print(diagnostic)
    }

    internal func finalize() {}

    // MARK: - Usage

    internal func report(violation: StyleViolation) {
        if ¬violation.noticeOnly {
            passing = false
        }
        reporter.report(violation: violation, to: output)
    }

    internal func failExternalPhase() {
        passing = false
    }
}
