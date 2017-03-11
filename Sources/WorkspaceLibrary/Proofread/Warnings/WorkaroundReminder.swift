/*
 WorkaroundReminder.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCaching

import SDGLogic
import SDGMathematics

struct WorkaroundReminder : Warning {

    static let name = "Workaround Reminder"
    static let trigger = "Workaround"
    static let noticeOnly = true

    static var dependencyList: [String: Version]?

    static func message(forDetails details: String) -> String? {
        if let versionCheckRange = details.rangeOfContents(of: ("(", ")")) {
            let versionCheck = details.substring(with: versionCheckRange)
            var parameters = versionCheck.components(separatedBy: " ")
            if ¬parameters.isEmpty {
                let problemVersionString = parameters.removeLast()
                if let problemVersion = Version(problemVersionString) {

                    let dependencies = cachedResult(cache: &dependencyList) {
                        return DependencyGraph.loadDependencyList()
                    }

                    if let currentVersion = dependencies[parameters.joined(separator: " ")] {
                        // Package dependency

                        if currentVersion ≤ problemVersion {
                            return nil
                        }
                    } else {
                        // Not a package dependency

                        if let currentVersionString = bash(parameters).output,
                            let currentVersion = Version(currentVersionString) {

                            if currentVersion ≤ problemVersion {
                                return nil
                            }
                        }
                    }
                }
            }
        }
        return "Workaround: " + details
    }
}
