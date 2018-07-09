/*
 OperatingSystem.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSLocalizations

/// An operating system.
public enum OperatingSystem : String, Codable {

    // MARK: - Cases

    /// macOS.
    case macOS

    /// Linux.
    case linux

    /// iOS
    case iOS

    /// watchOS
    case watchOS

    /// tvOS
    case tvOS

    // #workaround(jazzy --version 0.9.3, Allow automatic inheritance when documentation supports it.)
    /// An array containing every case of the enumeration.
    public static let cases: [OperatingSystem] = [
        .macOS,
        .linux,
        .iOS,
        .watchOS,
        .tvOS
    ]

    // MARK: - Properties

    internal func isolatedName(for localization: ContentLocalization) -> StrictString {
        switch self {
        case .macOS:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "macOS"
            }
        case .linux:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Linux"
            }
        case .iOS:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "iOS"
            }
        case .watchOS:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "watchOS"
            }
        case .tvOS:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "tvOS"
            }
        }
    }
}
