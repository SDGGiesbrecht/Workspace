/*
 Flags.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

struct Flags {

    // MARK: - Properties

    private static func isSet(_ flag: Flag) -> Bool {
        return CommandLine.arguments.contains(flag.flag)
    }

    private static func value(of flag: Flag) -> String? {

        guard let index = CommandLine.arguments.index(of: flag.flag) else {
            return nil
        }

        guard index ≠ CommandLine.arguments.endIndex else {
            return nil
        }

        let nextArgument = CommandLine.arguments.index(after: index)
        return CommandLine.arguments[nextArgument]
    }

    static let type: ProjectType = {
        if let string = value(of: .type),
            let projectType = ProjectType(flag: string) {
            return projectType
        }
        return .library
    }()
}
