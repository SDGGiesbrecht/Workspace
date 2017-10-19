/*
 Refresh.swift

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
    internal enum Refresh {

        static let name = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "refresh"
            }
        })

        static let description = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "refreshes the current Swift project by updating its components and readying it for development."
            }
        })

        public static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, _, output: inout Command.Output) throws in
            WSCommand.refresh.run(andExit: true)
        })
    }
}
