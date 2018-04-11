/*
 RefreshReadMe.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

extension Workspace.Refresh {

    enum ReadMe {

        private static let name = UserFacingText<InterfaceLocalization>({ (localization: InterfaceLocalization) -> StrictString in
            switch localization {
            case .englishCanada:
                return "read‐me"
            }
        })

        private static let description = UserFacingText<InterfaceLocalization>({ (localization: InterfaceLocalization) -> StrictString in
            switch localization {
            case .englishCanada:
                return "regenerates the project’s read‐me file."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, options: Options, output: inout Command.Output) throws in

            print(UserFacingText<InterfaceLocalization>({ (localization: InterfaceLocalization) -> StrictString in
                switch localization {
                case .englishCanada:
                    return "Refreshing read‐me..."
                }
            }).resolved().formattedAsSectionHeader(), to: &output)

            try options.project.refreshReadMe(output: &output)
        })
    }
}
