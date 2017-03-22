/*
 Environment.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic

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

    // Job Factoring

    private static func shouldDoJobSet(requiredEnvironments: Set<OperatingSystem>, isConfigured: Bool, jobKey: String) -> Bool {

        let isPossible = requiredEnvironments.contains(operatingSystem)
        let shouldRunSomewhere = isConfigured

        if isPossible ∧ shouldRunSomewhere {

            // Decide where

            let isLocal = ¬Environment.isInContinuousIntegration
            let isCorrectJob = Environment.environmentVariable(ContinuousIntegration.jobKey) == jobKey

            return isLocal ∨ isCorrectJob

        } else {
            return false
        }
    }

    static let shouldDoMacOSJobs = shouldDoJobSet(requiredEnvironments: [.macOS], isConfigured: Configuration.supportMacOS, jobKey: ContinuousIntegration.macOSJob)

    static let shouldDoLinuxJobs = shouldDoJobSet(requiredEnvironments: [.linux], isConfigured: Configuration.supportLinux, jobKey: ContinuousIntegration.linuxJob)

    static let shouldDoIOSJobs = shouldDoJobSet(requiredEnvironments: [.macOS], isConfigured: Configuration.supportIOS, jobKey: ContinuousIntegration.iOSJob)

    static let shouldDoWatchOSJobs = shouldDoJobSet(requiredEnvironments: [.macOS], isConfigured: Configuration.supportWatchOS, jobKey: ContinuousIntegration.watchOSJob)

    static let shouldDoTVOSJobs = shouldDoJobSet(requiredEnvironments: [.macOS], isConfigured: Configuration.supportTVOS, jobKey: ContinuousIntegration.tvOSJob)

    static let shouldDoMiscellaneousJobs = shouldDoJobSet(requiredEnvironments: ContinuousIntegration.operatingSystemsForMiscellaneousJobs, isConfigured: true, jobKey: ContinuousIntegration.miscellaneousJob)
}
