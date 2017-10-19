/*
 Validate.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

extension Workspace {
    internal enum Validate {

        static let name = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "validate"
            }
        })

        static let description = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "validates the current project against a thorough battery of tests."
            }
        })

        public static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, _, _ /*output: inout Command.Output*/) throws in
            WSCommand.validate.run(andExit: true)
        })
    }
}
