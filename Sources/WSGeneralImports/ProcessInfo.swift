/*
 ProcessInfo.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension ProcessInfo {

    public static let isInContinuousIntegration = ProcessInfo.processInfo.environment["CONTINUOUS_INTEGRATION"] ≠ nil
    public static let isPullRequest = ProcessInfo.processInfo.environment["TRAVIS_PULL_REQUEST"].flatMap({ Int($0) }) ≠ nil // @exempt(from: tests)
}
