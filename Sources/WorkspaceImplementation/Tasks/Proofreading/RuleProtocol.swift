/*
 RuleProtocol.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import SDGText
import SDGLocalization

import SDGSwiftSource

import WorkspaceLocalizations

internal protocol RuleProtocol {
  static var identifier: UserFacing<StrictString, InterfaceLocalization> { get }
  static var noticeOnly: Bool { get }
}

extension RuleProtocol {

  // MARK: - Default Implementations

  internal static var noticeOnly: Bool {
    return false
  }

  // MARK: - Reporting

  internal static func reportViolation(
    in file: TextFile,
    at location: Range<String.ScalarView.Index>,
    replacementSuggestion: StrictString? = nil,
    message: UserFacing<StrictString, InterfaceLocalization>,
    status: ProofreadingStatus
  ) {

    if let notExempt = StyleViolation(
      in: file,
      at: location,
      replacementSuggestion: replacementSuggestion,
      noticeOnly: noticeOnly,
      ruleIdentifier: Self.identifier,
      message: message
    ) {
      status.report(violation: notExempt)
    }
  }

  internal static func reportViolation(
    in file: TextFile,
    at location: Range<String.ScalarOffset>,
    replacementSuggestion: StrictString? = nil,
    message: UserFacing<StrictString, InterfaceLocalization>,
    status: ProofreadingStatus
  ) {
    reportViolation(
      in: file,
      at: file.contents.indices(of: location),
      message: message,
      status: status
    )
  }
}
