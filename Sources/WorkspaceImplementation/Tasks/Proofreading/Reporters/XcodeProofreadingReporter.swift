/*
 XcodeProofreadingReporter.swift

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
  import SDGCommandLine

  internal final class XcodeProofreadingReporter: ProofreadingReporter {

    // MARK: - Static Properties

    internal static let `default` = XcodeProofreadingReporter()

    // MARK: - Initialization

    private init() {}

    // MARK: - ProofreadingReporter

    internal func reportParsing(file: String, to output: Command.Output) {
      // Unneeded.
    }

    internal func report(violation: StyleViolation, to output: Command.Output) {

      let location: String
      switch violation.location {
      case .text(let range, let textFile):
        let file = textFile.contents
        let lines = file.lines

        let path = textFile.location.path

        let lineIndex = range.lowerBound.line(in: lines)
        let lineNumber: Int = lines.distance(from: lines.startIndex, to: lineIndex) + 1

        let utf16LineStart = lineIndex.samePosition(in: file.clusters).samePosition(in: file.utf16)!
        let utf16ViolationStart = range.lowerBound.samePosition(in: file.utf16)!
        let column: Int = file.utf16.distance(from: utf16LineStart, to: utf16ViolationStart) + 1

        location = "\(path):\(lineNumber):\(column):"
      }
      output.print(
        "\(location) warning: \(violation.message.resolved()) (\(violation.ruleIdentifier.resolved()))"
      )
    }
  }
#endif
