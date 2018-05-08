/*
 SwiftPackage.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

class SwiftPackage : ThirdPartyTool {

    // MARK: - Execution

    final override class func execute(command: StrictString, version: Version, with arguments: [String], versionCheck: [StrictString], repositoryURL: URL, cacheDirectory: URL, output: Command.Output) throws { // [_Exempt from Test Coverage_] Unreachable except with incompatible version of SwiftLint.
        try Package(url: repositoryURL).execute(Build.version(version), of: [command], with: arguments, cacheDirectory: cacheDirectory, reportProgress: { output.print($0) }) // [_Exempt from Test Coverage_] Unreachable except with incompatible version of SwiftLint.
    }
}
