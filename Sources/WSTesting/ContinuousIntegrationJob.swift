/*
 ContinuousIntegrationJob.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import WSGeneralImports
import WSContinuousIntegration

import SDGXcode

extension ContinuousIntegrationJob {

  // MARK: - Sets

  public static let coverageJobs: Set<ContinuousIntegrationJob> = [
    .macOS,
    .linux,
    .iOS,
    .tvOS
  ]
  public static let testJobs: Set<ContinuousIntegrationJob> = coverageJobs
  public static let buildJobs: Set<ContinuousIntegrationJob> = testJobs ∪ [
    .watchOS
  ]

  // MARK: - Description

  internal var englishName: StrictString {
    return englishTargetOperatingSystemName
  }
  internal var deutscherName: StrictString {
    return deutscherZielsystemname
  }

  private var englishTargetOperatingSystemName: StrictString {
    switch self {
    case .macOS:  // @exempt(from: tests) Unreachable from Linux.
      return "macOS"
    case .linux:  // @exempt(from: tests)
      return "Linux"  // @exempt(from: tests) Unreachable from macOS.
    case .iOS:  // @exempt(from: tests) Unreachable from Linux.
      return "iOS"
    case .watchOS:  // @exempt(from: tests) Unreachable from Linux.
      return "watchOS"
    case .tvOS:  // @exempt(from: tests) Unreachable from Linux.
      return "tvOS"
    case .windows:  // @exempt(from: tests) Unreachable from Linux.
      return "Windows"
    case .miscellaneous, .deployment:
      unreachable()
    }
  }
  private var deutscherZielsystemname: StrictString {
    switch self {
    case .macOS:  // @exempt(from: tests) Unreachable from Linux.
      return "macOS"
    case .linux:  // @exempt(from: tests)
      return "Linux"  // @exempt(from: tests) Unreachable from macOS.
    case .iOS:  // @exempt(from: tests) Unreachable from Linux.
      return "iOS"
    case .watchOS:  // @exempt(from: tests) Unreachable from Linux.
      return "watchOS"
    case .tvOS:  // @exempt(from: tests) Unreachable from Linux.
      return "tvOS"
    case .windows:  // @exempt(from: tests) Unreachable from Linux.
      return "Windows"
    case .miscellaneous, .deployment:
      unreachable()
    }
  }

  // MARK: - SDK

  internal var buildSDK: Xcode.SDK {
    switch self {  // @exempt(from: tests) Unreachable from Linux.
    case .iOS:
      return .iOS(simulator: false)
    case .watchOS:
      return .watchOS
    case .tvOS:
      return .tvOS(simulator: false)
    case .macOS, .linux, .windows, .miscellaneous, .deployment:
      unreachable()
    }
  }

  internal var testSDK: Xcode.SDK {
    switch self {  // @exempt(from: tests) Unreachable from Linux.
    case .iOS:  // @exempt(from: tests)
      // @exempt(from: tests) Tested separately.
      return .iOS(simulator: true)
    case .tvOS:  // @exempt(from: tests)
      // @exempt(from: tests) Tested separately.
      return .tvOS(simulator: true)
    case .macOS, .linux, .watchOS, .windows, .miscellaneous, .deployment:
      unreachable()
    }
  }
}
