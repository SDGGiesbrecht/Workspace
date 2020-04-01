/*
 ContinuousIntegrationJob.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
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
    .tvOS,
    .iOS,
  ]
  public static let testJobs: Set<ContinuousIntegrationJob> = coverageJobs
  public static let buildJobs: Set<ContinuousIntegrationJob> =
    testJobs ∪ [
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
    case .windows:  // @exempt(from: tests) Unreachable from Linux.
      return "Windows"
    case .web:  // @exempt(from: tests) Unreachable from Linux.
      return "Web"
    case .linux:  // @exempt(from: tests)
      return "Linux"  // @exempt(from: tests) Unreachable from macOS.
    case .tvOS:  // @exempt(from: tests) Unreachable from Linux.
      return "tvOS"
    case .iOS:  // @exempt(from: tests) Unreachable from Linux.
      return "iOS"
    case .android:  // @exempt(from: tests) Unreachable from Linux.
      return "Android"
    case .watchOS:  // @exempt(from: tests) Unreachable from Linux.
      return "watchOS"
    case .miscellaneous, .deployment:
      unreachable()
    }
  }
  private var deutscherZielsystemname: StrictString {
    switch self {
    case .macOS:  // @exempt(from: tests) Unreachable from Linux.
      return "macOS"
    case .windows:  // @exempt(from: tests) Unreachable from Linux.
      return "Windows"
    case .web:  // @exempt(from: tests) Unreachable from Linux.
      return "Netz"
    case .linux:  // @exempt(from: tests)
      return "Linux"  // @exempt(from: tests) Unreachable from macOS.
    case .tvOS:  // @exempt(from: tests) Unreachable from Linux.
      return "tvOS"
    case .iOS:  // @exempt(from: tests) Unreachable from Linux.
      return "iOS"
    case .android:  // @exempt(from: tests) Unreachable from Linux.
      return "Android"
    case .watchOS:  // @exempt(from: tests) Unreachable from Linux.
      return "watchOS"
    case .miscellaneous, .deployment:
      unreachable()
    }
  }

  // MARK: - SDK

  internal var buildSDK: Xcode.SDK {
    switch self {  // @exempt(from: tests) Unreachable from Linux.
    case .macOS, .windows, .web, .linux, .android, .miscellaneous, .deployment:
      unreachable()
    case .tvOS:
      return .tvOS(simulator: false)
    case .iOS:
      return .iOS(simulator: false)
    case .watchOS:
      return .watchOS
    }
  }

  internal var testSDK: Xcode.SDK {
    switch self {  // @exempt(from: tests) Unreachable from Linux.
    case .macOS, .windows, .web, .linux, .android, .watchOS, .miscellaneous, .deployment:
      unreachable()
    case .tvOS:  // @exempt(from: tests)
      // @exempt(from: tests) Tested separately.
      return .tvOS(simulator: true)
    case .iOS:  // @exempt(from: tests)
      // @exempt(from: tests) Tested separately.
      return .iOS(simulator: true)
    }
  }
}
