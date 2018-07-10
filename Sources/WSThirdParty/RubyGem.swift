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

import WorkspaceConfiguration

open class RubyGem : ThirdPartyTool {

    // MARK: - Class Properties

    open class var name: UserFacing<StrictString, InterfaceLocalization> {
        primitiveMethod()
    }

    open class var installationInstructionsURL: UserFacing<StrictString, InterfaceLocalization> {
        primitiveMethod()
    }

    // MARK: - Execution

    private class func installationError(version: Version) -> Command.Error { // @exempt(from: tests) Reachable only with an incompatible version of Jazzy.
        return Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in // @exempt(from: tests)
            switch localization {
            case .englishCanada: // @exempt(from: tests)
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

    public final override class func execute(command: StrictString, version: Version, with arguments: [String], versionCheck: [StrictString], repositoryURL: URL, cacheDirectory: URL, output: Command.Output) throws { // @exempt(from: tests) Reachable only with an incompatible version of Jazzy.

        let commandString: [String] = [String(command), "_" + version.string() + "_"]
        let versionCheckString = versionCheck.map({ String($0) }) // @exempt(from: tests)

        if (try? Shell.default.run(command: commandString + versionCheckString)) == nil { // @exempt(from: tests)
            do { // @exempt(from: tests)
                output.print("")
                try Shell.default.run(command: [
                    "gem", "install", String(command),
                    "\u{2D}\u{2D}version", version.string()
                    ], reportProgress: { output.print($0) }) // @exempt(from: tests)
                output.print("")
            } catch {
                // @exempt(from: tests)
                throw installationError(version: version)
            }
        } // @exempt(from: tests)

        output.print("")
        try Shell.default.run(command: commandString + arguments, reportProgress: { output.print($0) }) // @exempt(from: tests)
        output.print("")
    }
}
