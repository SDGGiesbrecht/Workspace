/*
 RubyGem.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGExternalProcess

class RubyGem : ThirdPartyTool {

    // MARK: - Class Properties

    class var name: UserFacing<StrictString, InterfaceLocalization> {
        primitiveMethod()
    }

    class var installationInstructionsURL: UserFacing<StrictString, InterfaceLocalization> {
        primitiveMethod()
    }

    // MARK: - Execution

    private class func installationError(version: Version) -> Command.Error { // [_Exempt from Test Coverage_] Reachable only with an incompatible version of Jazzy.
        return Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in // [_Exempt from Test Coverage_]
            switch localization {
            case .englishCanada: // [_Exempt from Test Coverage_]
                let englishName = name.resolved(for: localization)
                let url = installationInstructionsURL.resolved(for: localization)
                return [
                    StrictString("Failed to install \(englishName) \(version.string)."),
                    StrictString("Please install \(englishName) \(version.string) manually."),
                    StrictString("See \(url.in(Underline.underlined))")
                    ].joinedAsLines()
            }
        }))
    }

    final override class func execute(command: StrictString, version: Version, with arguments: [String], versionCheck: [StrictString], repositoryURL: URL, cacheDirectory: URL, output: Command.Output) throws { // [_Exempt from Test Coverage_] Reachable only with an incompatible version of Jazzy.

        let commandString: [String] = [String(command), "_" + version.string() + "_"]
        let versionCheckString = versionCheck.map({ String($0) }) // [_Exempt from Test Coverage_]

        if (try? Shell.default.run(command: commandString + versionCheckString)) == nil { // [_Exempt from Test Coverage_]
            do { // [_Exempt from Test Coverage_]
                output.print("")
                try Shell.default.run(command: [
                    "gem", "install", String(command),
                    "\u{2D}\u{2D}version", version.string()
                    ], reportProgress: { output.print($0) }) // [_Exempt from Test Coverage_]
                output.print("")
            } catch {
                // [_Exempt from Test Coverage_]
                throw installationError(version: version)
            }
        } // [_Exempt from Test Coverage_]

        output.print("")
        try Shell.default.run(command: commandString + arguments, reportProgress: { output.print($0) }) // [_Exempt from Test Coverage_]
        output.print("")
    }
}
