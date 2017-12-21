/*
 VersionChecks.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

@testable import WorkspaceLibrary

func triggerVersionChecks() {
    XCTAssertErrorFree {
        _ = try Git.default._execute(with: ["\u{2D}\u{2D}version"], output: &Command.Output.mock, silently: false, autoquote: true)
        _ = try SwiftTool.default._execute(with: ["\u{2D}\u{2D}version"], output: &Command.Output.mock, silently: false, autoquote: true)
        _ = try Xcode.default.executeInCompatibilityMode(with: ["\u{2D}version"], output: &Command.Output.mock)

        _ = try SwiftLint.default.execute(with: ["version"], output: &Command.Output.mock)
        _ = try Jazzy.default.execute(with: ["\u{2D}\u{2D}version"], output: &Command.Output.mock)
    }
}
