/*
 ProcessInfo.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(Swift 5.2.4, Web lacks Foundation.)
#if !os(WASI)
  import Foundation

  import SDGLogic

  extension ProcessInfo {

    internal static let isInContinuousIntegration =
      ProcessInfo.processInfo.environment["CONTINUOUS_INTEGRATION"] ≠ nil
      ∨ isInGitHubAction  // @exempt(from: tests)

    internal static let isInGitHubAction =
      ProcessInfo.processInfo.environment["GITHUB_ACTIONS"] ≠ nil

    internal static let isPullRequest =
      ProcessInfo.processInfo.environment["PULL_REQUEST"] ≠ nil
      ∨ ProcessInfo.processInfo.environment["GITHUB_EVENT_NAME"] == "pull_request"
  }
#endif