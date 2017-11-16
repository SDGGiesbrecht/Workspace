/*
 Jazzy.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCommandLine

class Jazzy : RubyGem {

    // MARK: - Static Properties

    static let `default` = Jazzy(version: Version(0, 9, 0))

    // MARK: - Initialization

    init(version: Version) {
        super.init(command: "jazzy",
                   repositoryURL: URL(string: "https://github.com/realm/jazzy")!,
                   version: version,
                   versionCheck: ["\u{2D}\u{2D}version"])
    }
}
