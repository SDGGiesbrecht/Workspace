/*
 ValidateAll.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

extension Workspace.Validate {

    enum All {

        private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "all"
            }
        })

        private static let description = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "performs all configured validation checks."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [
            ContinuousIntegration.Job.option
            ], execution: { (arguments: DirectArguments, options: Options, output: Command.Output) throws in // [_Exempt from Test Coverage_] [_Workaround: Not testable yet._]
            try runValidate(andExit: true, arguments: arguments, options: options, output: output)
        })
    }
}
