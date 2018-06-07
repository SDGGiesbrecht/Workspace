/*
 Environment.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import GeneralImports

import Project

struct Environment {

    // MARK: - Properties

    static func environmentVariable(_ name: String) -> String? {
        return ProcessInfo.processInfo.environment[name]
    }

    private static func requiredEnvironmentVariable(_ name: String) -> String {
        guard let result = environmentVariable(name) else {
            fatalError(message: [
                "Environment variable missing: \(name)"
                ])
        }
        return result
    }

    #if os(macOS)
        static let operatingSystem: OperatingSystem = .macOS
    #elseif os(Linux)
        static let operatingSystem: OperatingSystem = .linux
    #endif

    static let isInXcode: Bool = environmentVariable("__XCODE_BUILT_PRODUCTS_DIR_PATHS") ≠ nil

    static let isInContinuousIntegration: Bool = environmentVariable("CONTINUOUS_INTEGRATION") ≠ nil
}
