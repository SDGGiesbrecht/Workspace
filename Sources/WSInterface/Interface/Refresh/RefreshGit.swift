/*
 RefreshGit.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSGit

extension Workspace.Refresh {

    enum Git {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "git"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "regenerates the project’s Git configuration files."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, options: Options, output: Command.Output) throws in

            output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Refreshing Git configuration..."
                }
            }).resolved().formattedAsSectionHeader())

            try options.project.refreshGitConfiguration(output: output)
        })
    }
}
