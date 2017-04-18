/*
 WorkaroundReminder.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

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

                    let dependencies = cached(in: &dependencyList) {
                        // [_Workaround: Disabled dependency version detection. Needs to be updated for Swift 3.1_]
                        return [:]
                    }

                    let dependency = parameters.joined(separator: " ")
                    let swift = "Swift"
                    if dependency == swift {
                        var newDetails = details
                        let script = "swift \u{2D}\u{2D}version"
                        newDetails.replaceSubrange(versionCheckRange, with: "\(script) \(problemVersion)")
                            return message(forDetails: newDetails)?.replacingOccurrences(of: script, with: swift)
                    }
                    if let currentVersion = dependencies[dependency] {
                        // Package dependency

                        if currentVersion ≤ problemVersion {
                            return nil
                        }
                    } else {
                        // Not a package dependency

                        if var currentVersionString = bash(parameters, silent: true).output {

                            let versionCharacters = CharacterSet(charactersIn: "0123456789.")
                            while let first = currentVersionString.unicodeScalars.first,
                                ¬versionCharacters.contains(first) {
                                currentVersionString.unicodeScalars.removeFirst()
                            }
                            var end = currentVersionString.startIndex
                            currentVersionString.advance(&end, past: versionCharacters)
                            currentVersionString = currentVersionString.substring(to: end)

                            if let currentVersion = Version(currentVersionString) {

                                dependencyList?[dependency] = currentVersion // Cache shell result

                                if currentVersion ≤ problemVersion {
                                    return nil
                                }
                            }
                        }
                    }
                }
            }
        }
        return "Workaround: " + details
    }
}
