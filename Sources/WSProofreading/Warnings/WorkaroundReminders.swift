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
            return "Workaround"
        }
    })

    internal static func message(for details: StrictString, in project: PackageRepository, output: Command.Output) throws -> UserFacing<StrictString, InterfaceLocalization>? {

        if let versionCheck = details.scalars.firstNestingLevel(startingWith: "(".scalars, endingWith: ")".scalars) {
            var parameters = versionCheck.contents.contents.components(separatedBy: " ".scalars)
            if ¬parameters.isEmpty,
                let problemVersion = Version(String(StrictString(parameters.removeLast().contents))) {

                let dependency = parameters.map({ StrictString($0.contents) }).joined(separator: " ")

                if dependency == "Swift" {
                    var newDetails = details
                    let script: StrictString = "swift \u{2D}\u{2D}version"
                    newDetails.replaceSubrange(versionCheck.contents.range, with: "\(script) \(problemVersion.string())".scalars)
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

        return UserFacing({ localization in
            let label: StrictString
            switch localization {
            case .englishCanada:
                label = "Workaround: "
            }
            return label + details
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
            }) // [_Exempt from Test Coverage_] Meaningless coverage region.
        }
    }
}
