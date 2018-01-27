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

    private func findSourceKit() {
        #if os(Linux)
            let sourceKitVariable = "LINUX_SOURCEKIT_LIB_PATH"
            if ProcessInfo.processInfo.environment[sourceKitVariable] == nil {
                do {
                    let relativeToUser = "lib/libsourcekitdInProc.so"
                    var sourceKit: URL?

                    let swiftInstall = try Shell.default.run(command: ["which", "swift"], silently: true)
                    let swift = URL(fileURLWithPath: swiftInstall)

                    // Standard Install
                    let user = swift.deletingLastPathComponent().deletingLastPathComponent()
                    let standardSourceKit = user.appendingPathComponent(relativeToUser)
                    if try standardSourceKit.checkResourceIsReachable() {
                        sourceKit = standardSourceKit
                    } else {

                        // Swift Version Manager
                        let manager = swift.deletingLastPathComponent().deletingLastPathComponent()
                        if let versionString = try? Shell.default.run(command: ["swiftenv", "version"]),
                            let version = Version(versionString) {
                            let directory: String
                            if version.patch == 0 {
                                directory = String(version.string.dropLast().dropLast())
                            } else {
                                directory = version.string
                            }
                            let versionedSourceKit = manager.appendingPathComponent("versions/\(directory)/usr/" + relativeToUser)
                            if try versionedSourceKit.checkResourceIsReachable() {
                                sourceKit = versionedSourceKit
                            }
                        }
                    }

                    if let found = sourceKit {
                        setenv(sourceKitVariable, found.path, 0 /* overwrite: false */)
                    }
                } catch {}
            }
        #endif
    }

    func isConfigured() -> Bool {
        var url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        url.appendPathComponent(".swiftlint.yml")
        return FileManager.default.isReadableFile(atPath: url.path)
    }

    func standardConfiguration() -> StrictString {
        return StrictString(Resources.SwiftLint.standardConfiguration)
    }

    func proofread(withConfiguration configuration: URL?, forXcode: Bool, output: inout Command.Output) throws -> Bool {
        findSourceKit()

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
        } catch let error as Shell.Error {
            if error.code ∈ Set<Int>([
                2, // Error level violation.
                3 // Warning level violation in strict mode.
                ]) {
                return false // SwiftLint reported a violation.
            }
            throw error // Error in SwiftLint set‐up.
        } catch let error {
            throw error
        }
    }
}
