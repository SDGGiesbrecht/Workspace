// Error.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

import SDGLogic

func require<T>(operation: () throws -> T) -> T {
    do {
        return try operation()
    } catch let error {
        fatalError(message: [
            "An error occurred:",
            "",
            error.localizedDescription,
            ])
    }
}

func force(operation: () throws -> ()) {
    do {
        try operation()
    } catch _ {
        // Ignore failure.
    }
}

// These assertions print even in continuous integration.

func assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> [String], file: StaticString = #file, line: UInt = #line) {
    
    if _isDebugAssertConfiguration() ∧ ¬condition() {
        
        fatalError(message: [
            "Assertion Failure!",
            "",
            "File: \(file)",
            "Line: \(line)",
            ""] + message())
    }
}

func assert(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    assert(condition(), [message()], file: file, line: line)
}
