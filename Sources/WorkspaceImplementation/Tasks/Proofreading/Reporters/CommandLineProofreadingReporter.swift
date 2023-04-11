/*
 CommandLineProofreadingReporter.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGCollections
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import WorkspaceLocalizations

  internal final class CommandLineProofreadingReporter: ProofreadingReporter {

    // MARK: - Static Properties

    internal static let `default` = CommandLineProofreadingReporter()

    // MARK: - Initialization

    private init() {}

    // MARK: - ProofreadingReporter

    internal func reportParsing(file: String, to output: Command.Output) {
      output.print(file.in(FontWeight.bold))
    }

    internal static func lineNumberReport(_ integer: Int) -> UserFacing<
      StrictString, InterfaceLocalization
    > {
      return UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Line " + integer.inDigits()
        case .deutschDeutschland:
          return "Zeile " + integer.inDigits()
        }
      })
    }
    private func lineMessage(
      source: String,
      violation: Range<String.ScalarView.Index>
    ) -> StrictString {
      let lines = source.lines
      let lineRange = violation.lines(in: lines)
      let lineNumber = lines.distance(from: lines.startIndex, to: lineRange.lowerBound) + 1
      return CommandLineProofreadingReporter.lineNumberReport(lineNumber).resolved()
    }

    private func display(
      source: String,
      violation: Range<String.ScalarView.Index>,
      replacementSuggestion: StrictString?,
      highlight: (String) -> String
    ) -> String {
      let lines = source.lines
      let lineRange = violation.lines(in: lines)
      let context = lineRange.sameRange(in: source.clusters)
      let preceding = String(source.clusters[context.lowerBound..<violation.lowerBound])
      let problem = highlight(String(source.clusters[violation])).in(Underline.underlined)
      let following = String(source.clusters[violation.upperBound..<context.upperBound])
      var result = preceding + problem + following
      if let suggestion = replacementSuggestion {
        result += preceding + String(suggestion).formattedAsSuccess() + following
      }
      return result
    }

    internal func report(violation: StyleViolation, to output: Command.Output) {

      func highlight<S: StringFamily>(_ problem: S) -> S {
        if violation.noticeOnly {
          return problem.formattedAsWarning()
        } else {
          return problem.formattedAsError()
        }
      }

      let description =
        highlight(violation.message.resolved()) + " ("
        + violation.ruleIdentifier.resolved() + ")"

      let message: [String]
      switch violation.location {
      case .text(let range, let file):
        message = [
          String(lineMessage(source: file.contents, violation: range)),
          String(description),
          display(
            source: file.contents,
            violation: range,
            replacementSuggestion: violation.replacementSuggestion,
            highlight: highlight
          ),
        ]
      case .file(let url):
        message = [
          String(description),
          url,
        ]
      }
      output.print(message.joinedAsLines())
    }

    // Parallel reporting style for test coverage.
    internal func report(
      violation: Range<String.ScalarView.Index>,
      in file: String,
      to output: Command.Output
    ) {
      output.print(
        [
          String(lineMessage(source: file, violation: violation)),
          display(
            source: file,
            violation: violation,
            replacementSuggestion: nil,
            highlight: { $0.formattedAsError() }
          ),
        ].joinedAsLines()
      )
    }
  }
#endif
