/*
 ContinuousIntegrationJob.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

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
        .macOSSwiftPackageManager,
        .macOSXcode,
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
        var result = englishTargetOperatingSystemName
        if let tool = englishTargetBuildSystemName {
            result += " with " + tool // @exempt(from: tests) Unreachable from Linux.
        }
        return result
    }

    internal var englishTargetOperatingSystemName: StrictString {
        switch self {
        case .macOSSwiftPackageManager, .macOSXcode: // @exempt(from: tests) Unreachable from Linux.
            return "macOS"
        case .linux:  // @exempt(from: tests)
            return "Linux" // @exempt(from: tests) Unreachable from macOS.
        case .iOS: // @exempt(from: tests) Unreachable from Linux.
            return "iOS"
        case .watchOS: // @exempt(from: tests) Unreachable from Linux.
            return "watchOS"
        case .tvOS: // @exempt(from: tests) Unreachable from Linux.
            return "tvOS"
        case .miscellaneous, .deployment:
            unreachable()
        }
    }
    internal var englishTargetBuildSystemName: StrictString? {
        switch self {
        case .macOSSwiftPackageManager: // @exempt(from: tests) Unreachable from Linux.
            return "the Swift Package Manager"
        case .macOSXcode: // @exempt(from: tests) Unreachable from Linux.
            return "Xcode"
        case .linux, .iOS, .watchOS, .tvOS, .miscellaneous, .deployment:
            return nil
        }
    }

    // MARK: - SDK

    internal var buildSDK: Xcode.SDK {
        switch self { // @exempt(from: tests) Unreachable from Linux.
        case .macOSXcode:
            return .macOS
        case .iOS:
            return .iOS(simulator: false)
        case .watchOS:
            return .watchOS
        case .tvOS:
            return .tvOS(simulator: false)
        case .macOSSwiftPackageManager, .linux, .miscellaneous, .deployment:
            unreachable()
        }
    }

    internal var testSDK: Xcode.SDK {
        switch self { // @exempt(from: tests) Unreachable from Linux.
        case .macOSXcode:
            return .macOS
        case .iOS: // @exempt(from: tests)
            // @exempt(from: tests) Tested separately.
            return .iOS(simulator: true)
        case .tvOS: // @exempt(from: tests)
            // @exempt(from: tests) Tested separately.
            return .tvOS(simulator: true)
        case .macOSSwiftPackageManager, .linux, .watchOS, .miscellaneous, .deployment:
            unreachable()
        }
    }
}
