/*
 ContinuousIntegrationJob + Testing.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGCollections
  import SDGText
  import SDGLocalization

  import SDGXcode

  extension ContinuousIntegrationJob {

    // MARK: - Sets

    internal static let coverageJobs: Set<ContinuousIntegrationJob> = [
      .macOS,
      .ubuntu,
      .tvOS,
      .iOS,
      .amazonLinux,
      .watchOS,
    ]
    internal static let testJobs: Set<ContinuousIntegrationJob> =
      coverageJobs ∪ []
    internal static let buildJobs: Set<ContinuousIntegrationJob> =
      testJobs ∪ []

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
      case .ubuntu:  // @exempt(from: tests)  Unreachable from macOS.
        return "Ubuntu"  // @exempt(from: tests)
      case .tvOS:  // @exempt(from: tests) Unreachable from Linux.
        return "tvOS"
      case .iOS:  // @exempt(from: tests) Unreachable from Linux.
        return "iOS"
      case .android:  // @exempt(from: tests) Unreachable from Linux.
        return "Android"
      case .amazonLinux:  // @exempt(from: tests)  Unreachable from macOS.
        return "Amazon Linux"
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
      case .ubuntu:  // @exempt(from: tests)
        return "Ubuntu"  // @exempt(from: tests) Unreachable from macOS.
      case .tvOS:  // @exempt(from: tests) Unreachable from Linux.
        return "tvOS"
      case .iOS:  // @exempt(from: tests) Unreachable from Linux.
        return "iOS"
      case .android:  // @exempt(from: tests) Unreachable from Linux.
        return "Android"
      case .watchOS:  // @exempt(from: tests) Unreachable from Linux.
        return "watchOS"
      case .amazonLinux:  // @exempt(from: tests)  Unreachable from macOS.
        return "Amazon Linux"
      case .miscellaneous, .deployment:
        unreachable()
      }
    }

    // MARK: - SDK

    internal var buildPlatform: Xcode.Platform {
      switch self {  // @exempt(from: tests) Unreachable from Linux.
      case .macOS,  // @exempt(from: tests)
        .windows,
        .web,
        .ubuntu,
        .android,
        .amazonLinux,
        .miscellaneous,
        .deployment:
        unreachable()
      case .tvOS:
        return .tvOS(simulator: false)
      case .iOS:
        return .iOS(simulator: false)
      case .watchOS:
        return .watchOS(simulator: false)
      }
    }

    internal var testPlatform: Xcode.Platform {
      switch self {  // @exempt(from: tests) Unreachable from Linux.
      case .macOS, .windows, .web, .ubuntu, .android, .amazonLinux, .miscellaneous,
        .deployment:
        unreachable()
      case .tvOS:  // @exempt(from: tests)
        // @exempt(from: tests) Tested separately.
        return .tvOS(simulator: true)
      case .iOS:  // @exempt(from: tests)
        // @exempt(from: tests) Tested separately.
        return .iOS(simulator: true)
      case .watchOS:
        return .watchOS(simulator: true)
      }
    }
  }
#endif
