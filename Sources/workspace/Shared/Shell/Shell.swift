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

func bash(_ arguments: [String]) -> Bool {
    
    let process = Process()
    process.launchPath = "/usr/bin/env"
    process.arguments = arguments
    
    process.launch()
    process.waitUntilExit()
    
    Repository.resetCache()
    
    return process.terminationStatus == EXIT_SUCCESS
}

func forceBash(_ arguments: [String]) {
    if ¬bash(arguments) {
        fatalError(message: [
            "Command failed:",
            "",
            arguments.joined(separator: " "),
            "",
            "See details above.",
            ])
    }
}
