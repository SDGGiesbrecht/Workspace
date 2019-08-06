/*
 Platform.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow

import WSLocalizations

/// A platform.
public enum Platform : String, Codable, CaseIterable {

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

    public func _isolatedName(for localization: ContentLocalization) -> StrictString {
        switch self {
        case .macOS:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
                 .deutschDeutschland:
                return "macOS"
            }
        case .linux:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
                 .deutschDeutschland:
                return "Linux"
            }
        case .iOS:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
                 .deutschDeutschland:
                return "iOS"
            }
        case .watchOS:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
                 .deutschDeutschland:
                return "watchOS"
            }
        case .tvOS:
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada,
                 .deutschDeutschland:
                return "tvOS"
            }
        }
    }
}
