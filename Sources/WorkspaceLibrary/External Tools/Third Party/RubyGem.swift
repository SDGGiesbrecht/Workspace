/*
 RubyGem.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

class RubyGem : ThirdPartyTool {

    // MARK: - Execution

    override class func execute(command: StrictString, version: Version, with arguments: [StrictString], versionCheck: [StrictString], repositoryURL: URL, cacheDirectory: URL, output: inout Command.Output) throws {

        let commandString: [String] = [String(command), "_" + version.string + "_"]
        let versionCheckString = versionCheck.map({ String($0) })

        if (try? Shell.default.run(command: commandString + versionCheckString, silently: true)) == nil {
            try Shell.default.run(command: [
                "gem", "install", String(command),
                "\u{2D}\u{2D}version", version.string
                ], alternatePrint: { print($0, to: &output) })
        }

        try Shell.default.run(command: commandString + arguments.map({ String($0) }), alternatePrint: { print($0, to: &output) })
    }
}
