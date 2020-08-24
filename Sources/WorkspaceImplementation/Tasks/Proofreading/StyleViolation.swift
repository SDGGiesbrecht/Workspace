/*
 StyleViolation.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import WorkspaceLocalizations

internal struct StyleViolation {

  // MARK: - Static Properties

  private static let exemptionMarkers: [StrictString] = {
    var result: Set<StrictString> = Set(
      InterfaceLocalization.allCases.map({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "@exempt(from: _)"
        case .deutschDeutschland:
          return "@ausnahme(zu: _)"
        }
      })
    )
    return result.map { $0.truncated(before: "_") }
  }()

  // MARK: - Initialization

  /// This initializer validates the violation, returning `nil` if it is under an exemption.
  internal init?(
    in file: TextFile,
    at location: Range<String.ScalarView.Index>,
    replacementSuggestion: StrictString? = nil,
    noticeOnly: Bool = false,
    ruleIdentifier: UserFacing<StrictString, InterfaceLocalization>,
    message: UserFacing<StrictString, InterfaceLocalization>
  ) {

    let fileLines = file.contents.lines
    let lineIndex = location.lowerBound.line(in: fileLines)
    let line = fileLines[lineIndex].line
    for exemptionMarker in StyleViolation.exemptionMarkers {
      if line.contains(exemptionMarker) {
        for localization in InterfaceLocalization.allCases {
          if line.contains(
            StrictString("\(exemptionMarker)\(ruleIdentifier.resolved(for: localization)))")
          ) {
            return nil
          }
        }
      }
    }

    self.file = file
    self.noticeOnly = noticeOnly
    self.ruleIdentifier = ruleIdentifier
    self.message = message

    // Normalize to cluster boundaries
    let clusterRange = location.clusters(in: file.contents.clusters)
    self.range = clusterRange
    if let scalarReplacement = replacementSuggestion {
      let modifiedScalarRange = clusterRange.scalars(in: file.contents.scalars)
      let clusterReplacement =
        StrictString(
          file.contents.scalars[modifiedScalarRange.lowerBound..<location.lowerBound]
        )
        + scalarReplacement
        + StrictString(
          file.contents.scalars[location.upperBound..<modifiedScalarRange.upperBound]
        )
      self.replacementSuggestion = clusterReplacement
    } else {
      self.replacementSuggestion = nil
    }
  }

  // MARK: - Properties

  internal let file: TextFile
  internal let range: Range<String.ClusterView.Index>
  internal let replacementSuggestion: StrictString?
  internal let ruleIdentifier: UserFacing<StrictString, InterfaceLocalization>
  internal let message: UserFacing<StrictString, InterfaceLocalization>
  internal let noticeOnly: Bool
}
