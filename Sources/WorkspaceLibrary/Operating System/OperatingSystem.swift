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

enum OperatingSystem : Int, IterableEnumeration {

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

    var isolatedName: UserFacingText<InterfaceLocalization, Void> { // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
        switch self {
        case .macOS: // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
            return UserFacingText({ (localization, _) in // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
                switch localization {
                case .englishCanada: // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
                    return "macOS"
                }
            })
        case .linux: // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
            return UserFacingText({ (localization, _) in // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
                switch localization {
                case .englishCanada: // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
                    return "Linux"
                }
            })
        case .iOS: // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
            return UserFacingText({ (localization, _) in // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
                switch localization {
                case .englishCanada: // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
                    return "iOS"
                }
            })
        case .watchOS: // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
            return UserFacingText({ (localization, _) in // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
                switch localization {
                case .englishCanada: // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
                    return "watchOS"
                }
            })
        case .tvOS: // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
            return UserFacingText({ (localization, _) in // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
                switch localization {
                case .englishCanada: // [_Exempt from Code Coverage_] [_Workaround: Until read‐me is testable._]
                    return "tvOS"
                }
            })
        }
    }
}
