/*
 SwiftLint.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import WSGeneralImports

import SDGExternalProcess

import WSThirdParty

internal class SwiftLint : SwiftPackage {

    // MARK: - Static Properties

    internal static let `default` = SwiftLint(version: Version(0, 25, 1))

    // MARK: - Initialization

    private init(version: Version) {
        super.init(command: "swiftlint",
                   repositoryURL: URL(string: "https://github.com/realm/SwiftLint")!,
                   version: version,
                   versionCheck: ["version"])
    }

    // MARK: - Usage

    internal func isConfigured() -> Bool {
        var url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        url.appendPathComponent(".swiftlint.yml")
        return FileManager.default.isReadableFile(atPath: url.path)
    }

    internal func standardConfiguration() -> StrictString {
        return StrictString(Resources.SwiftLint.standardConfiguration)
    }

    internal func proofread(withConfiguration configuration: URL?, forXcode: Bool, output: Command.Output) throws -> Bool {

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

            try executeInCompatibilityMode(with: arguments, output: output)
            return true
        } catch let error as ExternalProcess.Error {
            if error.code ∈ Set<Int>([
                2, // Error level violation.
                3 // Warning level violation in strict mode.
                ]) {
                return false // SwiftLint reported a violation.
            }
            throw error // Error in SwiftLint set‐up. // @exempt(from: tests)
        } catch let error {
            throw error // Error in SwiftLint set‐up. // @exempt(from: tests)
        }
    }
}
