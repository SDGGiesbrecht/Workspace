// Shell.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

import Foundation

import SDGLogic

func bashOutput(_ arguments: [String], silent: Bool = false) -> String? {
    var argumentsString = arguments.map({
        (string: String) -> String in
        
        if string.contains(" ") {
            return "\u{22}" + string + "\u{22}"
        } else {
            return string
        }
    }).joined(separator: " ")
    
    let process = Process()
    process.launchPath = "/bin/sh"
    
    let standardOutput = Pipe()
    process.standardOutput = standardOutput
    
    if ¬silent {
        argumentsString += " | tee /dev/tty"
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
    
    Repository.resetCache()
    
    guard process.terminationStatus == EXIT_SUCCESS else {
        return nil
    }
    
    return output
}

func bash(_ arguments: [String], silent: Bool = false) -> Bool {
    return bashOutput(arguments, silent: silent) ≠ nil
}

func requireBash(_ arguments: [String], silent: Bool = false) {
    if ¬bash(arguments, silent: silent) {
        commandFailed(arguments)
    }
}

func requireBashOutput(_ arguments: [String], silent: Bool = false) -> String {
    if let result = bashOutput(arguments, silent: silent) {
        return result
    } else {
        commandFailed(arguments)
    }
}

private func commandFailed(_ arguments: [String]) -> Never {
    fatalError(message: [
        "Command failed:",
        "",
        arguments.joined(separator: " "),
        "",
        "See details above.",
        ])
}
