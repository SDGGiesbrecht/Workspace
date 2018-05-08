/*
 VersionChecks.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

@testable import WorkspaceLibrary

func triggerVersionChecks() {
    XCTAssertErrorFree {
        #if !os(Linux)
        _ = try SwiftLint.default.execute(with: ["version"], output: Command.Output.mock)
        _ = try Jazzy.default.execute(with: ["\u{2D}\u{2D}version"], output: Command.Output.mock)
        #endif
    }
}
