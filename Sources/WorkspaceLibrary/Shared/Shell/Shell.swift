/*
 Shell.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic

func bash(_ arguments: [String], silent: Bool = false) -> (succeeded: Bool, output: String?, exitCode: ExitCode) {
    
    defer {
        Repository.resetCache()
    }
    
    var argumentsString = arguments.map({
        (string: String) -> String in
        
        if string.contains(" ") {
            return "\u{22}" + string + "\u{22}"
        } else {
            return string
        }
    }).joined(separator: " ")
    
    let process = Process()
    process.launchPath = "/bin/bash"
    
    let standardOutput = Pipe()
    process.standardOutput = standardOutput
    
    if ¬silent ∧ ¬Environment.isInXcode /* Fails in Xcode’s container. */ {
        argumentsString = "set -o pipefail; " + argumentsString + " | tee /dev/tty"
    }
    process.arguments = ["-c", argumentsString]
    
    process.launch()
    process.waitUntilExit()
    
    let data = standardOutput.fileHandleForReading.readDataToEndOfFile()
    let output: String
    if let utf8 = String(data: data, encoding: String.Encoding.utf8) {
        output = utf8
    } else if let latin1 = String(data: data, encoding: String.Encoding.isoLatin1) {
        output = latin1
    } else {
        fatalError(message: [
            "Cannot identify string encoding:",
            "",
            "\(data)",
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
            "See details above.",
            ])
    }
}
