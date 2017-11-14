/*
 Output.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone

func fatalError(message: [String]) -> Never {
    fail(message: message)
}

// MARK: - Generic Exiting

func succeed(message: [String]) {
    outputWarnings()
    print(message, in: .green, spaced: true)
}

func fail(message: [String]) -> Never {
    outputWarnings()
    print(message, in: .red, spaced: true)
    exit(ExitCode.failed)
}

func failTests(message: [String]) -> Never {
    outputWarnings()
    print(message, in: .red, spaced: true)
    exit(ExitCode.testsFailed)
}

// MARK: - Generic Printing

private var warnings: [[String]] = []
func printWarning(_ message: [String]) {
    warnings.append(message)

}
private func outputWarnings() {

    if let fileTypeWarning = FileType.unsupportedTypesWarning {
        printWarning(fileTypeWarning)
    }

    for warning in warnings {
        print(warning, in: .yellow, spaced: true)
    }
}

func printValidationFailureDescription(_ message: [String]) {
    print(message, in: .red, spaced: true)
}

private func printError(_ message: [String]) {
    print(message, in: .red, spaced: true)
}

func print(_ message: [String]) {
    print(message, in: nil)
}

func print(_ message: [String], in colour: OutputColour?, spaced: Bool = false) {
    var output = join(lines: message)
    if let textColour = colour {
        output = "\(textColour.start)\(output)\(OutputColour.end)"
    }
    if spaced {
        output = "\n" + output + "\n"
    }
    print(output)
}
