/*
 OperatingSystem.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WorkspaceConfiguration

extension Platform {

    // MARK: - Static Properties

    public static var current: Platform {
        #if os(macOS)
        return .macOS
        #elseif os(Linux)
        return .linux
        #endif
    }

    public var supportsObjectiveC: Bool {
        switch self {
        case .macOS, .iOS, .watchOS, .tvOS:
            return true
        case .linux:
            return false
        }
    }
}
