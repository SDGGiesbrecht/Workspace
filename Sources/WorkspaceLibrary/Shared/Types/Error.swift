/*
 Error.swift

 This source file is part of the Workspace open source project.

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

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

let debug = _isDebugAssertConfiguration()

#if os(Linux)
    // [_Workaround: Skip unavailable file copying by using shell on Linux. (Swift 3.0.2)_]
    struct LinuxFileError: Error {
        init(exitCode: ExitCode) {
            code = exitCode
            description = "Linux file error: \(exitCode)"
        }
        let code: ExitCode
        let description: String
    }
#endif
