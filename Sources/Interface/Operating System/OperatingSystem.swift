/*
 OperatingSystem.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

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

    var isolatedName: UserFacing<StrictString, ContentLocalization> {
        switch self {
        case .macOS:
            return UserFacing({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "macOS"
                }
            })
        case .linux:
            return UserFacing({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Linux"
                }
            })
        case .iOS:
            return UserFacing({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "iOS"
                }
            })
        case .watchOS:
            return UserFacing({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "watchOS"
                }
            })
        case .tvOS:
            return UserFacing({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "tvOS"
                }
            })
        }
    }
}
