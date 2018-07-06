/*
 ContinuousIntegrationJob.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

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
        .macOSXcode,
        .iOS,
        .tvOS
    ]
    public static let testJobs: Set<ContinuousIntegrationJob> = coverageJobs ∪ [
        .macOSSwiftPackageManager,
        .linux
    ]
    public static let buildJobs: Set<ContinuousIntegrationJob> = testJobs ∪ [
        .watchOS
    ]

    // MARK: - Description

    internal var englishName: StrictString {
        var result = englishTargetOperatingSystemName
        if let tool = englishTargetBuildSystemName {
            result += " with " + tool
        }
        return result
    }

    internal var englishTargetOperatingSystemName: StrictString {
        switch self {
        case .macOSSwiftPackageManager, .macOSXcode:
            return "macOS"
        case .linux:
            return "Linux" // [_Exempt from Test Coverage_] Unreachable from macOS.
        case .iOS:
            return "iOS"
        case .watchOS:
            return "watchOS"
        case .tvOS:
            return "tvOS"
        case .miscellaneous, .documentation, .deployment:
            unreachable()
        }
    }
    internal var englishTargetBuildSystemName: StrictString? {
        switch self {
        case .macOSSwiftPackageManager:
            return "the Swift Package Manager"
        case .macOSXcode:
            return "Xcode"
        case .linux, .iOS, .watchOS, .tvOS, .miscellaneous, .documentation, .deployment:
            return nil
        }
    }

    // MARK: - SDK

    internal var buildSDK: Xcode.SDK {
        switch self {
        case .macOSXcode:
            return .macOS
        case .iOS:
            return .iOS(simulator: false)
        case .watchOS:
            return .watchOS
        case .tvOS:
            return .tvOS(simulator: false)
        case .macOSSwiftPackageManager, .linux, .miscellaneous, .documentation, .deployment:
            unreachable()
        }
    }

    internal var testSDK: Xcode.SDK {
        switch self {
        case .macOSXcode:
            return .macOS
        case .iOS:
            // [_Exempt from Test Coverage_] Tested separately.
            return .iOS(simulator: true)
        case .tvOS:
            // [_Exempt from Test Coverage_] Tested separately.
            return .tvOS(simulator: true)
        case .macOSSwiftPackageManager, .linux, .watchOS, .miscellaneous, .documentation, .deployment:
            unreachable()
        }
    }
}
