/*
 WorkaroundReminders.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGMathematics
import WSGeneralImports

import SDGExternalProcess

import WSProject

internal struct WorkaroundReminders : Warning {

    internal static let noticeOnly = true

    internal static let name = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "workaroundReminders"
        }
    })

    internal static let trigger = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
        switch localization {
        case .englishCanada:
            return "workaround"
        }
    })

    internal static func message(for details: StrictString, in project: PackageRepository, output: Command.Output) throws -> UserFacing<StrictString, InterfaceLocalization>? {

        var description = details

        if let comma = details.scalars.firstMatch(for: ",".scalars) {
            description = StrictString(details.scalars[comma.range.upperBound...])

            let versionCheckRange = details.scalars.startIndex ..< comma.range.lowerBound
            var versionCheck = StrictString(details.scalars[versionCheckRange])
            versionCheck.trimMarginalWhitespace()

            var parameters = versionCheck.components(separatedBy: " ".scalars)
            if ¬parameters.isEmpty,
                let problemVersion = Version(String(StrictString(parameters.removeLast().contents))) {

                var dependency = parameters.map({ StrictString($0.contents) }).joined(separator: " ")
                dependency.trimMarginalWhitespace()

                if dependency == "Swift" {
                    var newDetails = details
                    let script: StrictString = "swift \u{2D}\u{2D}version"
                    newDetails.replaceSubrange(versionCheckRange, with: "\(script) \(problemVersion.string())".scalars)
                    if try message(for: newDetails, in: project, output: output) == nil {
                        return nil
                    }
                } else {
                    if let current = try currentVersion(of: dependency, for: project, output: output) {
                        if current ≤ problemVersion {
                            return nil
                        }
                    }
                }
            }
        }

        description.trimMarginalWhitespace()
        return UserFacing({ localization in
            let label: StrictString
            switch localization {
            case .englishCanada:
                label = "Workaround: "
            }
            return label + description
        })
    }

    private static var dependencyVersionCache: [StrictString: SDGSwift.Version?] = [:]
    private static func currentVersion(of dependency: StrictString, for project: PackageRepository, output: Command.Output) throws -> SDGSwift.Version? {
        if let dependency = try project.dependenciesByName()[String(dependency)],
            let version = dependency.manifest.version {
            return Version(version)
        } else {
            return cached(in: &dependencyVersionCache[dependency], {
                if let shellOutput = try? Shell.default.run(command: String(dependency).components(separatedBy: " ")),
                    let version = Version(firstIn: shellOutput) {
                    return version
                } else {
                    return nil
                }
            }) // @exempt(from: tests) Meaningless coverage region.
        }
    }
}
