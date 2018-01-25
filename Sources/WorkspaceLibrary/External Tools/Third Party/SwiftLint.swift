/*
 SwiftLint.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

class SwiftLint : SwiftPackage {

    // MARK: - Static Properties

    static let `default` = SwiftLint(version: Version(0, 24, 2))

    // MARK: - Initialization

    init(version: Version) {
        super.init(command: "swiftlint",
                   repositoryURL: URL(string: "https://github.com/realm/SwiftLint")!,
                   version: version,
                   versionCheck: ["version"])
    }

    // MARK: - Usage

    func isConfigured() -> Bool {
        var url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        url.appendPathComponent(".swiftlint.yml")
        return FileManager.default.isReadableFile(atPath: url.path)
    }

    func standardConfiguration() -> StrictString {
        return StrictString(Resources.SwiftLint.standardConfiguration)
    }

    func proofread(withConfiguration configuration: URL?, forXcode: Bool, output: inout Command.Output) throws -> Bool {
        do {
            var arguments = [
                "lint",
                "\u{2D}\u{2D}strict"
            ]
            if let config = configuration?.path {
                arguments += [
                    "\u{2D}\u{2D}config", config
                ]
            }
            if forXcode {
                arguments += [
                    "\u{2D}\u{2D}quiet"
                ]
            } else {
                arguments += [
                    "\u{2D}\u{2D}reporter", "emoji"
                ]
            }

            try executeInCompatibilityMode(with: arguments, output: &output)
            return true
        } catch _ as Shell.Error { // SwiftLint exited with failure.
            return false
        } catch let error { // Failed to set up SwiftLint.
            throw error
        }
    }
}
