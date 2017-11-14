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

        static let command = Command(name: name, description: description, directArguments: [], options: [type], execution: { (arguments: DirectArguments, options: Options, output: inout Command.Output) throws in
            try runInitialize(andExit: true, arguments: arguments, options: options, output: &output)
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

        static let type = SDGCommandLine.Option(name: typeName, description: typeDescription, type: projectTypeArgument)

        private static let projectTypeArgumentName = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "project type"
            }
        })

        private static let projectTypeArgument = ArgumentType.enumeration(name: projectTypeArgumentName, cases: PackageRepository.Target.TargetType.cases.map() { (type: PackageRepository.Target.TargetType) -> (value: PackageRepository.Target.TargetType, label: UserFacingText<InterfaceLocalization, Void>) in

            let label: UserFacingText<InterfaceLocalization, Void>
            switch type {
            case .library:
                label = UserFacingText({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "library"
                    }
                })
            case .executable:
                label = UserFacingText({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "executable"
                    }
                })
            case .application:
                label = UserFacingText({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "application"
                    }
                })
            }
            return (value: type, label: label)
        })
    }
}
