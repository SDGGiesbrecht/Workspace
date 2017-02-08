/*
 Flags.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

struct Flags {
    
    // MARK: - Properties
    
    private static func isSet(_ flag: Flag) -> Bool {
        return CommandLine.arguments.contains(flag.flag)
    }
    
    static let executable = isSet(.executable)
}
