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

    private class func installationError(version: Version) -> Command.Error { // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Jazzy.
        return Command.Error(description: UserFacingText({ (localization: InterfaceLocalization, _: Void) in // [_Exempt from Code Coverage_]
            switch localization {
            case .englishCanada: // [_Exempt from Code Coverage_]
                let englishName = String(name.resolved(for: localization))
                let url = String(installationInstructionsURL.resolved(for: localization))
                return StrictString(join(lines: [
                    "Failed to install " + englishName + " " + version.string + ".",
                    "Please install " + englishName + " " + version.string + " manually.",
                    "See " + url.in(Underline.underlined)
                    ]))
            }
        }))
    }

    final override class func execute(command: StrictString, version: Version, with arguments: [String], versionCheck: [StrictString], repositoryURL: URL, cacheDirectory: URL, output: inout Command.Output) throws { // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Jazzy.

        let commandString: [String] = [String(command), "_" + version.string + "_"]
        let versionCheckString = versionCheck.map({ String($0) }) // [_Exempt from Code Coverage_]

        if (try? Shell.default.run(command: commandString + versionCheckString, silently: true)) == nil { // [_Exempt from Code Coverage_]
            do { // [_Exempt from Code Coverage_]
                try Shell.default.run(command: [
                    "gem", "install", String(command),
                    "\u{2D}\u{2D}version", version.string
                    ], alternatePrint: { print($0, to: &output) }) // [_Exempt from Code Coverage_]
            } catch { // [_Exempt from Code Coverage_]
                throw installationError(version: version)
            }
        } // [_Exempt from Code Coverage_]

        try Shell.default.run(command: commandString + arguments, alternatePrint: { print($0, to: &output) }) // [_Exempt from Code Coverage_]
    }
}
