/*
 XcodeProofreadingReporter.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

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

    let file = violation.file.contents
    let lines = file.lines

    // #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
    #if !os(WASI)
      let path = violation.file.location.path

      let lineIndex = violation.range.lowerBound.line(in: lines)
      let lineNumber: Int = lines.distance(from: lines.startIndex, to: lineIndex) + 1

      let utf16LineStart = lineIndex.samePosition(in: file.clusters).samePosition(in: file.utf16)!
      let utf16ViolationStart = violation.range.lowerBound.samePosition(in: file.utf16)!
      let column: Int = file.utf16.distance(from: utf16LineStart, to: utf16ViolationStart) + 1

      output.print(
        "\(path):\(lineNumber):\(column): warning: \(violation.message.resolved()) (\(violation.ruleIdentifier.resolved()))"
      )
    #endif
  }
}
