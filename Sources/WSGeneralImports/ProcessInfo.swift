/*
 ProcessInfo.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension ProcessInfo {

  public static let isInContinuousIntegration =
    ProcessInfo.processInfo.environment["CONTINUOUS_INTEGRATION"] ≠ nil
      ∨ isInGitHubAction  // @exempt(from: tests)

  public static let isInGitHubAction = ProcessInfo.processInfo.environment["GITHUB_ACTIONS"] ≠ nil

  public static let isPullRequest =
    ProcessInfo.processInfo.environment["PULL_REQUEST"] ≠ nil
      ∨ ProcessInfo.processInfo.environment["GITHUB_EVENT_NAME"] == "pull_request"
}
