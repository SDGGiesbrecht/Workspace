/*
 RefreshFileHeaders.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSFileHeaders

extension Workspace.Refresh {

    enum FileHeaders {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "file‐headers"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "re‐applies the project file header to each of the project’s files."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: Workspace.standardOptions, execution: { (_, options: Options, output: Command.Output) throws in

            output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Refreshing file headers..."
                }
            }).resolved().formattedAsSectionHeader())

            try options.project.refreshFileHeaders(output: output)
        })
    }
}
