/*
 PackageRepositoryTargetType.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

extension PackageRepository.Target {

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

        var key: StrictString { // [_Exempt from Test Coverage_] Deprecated.
            return StrictString(rawValue)
        }

        func isSupported(on operatingSystem: OperatingSystem) -> Bool {
            switch self {
            case .library: // [_Exempt from Test Coverage_] Deprecated.
                switch operatingSystem {
                case .macOS, .linux, .iOS, .watchOS, .tvOS: // [_Exempt from Test Coverage_] Deprecated.
                    return true
                }
            case .application: // [_Exempt from Test Coverage_] Deprecated.
                switch operatingSystem {
                case .macOS, .iOS, .tvOS: // [_Exempt from Test Coverage_] Deprecated.
                    return true
                case .linux, .watchOS: // [_Exempt from Test Coverage_] Deprecated.
                    return false
                }
            case .executable: // [_Exempt from Test Coverage_] Deprecated.
                switch operatingSystem {
                case .macOS, .linux: // [_Exempt from Test Coverage_] Deprecated.
                    return true
                case .iOS, .watchOS, .tvOS: // [_Exempt from Test Coverage_] Deprecated.
                    return false
                }
            }
        }
    }
}
