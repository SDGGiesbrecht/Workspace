/*
 Refresh.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

extension Workspace {
    enum Refresh {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "refresh"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "refreshes the project by updating its components and readying it for development."
            }
        })

        static let command = Command(name: name, description: description, subcommands: [
            All.command,
            Scripts.command,
            ReadMe.command,
            ContinuousIntegration.command,
            Resources.command
            ], defaultSubcommand: All.command)
    }
}
