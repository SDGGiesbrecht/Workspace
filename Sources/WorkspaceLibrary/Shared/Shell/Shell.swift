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

func bash(_ arguments: [String], silent: Bool = false, dropOutput: Bool = false) -> (succeeded: Bool, output: String?, exitCode: ExitCode) {

    defer {
        Repository.resetCache()
    }

    do {
        let output = try Shell.default.run(command: arguments, silently: silent)
        return (succeeded: true, output: output, exitCode: ExitCode.succeeded)
    } catch let error as Shell.Error {
        return (succeeded: false, output: error.output + error.description, exitCode: ExitCode(error.code))
    } catch {
        unreachableLocation()
    }

    var argumentsString = arguments.map({ (string: String) -> String in

        if string.contains(" ") {
            return "\u{22}" + string + "\u{22}"
        } else {
            return string
        }
    }).joined(separator: " ")

    if ¬silent {
        print("$ " + argumentsString)
    }

    let process = Process()
    process.launchPath = "/bin/bash"

    let standardOutput = Pipe()
    if ¬dropOutput {
        process.standardOutput = standardOutput
    }

    if ¬silent ∧ ¬dropOutput ∧ ¬Environment.isInXcode /* Fails in Xcode’s container. */ {
        argumentsString = "set \u{2D}o pipefail; " + argumentsString + " | tee /dev/tty"
    }
    process.arguments = ["\u{2D}c", argumentsString]

    process.launch()

    var data = Data()
    while process.isRunning {
        if ¬dropOutput {
            data.append(standardOutput.fileHandleForReading.availableData)
        }
    }

    if ¬dropOutput {
        data.append(standardOutput.fileHandleForReading.readDataToEndOfFile())
    }

    let output: String?
    if dropOutput {
        output = nil
    } else if let utf8 = String(data: data, encoding: String.Encoding.utf8) {
        output = utf8
    } else if let latin1 = String(data: data, encoding: String.Encoding.isoLatin1) {
        output = latin1
    } else {
        fatalError(message: [
            "Cannot identify string encoding:",
            "",
            "\(data)"
            ])
    }

    guard process.terminationStatus == ExitCode.succeeded else {
        return (succeeded: false, output: output, exitCode: process.terminationStatus)
    }

    return (succeeded: true, output: output, exitCode: process.terminationStatus)
}

@discardableResult func requireBash(_ arguments: [String], silent: Bool = false) -> String {
    let result = bash(arguments, silent: silent)
    if result.succeeded {
        if let output = result.output {
            return output
        } else {
            return ""
        }
    } else {
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
    for line in versions.lines {
        if let tagPrefixRange = line.range(of: "refs/tags/") {
            let tag = line.substring(from: tagPrefixRange.upperBound)
            if let version = Version(tag) ?? Version(String(tag.characters.dropFirst())) {
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

    if let systemVersionLine = (try? Shell.default.run(command: versionCheck, silently: true))?.linesArray.first,
        let systemVersionStart = systemVersionLine.range(of: CharacterSet.decimalDigits)?.lowerBound,
        let systemVersion = Version(systemVersionLine.substring(from: systemVersionStart)),
        systemVersion == requiredVersion.version {

        do {
            let output = try Shell.default.run(command: command)
            return (succeeded: true, output: output, exitCode: ExitCode.succeeded)
        } catch let error as Shell.Error {
            return (succeeded: false, output: error.output + error.description, exitCode: ExitCode(error.code))
        } catch {
            unreachableLocation()
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
