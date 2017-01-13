// Output.swift
//
// This source file is part of the Workspace open source projects.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

import Foundation

import SDGLogic

func inputSyntaxError(message: String) -> Never {
    let commands = join(lines: Command.allNames)
    let flags = join(lines: Flag.allFlags)
    
    fatalError(message: [
        message,
        "",
        "Available commands:",
        "",
        commands,
        "",
        "Available flags:",
        "",
        flags,
        ])
}

func unreachableLocation() -> Never {
    fatalError(message: [
        "This code should be unreachable.",
        "There may be a bug in Workspace.",
        ])
}

func fatalError(message: [String]) -> Never  {
    fail(message: message)
}

// MARK: - Generic Exiting

func succeed(message: [String]) -> Never {
    outputWarnings()
    print(message, in: .green, spaced: true)
    exit(EXIT_SUCCESS)
}

func fail(message: [String]) -> Never {
    outputWarnings()
    print(message, in: .red, spaced: true)
    exit(EXIT_FAILURE)
}

// MARK: - Generic Printing

func printHeader(_ message: [String]) {
    print(message, in: .blue, spaced: true)
}

private var warnings: [[String]] = []
func printWarning(_ message: [String]) {
    warnings.append(message)
    
}
private func outputWarnings() {
    for warning in warnings {
        print(warning, in: .yellow, spaced: true)
    }
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
        output = "\u{1B}[0;\(textColour.code)m\(output)\u{1B}[0;30m"
    }
    if spaced {
        output = "\n" + output + "\n"
    }
    print(output)
}
