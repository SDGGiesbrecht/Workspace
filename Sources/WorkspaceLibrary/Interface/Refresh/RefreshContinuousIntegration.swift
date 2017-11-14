/*
 RefreshContinuousIntegration.swift

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

    enum ContinuousIntegration {

        private static let name = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "continuous‐integration"
            }
        })

        private static let description = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "regenerates the project’s continuous integration configuration files."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [], execution: { (_, options: Options, output: inout Command.Output) throws in

            if try options.project.configuration.shouldManageContinuousIntegration() {

                print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "Refreshing continuous integration configuration..."
                    }
                }).resolved().formattedAsSectionHeader(), to: &output)

                try options.project.refreshContinuousIntegration(output: &output)

            } else {
                notImplementedYet()
                //ContinuousIntegration.relinquishControl(output: &output)
            }
        })
    }
}
