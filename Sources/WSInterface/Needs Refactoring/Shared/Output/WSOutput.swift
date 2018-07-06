/*
 WSOutput.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSProject

func fatalError(message: [String], project: PackageRepository, output: Command.Output) -> Never {
    fail(message: message, project: project, output: output)
}

// MARK: - Generic Exiting

func fail(message: [String], project: PackageRepository, output: Command.Output) -> Never {
    try! output.listWarnings(for: project)
    print(message, in: .red, spaced: true)
    exit(ExitCode.failed)
}

// MARK: - Generic Printing

private var warnings: [[String]] = []
func printWarning(_ message: [String]) {
    warnings.append(message)

}

func print(_ message: [String], in colour: OutputColour?, spaced: Bool = false) {
    var output = message.joinedAsLines()
    if let textColour = colour {
        output = "\(textColour.start)\(output)\(OutputColour.end)"
    }
    if spaced {
        output = "\n" + output + "\n"
    }
    print(output)
}
