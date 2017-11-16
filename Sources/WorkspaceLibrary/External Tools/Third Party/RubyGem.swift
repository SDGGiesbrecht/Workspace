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

    // MARK: - Class Properties

    class var name: UserFacingText<InterfaceLocalization, Void> {
        primitiveMethod()
    }

    class var installationInstructionsURL: UserFacingText<InterfaceLocalization, Void> {
        primitiveMethod()
    }

    // MARK: - Execution

    private class func installationError(version: Version) -> Command.Error {
        return Command.Error(description: UserFacingText({ (localization: InterfaceLocalization, _: Void) in
            switch localization {
            case .englishCanada:
                let englishName = String(name.resolved(for: localization))
                let url = String(installationInstructionsURL.resolved(for: localization))
                return StrictString(join(lines: [
                    "Failed to install " + englishName + " " + version.string + ".",
                    "Please install " + englishName + " " + version.string + " manually.",
                    "See: " + url
                    ]))
            }
        }))
    }

    final override class func execute(command: StrictString, version: Version, with arguments: [StrictString], versionCheck: [StrictString], repositoryURL: URL, cacheDirectory: URL, output: inout Command.Output) throws {

        let commandString: [String] = [String(command), "_" + version.string + "_"]
        let versionCheckString = versionCheck.map({ String($0) })

        if (try? Shell.default.run(command: commandString + versionCheckString, silently: true)) == nil {
            do {
                try Shell.default.run(command: [
                    "gem", "install", String(command),
                    "\u{2D}\u{2D}version", version.string
                    ], alternatePrint: { print($0, to: &output) })
            } catch {
                throw installationError(version: version)
            }
        }

        try Shell.default.run(command: commandString + arguments.map({ String($0) }), alternatePrint: { print($0, to: &output) })
    }
}
