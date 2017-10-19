/*
 Initialize.swift

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
    enum Initialize {

        private static let name = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "initialize"
            }
        })

        private static let description = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "initializes a new project in the current directory."
            }
        })

        static let command = Command(name: name, description: description, directArguments: [], options: [type], execution: { (_, _, _ /*output: inout Command.Output*/) throws in
            runInitialize(andExit: true)
        })

        // Options

        private static let typeName = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "type"
            }
        })

        private static let typeDescription = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "The type of project to initialize."
            }
        })

        private static let type = SDGCommandLine.Option(name: typeName, description: typeDescription, type: projectTypeArgument)

        private static let projectTypeArgumentName = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            // [_Workaround: This should be refactored directly into the ProjectType enumeration. (SDGCommandLine 0.1.0)_]
            switch localization {
            case .englishCanada:
                return "project type"
            }
        })

        private static let projectTypeArgument = ArgumentType.enumeration(name: projectTypeArgumentName, cases: [
            // [_Workaround: This should be refactored directly into the ProjectType enumeration. (SDGCommandLine 0.1.0)_]
            (value: ProjectType.library, label: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                switch localization {
                case .englishCanada:
                    return "library"
                }
            })),
            (value: ProjectType.executable, label: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                switch localization {
                case .englishCanada:
                    return "executable"
                }
            })),
            (value: ProjectType.application, label: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                switch localization {
                case .englishCanada:
                    return "application"
                }
            }))
            ])
    }
}
