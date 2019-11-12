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

import SDGLogic
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

  internal var needsLineColumn: Bool {  // @exempt(from: tests) Never called?
    return false
  }

  internal func handle(_ diagnostic: Diagnostic) {
    let file = currentFile!

    // Determine highlight range.
    let range: Range<String.ScalarView.Index>
    if let highlight = diagnostic.highlights.first,
    diagnostic.highlights.count == 1 {
      range = highlight.scalars(in: file.contents)
    } else {
      guard let location = diagnostic.location else {
        return
      }
      let start = location.scalar(in: file.contents)
      range = start ..< start
    }

    // Determine replacement.
    var replacementSuggestion: StrictString? = nil
    if let fixIt = diagnostic.fixIts.first,
      diagnostic.fixIts.count == 1, // @exempt(from: tests) No rules provide fix‐its yet.
      fixIt.range.scalars(in: file.contents) == range {
      replacementSuggestion = StrictString(fixIt.text)
    }

    // Extract rule identifier.
    var diagnosticMessage = StrictString(diagnostic.message.text)
    var ruleIdentifier = StrictString("swiftFormat")
    if let ruleName = diagnosticMessage.firstMatch(
      for: "[".scalars
        + RepetitionPattern(ConditionalPattern({ ¬$0.properties.isWhitespace ∧ $0 ≠ "]" }))
        + "]:".scalars) {
      ruleIdentifier += "[" + StrictString(ruleName.contents.dropFirst().dropLast(2)) + "]"
      diagnosticMessage.removeSubrange(ruleName.range)
      while diagnosticMessage.first?.properties.isWhitespace == true {
        diagnosticMessage.removeFirst()
      }
    }

    // Clean message up.
    diagnosticMessage.prepend(
      contentsOf: String(diagnosticMessage.removeFirst()).uppercased().scalars)
    if diagnosticMessage.last ≠ "." {
      diagnosticMessage.append(".")
    }
    let quotationPattern = "\u{27}".scalars
      + RepetitionPattern(ConditionalPattern({ $0 ≠ "\u{27}" }))
      + "\u{27}".scalars
    diagnosticMessage.mutateMatches(
      for: quotationPattern,
      mutation: { (match: PatternMatch<StrictString>) -> StrictString in
        var contents = StrictString(match.contents)
        contents.removeFirst()
        contents.prepend("‘")
        contents.removeLast()
        contents.append("’")
        return contents
    })
    let doubleQuotationPattern = "\u{22}".scalars
      + RepetitionPattern(ConditionalPattern({ $0 ≠ "\u{22}" }))
      + "\u{22}".scalars
    diagnosticMessage.mutateMatches(
      for: doubleQuotationPattern,
      mutation: { (match: PatternMatch<StrictString>) -> StrictString in
        var contents = StrictString(match.contents)
        contents.removeFirst()
        contents.prepend("“")
        contents.removeLast()
        contents.append("”")
        return contents
    })

    let identifier = UserFacing<StrictString, InterfaceLocalization>({ _ in ruleIdentifier })
    let message = UserFacing<StrictString, InterfaceLocalization>({ _ in diagnosticMessage })
    let violation = StyleViolation(
      in: file,
      at: range,
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
