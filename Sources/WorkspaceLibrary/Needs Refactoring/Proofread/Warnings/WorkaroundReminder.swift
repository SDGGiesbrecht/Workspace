/*
 WorkaroundReminder.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

struct WorkaroundReminder : Warning {

    static let name = "Workaround Reminder"
    static let trigger = "Workaround"
    static let noticeOnly = true

    static var dependencyList: [String: Version]?

    static func message(forDetails details: String) -> String? {
        if let versionCheckRange = details.scalars.firstNestingLevel(startingWith: "(".scalars, endingWith: ")".scalars)?.contents.range.clusters(in: details.clusters) {
            let versionCheck = String(details[versionCheckRange])
            var parameters = versionCheck.components(separatedBy: " ")
            if ¬parameters.isEmpty {
                let problemVersionString = parameters.removeLast()
                if let problemVersion = Version(problemVersionString) {

                    let dependencies = cached(in: &dependencyList) {
                        // [_Workaround: Disabled dependency version detection. Needs to be updated for Swift 3.1_]
                        return [:]
                    }

                    let dependency = parameters.joined(separator: " ")
                    let swift = "Swift"
                    if dependency == swift {
                        var newDetails = details
                        let script = "swift \u{2D}\u{2D}version"
                        newDetails.replaceSubrange(versionCheckRange, with: "\(script) \(problemVersion.string)")
                            return message(forDetails: newDetails)?.replacingOccurrences(of: script, with: swift)
                    }
                    if let currentVersion = dependencies[dependency] {
                        // Package dependency

                        if currentVersion ≤ problemVersion {
                            return nil
                        }
                    } else {
                        // Not a package dependency

                        if let currentVersionString = try? Shell.default.run(command: parameters, silently: true),
                            let currentVersion = Version(firstIn: currentVersionString) {

                            dependencyList?[dependency] = currentVersion // Cache shell result

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
