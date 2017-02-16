/*
 OperatingSystem.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

enum OperatingSystem: String, CustomStringConvertible {

    // MARK: - Cases

    case macOS = "macOS"
    case linux = "Linux"
    case iOS = "iOS"
    case watchOS = "watchOS"
    case tvOS = "tvOS"

    static let all: [OperatingSystem] = [
        .macOS,
        .linux,
        .iOS,
        .watchOS,
        .tvOS,
        ]

    var buildsOnMacOS: Bool {
        switch self {
        case .macOS, .iOS, .watchOS, .tvOS:
            return true
        case .linux:
            return false
        }
    }

    var isSupportedByProject: Bool {
        switch self {
        case .macOS:
            return Configuration.supportMacOS
        case .linux:
            return Configuration.supportLinux
        case .iOS:
            return Configuration.supportIOS
        case .watchOS:
            return Configuration.supportWatchOS
        case .tvOS:
            return Configuration.supportTVOS
        }
    }

    // MARK: - CustomStringConvertible

    var description: String {
        return rawValue
    }
}
