/*
 ContinuousIntegration.Job.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

extension ContinuousIntegration {

    enum Job: Int, IterableEnumeration {

        // MARK: - Static Properties

        static let environmentVariableName: UserFacingText<InterfaceLocalization, Void> = UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "JOB"
            }
        })

        private static let optionName = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "job"
            }
        })

        private static let optionDescription = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "A particular continuous integration job."
            }
        })

        static let option = SDGCommandLine.Option(name: optionName, description: optionDescription, type: argument)

        private static let argumentName = UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "job"
            }
        })

        private static let argument = ArgumentType.enumeration(name: argumentName, cases: Job.cases.map() { (job: Job) -> (value: Job, label: UserFacingText<InterfaceLocalization, Void>) in

            let label: UserFacingText<InterfaceLocalization, Void>
            switch job {
            case .macOSSwiftPackageManager:
                label = UserFacingText({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "macos‐swift‐package‐manager"
                    }
                })
            case .macOSXcode:
                label = UserFacingText({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "macos‐xcode"
                    }
                })
            case .linux:
                label = UserFacingText({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "linux"
                    }
                })
            case .iOS:
                label = UserFacingText({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "ios"
                    }
                })
            case .watchOS:
                label = UserFacingText({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "watchos"
                    }
                })
            case .tvOS:
                label = UserFacingText({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "tvos"
                    }
                })
            case .miscellaneous:
                label = UserFacingText({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "miscellaneous"
                    }
                })
            case .documentation:
                label = UserFacingText({ (localization: InterfaceLocalization, _) -> StrictString in
                    switch localization {
                    case .englishCanada:
                        return "documentation"
                    }
                })
            }
            return (value: job, label: label)
        })

        // MARK: - Cases

        case macOSSwiftPackageManager
        case macOSXcode
        case linux
        case iOS
        case watchOS
        case tvOS
        case miscellaneous
        case documentation

        // MARK: - Properties

        func isRequired(by project: PackageRepository) throws -> Bool {
            switch self {
            case .macOSSwiftPackageManager:
                return try project.configuration.supports(.macOS)
                    ∧ ¬(try project.configuration.projectType() == .application)
            case .macOSXcode:
                return try project.configuration.supports(.macOS)
            case .linux:
                return try project.configuration.supports(.linux)
            case .iOS:
                return try project.configuration.supports(.iOS)
            case .watchOS:
                return try project.configuration.supports(.watchOS)
            case .tvOS:
                return try project.configuration.supports(.tvOS)
            case .miscellaneous:
                return true
            case .documentation:
                return try project.configuration.shouldGenerateDocumentation()
            }
        }

        var script: [String] {
            notImplementedYet()
            return []
        }
    }
}
