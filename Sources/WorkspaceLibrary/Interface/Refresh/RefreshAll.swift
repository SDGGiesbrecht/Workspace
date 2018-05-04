/*
 RefreshAll.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLine

extension Workspace.Refresh {

    enum All {

        private static let name = UserFacingText<InterfaceLocalization>({ (localization: InterfaceLocalization) -> StrictString in
            switch localization {
            case .englishCanada:
                return "all"
            }
        })

        private static let description = UserFacingText<InterfaceLocalization>({ (localization: InterfaceLocalization) -> StrictString in
            switch localization {
            case .englishCanada:
                return "performs all configured refreshment tasks."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (arguments: DirectArguments, options: Options, output: inout Command.Output) throws in
            try runRefresh(andExit: true, arguments: arguments, options: options, output: &output)
        })
    }
}
