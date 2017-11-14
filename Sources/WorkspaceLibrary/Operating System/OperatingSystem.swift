/*
 OperatingSystem.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

enum OperatingSystem: Int, IterableEnumeration {

    // MARK: - Cases

    case macOS
    case linux
    case iOS
    case watchOS
    case tvOS

    // MARK: - Properties

    var supportOption: Option {
        switch self {
        case .macOS:
            return .supportMacOS
        case .linux:
            return .supportLinux
        case .iOS:
            return .supportIOS
        case .watchOS:
            return .supportWatchOS
        case .tvOS:
            return .supportTVOS
        }
    }

    var developmentOperatingSystem: OperatingSystem {
        switch self {
        case .macOS, .iOS, .watchOS, .tvOS:
            return .macOS
        case .linux:
            return .linux
        }
    }
}
