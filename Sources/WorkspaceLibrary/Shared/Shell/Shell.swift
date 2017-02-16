/*
 Shell.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic

func bash(_ arguments: [String], silent: Bool = false, dropOutput: Bool = false) -> (succeeded: Bool, output: String?, exitCode: ExitCode) {

    defer {
        Repository.resetCache()
    }

    var argumentsString = arguments.map({ (string: String) -> String in

        if string.contains(" ") {
            return "\u{22}" + string + "\u{22}"
        } else {
            return string
        }
    }).joined(separator: " ")

    let process = Process()
    process.launchPath = "/bin/bash"

    let standardOutput = Pipe()
    if ¬dropOutput {
        process.standardOutput = standardOutput
    }

    if ¬silent ∧ ¬dropOutput ∧ ¬Environment.isInXcode /* Fails in Xcode’s container. */ {
        argumentsString = "set -o pipefail; " + argumentsString + " | tee /dev/tty"
    }
    process.arguments = ["-c", argumentsString]

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

func runThirdPartyTool(name: String, repositoryURL: String, tagPrefix: String?, versionCheck: [String], continuousIntegrationSetUp: [[String]], command: [String], updateInstructions: [String], dropOutput: Bool = false) -> (succeeded: Bool, output: String?, exitCode: ExitCode)? {

    let versions = requireBash(["git", "ls-remote", "--tags", repositoryURL], silent: true)
    var newest: (tag: String, version: Version)? = nil
    for line in versions.lines {
        var tagMarker = "refs/tags/"
        if let prefix = tagPrefix {
            tagMarker += prefix
        }
        if let tagPrefixRange = line.range(of: "refs/tags/") {
            let tag = line.substring(from: tagPrefixRange.upperBound)
            if let version = Version(tag) {
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

    if let systemVersionString = bash(versionCheck, silent: true).output?.linesArray.first, let systemVersion = Version(systemVersionString), systemVersion == requiredVersion.version {

        return bash(command, dropOutput: dropOutput)

    } else {

        print(["System: \(bash(versionCheck, silent: true).output)"])

        if Environment.isInContinuousIntegration {
            fatalError(message: ["\(name) \(requiredVersion.version) could not be found."])
        } else {

            printWarning([
                "Some tests were skipped because \(name) \(requiredVersion.version) could not be found.",
                repositoryURL,
                join(lines: updateInstructions)
                ])

            return nil
        }
    }

    return bash(command, dropOutput: dropOutput)
}
