/*
 RefreshScripts.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

extension Workspace.Refresh {

    enum Scripts {

        private static let name = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "scripts"
            }
        })

        private static let description = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "regenerates the project’s refresh and validation scripts."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, options: Options, output: inout Command.Output) throws in

            print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                switch localization {
                case .englishCanada:
                    return "Refreshing scripts..."
                }
            }).resolved().formattedAsSectionHeader(), to: &output)

            try options.project.refreshScripts(output: &output)
        })
    }
}
