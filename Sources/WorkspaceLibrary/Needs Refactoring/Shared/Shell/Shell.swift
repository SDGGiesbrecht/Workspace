/*
 Shell.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

@discardableResult func requireBash(_ arguments: [String], silent: Bool = false) -> String {

    defer { Repository.resetCache() }

    do {
        return try Shell.default.run(command: arguments, silently: silent)
    } catch {
        fatalError(message: [
            "Command failed:",
            "",
            arguments.joined(separator: " "),
            "",
            "See details above."
            ])
    }
}

private var missingTools: Set<String> = []
func runThirdPartyTool(name: String, repositoryURL: String, versionCheck: [String], continuousIntegrationSetUp: [[String]], command: [String], updateInstructions: [String], dropOutput: Bool = false) -> (succeeded: Bool, output: String?, exitCode: ExitCode)? {

    defer { Repository.resetCache() }

    let versions = requireBash(["git", "ls\u{2D}remote", "\u{2D}\u{2D}tags", repositoryURL], silent: true)
    var newest: (tag: String, version: Version)? = nil
    for line in versions.lines.map({ String($0.line) }) {
        if let tagPrefixRange = line.range(of: "refs/tags/") {
            let tag = String(line[tagPrefixRange.upperBound...])
            if let version = Version(tag) ?? Version(String(tag.clusters.dropFirst())) {
                if let last = newest {
                    if version > last.version {
                        newest = (tag: tag, version: version)
                    }
                } else {
                    newest = (tag: tag, version: version)
                }
            }
        }
    }

    guard let requiredVersion = newest else {
        fatalError(message: [
            "Failed to determine latest \(name) version."
            ])
    }

    if Environment.isInContinuousIntegration {
        for command in continuousIntegrationSetUp {
            requireBash(command)
        }
    }

    if let systemVersionLine = (try? Shell.default.run(command: versionCheck, silently: true))?.lines.first?.line,
        let systemVersionStart = String(systemVersionLine).scalars.firstMatch(for: ConditionalPattern(condition: { $0 ∈ CharacterSet.decimalDigits }))?.range.lowerBound.cluster(in: String(systemVersionLine).clusters),
        let systemVersion = Version(String(String(systemVersionLine)[systemVersionStart...])),
        systemVersion == requiredVersion.version {

        do {
            let output = try Shell.default.run(command: command)
            return (succeeded: true, output: output, exitCode: ExitCode.succeeded)
        } catch let error as Shell.Error {
            return (succeeded: false, output: error.output + error.description, exitCode: ExitCode(error.code))
        } catch {
            unreachable()
        }

    } else {

        if Environment.isInContinuousIntegration {
            fatalError(message: ["\(name) \(requiredVersion.version) could not be found."])
        } else {

            if name ∉ missingTools {
                missingTools.insert(name)

                printWarning([
                    "Some tests were skipped because \(name) \(requiredVersion.version) could not be found.",
                    repositoryURL,
                    join(lines: updateInstructions)
                    ])
            }

            return nil
        }
    }
}
