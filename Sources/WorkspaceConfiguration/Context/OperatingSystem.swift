/*
 OperatingSystem.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow

import WSLocalizations

/// An operating system.
public enum OperatingSystem : String, Codable, CaseIterable {

    // MARK: - Cases

    /// macOS.
    case macOS

    /// Linux.
    case linux

    /// iOS.
    case iOS

    /// watchOS.
    case watchOS

    /// tvOS.
    case tvOS

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
