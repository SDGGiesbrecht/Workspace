/*
 SwiftLint.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

class SwiftLint : SwiftPackage {

    // MARK: - Static Properties

    static let `default` = SwiftLint(version: Version(0, 24, 0))

    // MARK: - Initialization

    init(version: Version) { // [_Exempt from Code Coverage_] [_Workaround: Until proofread is testable._]
        super.init(command: "swiftlint",
                   repositoryURL: URL(string: "https://github.com/realm/SwiftLint")!,
                   version: version,
                   versionCheck: ["version"])
    }
}
