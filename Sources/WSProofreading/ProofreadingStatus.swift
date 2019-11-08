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

internal class ProofreadingStatus: DiagnosticConsumer {

  // MARK: - Initialization

  internal init(reporter: ProofreadingReporter, output: Command.Output) {
    self.reporter = reporter
    self.output = output
  }

  // MARK: - Properties

  private let reporter: ProofreadingReporter
  private let output: Command.Output
  internal var currentFile: TextFile?
  internal private(set) var passing: Bool = true

  // MARK: - DiagnosticConsumer

  internal var needsLineColumn: Bool {
    return false
  }

  internal func handle(_ diagnostic: Diagnostic) {
    let file = currentFile!
    #warning("Are highlights useful?")
    let start: String.ScalarView.Index
    if let location = diagnostic.location {
      let utf8 = file.contents.utf8.index(
        file.contents.utf8.startIndex,
        offsetBy: location.offset
      )
      start = utf8.scalar(in: file.contents.scalars)
    } else {
      #warning("This seems conterproductive.")
      start = file.contents.scalars.startIndex
    }
    #warning("Are fix‐its useful?")
    let replacementSuggestion: StrictString? = nil
    #warning("What to do with identifiers?")
    let identifier = UserFacing<StrictString, InterfaceLocalization>({ _ in "swiftFormat" })
    let diagnosticMessage = StrictString(diagnostic.message.text)
    let message = UserFacing<StrictString, InterfaceLocalization>({ _ in diagnosticMessage })
    let violation = StyleViolation(
      in: file,
      at: start ..< start,
      replacementSuggestion: replacementSuggestion,
      noticeOnly: false,
      ruleIdentifier: identifier,
      message: message
    )
    report(violation: violation)
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
