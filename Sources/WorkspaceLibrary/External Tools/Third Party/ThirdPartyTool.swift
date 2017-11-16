/*
 ThirdPartyTool.swift

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

class ThirdPartyTool {

    // MARK: - Static Properties

    private static let toolsCache = FileManager.default.url(in: .cache, at: "Tools")

    // MARK: - Initialization

    init(command: StrictString, repositoryURL: URL, version: Version, versionCheck: [StrictString]) {
        self.command = command
        self.repositoryURL = repositoryURL
        self.version = version
        self.versionCheck = versionCheck
    }

    // MARK: - Properties

    private let command: StrictString
    private let repositoryURL: URL
    private let version: Version
    private let versionCheck: [StrictString]

    // MARK: - Execution

    final func execute(with arguments: [StrictString], output: inout Command.Output) throws {
        if let systemVersionString = try? Shell.default.run(command: ([String(command)] + versionCheck.map({ String($0) })), silently: true),
            let systemVersion = Version(firstIn: systemVersionString),
            systemVersion == version {
            try Shell.default.run(command: ([command] + arguments).map({ String($0) }), alternatePrint: { print($0, to: &output) })
            return
        }

        try type(of: self).execute(command: command, version: version, with: arguments, versionCheck: versionCheck, repositoryURL: repositoryURL, cacheDirectory: ThirdPartyTool.toolsCache.appendingPathComponent(repositoryURL.lastPathComponent), output: &output)
    }

    class func execute(command: StrictString, version: Version, with arguments: [StrictString], versionCheck: [StrictString], repositoryURL: URL, cacheDirectory: URL, output: inout Command.Output) throws {
        primitiveMethod()
    }
}
