/*
 PackageRepositoryTargetType.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

extension PackageRepositoryTarget {

    enum TargetType : String {

        // MARK: - Initialization

        init?(key: StrictString) {
            self.init(rawValue: String(key))
        }

        // MARK: - Cases

        case library = "Library"
        case executable = "Executable"
        case application = "Application"

        static let cases: [TargetType] = [
            .library,
            .application,
            .executable
        ]

        // MARK: - Properties

        var key: StrictString {
            return StrictString(rawValue)
        }

        func isSupported(on operatingSystem: OperatingSystem) -> Bool {
            switch self {
            case .library:
                switch operatingSystem {
                case .macOS, .linux, .iOS, .watchOS, .tvOS:
                    return true
                }
            case .application:
                switch operatingSystem {
                case .macOS, .iOS, .tvOS:
                    return true
                case .linux, .watchOS:
                    return false
                }
            case .executable:
                switch operatingSystem {
                case .macOS, .linux:
                    return true
                case .iOS, .watchOS, .tvOS:
                    return false
                }
            }
        }
    }
}
