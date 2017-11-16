/*
 SwiftPackage.swift

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

class SwiftPackage : ThirdPartyTool {

    // MARK: - Execution

    final override class func execute(command: StrictString, version: Version, with arguments: [StrictString], versionCheck: [StrictString], repositoryURL: URL, cacheDirectory: URL, output: inout Command.Output) throws {
        try Package(url: repositoryURL).execute(version, of: [command], with: arguments, cacheDirectory: cacheDirectory, output: &output)
    }
}
