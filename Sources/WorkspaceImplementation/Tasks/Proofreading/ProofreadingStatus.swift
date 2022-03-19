/*
 ProofreadingStatus.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGLogic
  import SDGMathematics
  import SDGCollections
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SwiftSyntax
  import SwiftFormat

  import WorkspaceLocalizations

  internal class ProofreadingStatus {

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

    // MARK: - SwiftFormat

    internal func handle(_ finding: Finding) {
      let file = currentFile!

      // Determine highlight range.
      guard let location = finding.location else {
        return  // @exempt(from: tests) Trigger unknown.
      }
      let source = file.contents
      let scalars = source.scalars
      let utf8 = source.utf8
      let lines = source.lines
      var utf8Index =
        (lines.index(
          lines.startIndex,
          offsetBy: location.line − 1,
          limitedBy: lines.endIndex
        ) ?? lines.endIndex)  // @exempt(from: tests) Fallback can only happen if swift‐format misbehaves.
        .samePosition(in: scalars).samePosition(in: utf8)
        ?? utf8.endIndex  // @exempt(from: tests) Fallback can only happen if swift‐format misbehaves.
      utf8Index =
        utf8.index(utf8Index, offsetBy: location.column − 1, limitedBy: utf8.endIndex)
        ?? utf8.endIndex  // @exempt(from: tests) Fallback can only happen if swift‐format misbehaves.
      let index = utf8Index.scalar(in: scalars)
      let range: Range<String.ScalarView.Index> = index..<index

      // Extract rule identifier.
      let ruleIdentifier: StrictString = "swiftFormat[\(String(describing: finding.category))]"

      // Clean message up.
      var diagnosticMessage = StrictString(finding.message.text)
      diagnosticMessage.prepend(
        contentsOf: String(diagnosticMessage.removeFirst()).uppercased().scalars
      )
      if diagnosticMessage.last ≠ "." {
        diagnosticMessage.append(".")
      }

      let identifier = UserFacing<StrictString, InterfaceLocalization>({ _ in ruleIdentifier })
      let message = UserFacing<StrictString, InterfaceLocalization>({ _ in diagnosticMessage })
      if let notExempt = StyleViolation(
        in: file,
        at: range,
        replacementSuggestion: nil,
        noticeOnly: false,
        ruleIdentifier: identifier,
        message: message
      ) {
        report(violation: notExempt)
      }
    }

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
#endif
