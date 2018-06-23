/*
 ContinuousIntegrationJob+Tests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSContinuousIntegration

extension ContinuousIntegrationJob {

    public var englishTargetOperatingSystemName: StrictString {
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
    public var englishTargetBuildSystemName: StrictString? {
        switch self {
        case .macOSSwiftPackageManager:
            return "the Swift Package Manager"
        case .macOSXcode:
            return "Xcode"
        case .linux, .iOS, .watchOS, .tvOS, .miscellaneous, .documentation, .deployment:
            return nil
        }
    }
}
