/*
 OperatingSystem.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLine

enum OperatingSystem : Int, IterableEnumeration {

    // MARK: - Static Properties

    static var current: OperatingSystem {
        #if os(macOS)
            return .macOS
        #elseif os(Linux)
            return .linux
        #endif
    }

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

    // MARK: - Name

    var isolatedName: UserFacingText<ContentLocalization> {
        switch self {
        case .macOS:
            return UserFacingText({ (localization) in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance:
                    return "macOS"
                case .ελληνικάΕλλάδα:
                    return "Μακ‐Ο‐Ες"
                case .עברית־ישראל:
                    return "מק־או־אס"
                }
            })
        case .linux:
            return UserFacingText({ (localization) in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance:
                    return "Linux"
                case .ελληνικάΕλλάδα:
                    return "Λίνουξ"
                case .עברית־ישראל:
                    return "לינוקס"
                }
            })
        case .iOS:
            return UserFacingText({ (localization) in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance:
                    return "iOS"
                case .ελληνικάΕλλάδα:
                    return "Αι‐Ο‐Ες"
                case .עברית־ישראל:
                    return "איי־או־אס"
                }
            })
        case .watchOS:
            return UserFacingText({ (localization) in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance:
                    return "watchOS"
                case .ελληνικάΕλλάδα:
                    return "Ουατσ‐Ο‐Ες"
                case .עברית־ישראל:
                    return "וץ׳־או־אס"
                }
            })
        case .tvOS:
            return UserFacingText({ (localization) in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada, .deutschDeutschland, .françaisFrance:
                    return "tvOS"
                case .ελληνικάΕλλάδα:
                    return "Τι‐Βι‐Ο‐Ες"
                case .עברית־ישראל:
                    return "טי־וי־או־אס"
                }
            })
        }
    }
}
