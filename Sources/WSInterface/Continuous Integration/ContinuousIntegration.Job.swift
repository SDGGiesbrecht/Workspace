/*
 ContinuousIntegration.Job.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import WSProject

extension ContinuousIntegration {

    enum Job : Int, IterableEnumeration {

        // MARK: - Static Properties

        static let environmentVariableName = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "JOB"
            }
        })

        private static let optionName = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "job"
            }
        })

        private static let optionDescription = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "A particular continuous integration job."
            }
        })

        static let option = SDGCommandLine.Option(name: optionName, description: optionDescription, type: argument)

        private static let argumentName = UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "job"
            }
        })

        private static let argument = ArgumentType.enumeration(name: argumentName, cases: Job.cases.map { (job: Job) -> (value: Job, label: UserFacing<StrictString, InterfaceLocalization>) in
            return (value: job, label: job.argumentName)
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
        case deployment

        // MARK: - Properties

        var englishTargetOperatingSystemName: StrictString {
            switch self {
            case .macOSSwiftPackageManager, .macOSXcode:
                return "macOS"
            case .linux:
                return "Linux" // [_Exempt from Test Coverage_] Unreachable from macOS.
            case .iOS:
                return "iOS"
            case .watchOS:
                return "watchOS"
            case .tvOS:
                return "tvOS"
            case .miscellaneous, .documentation, .deployment:
                unreachable()
            }
        }
        var englishTargetBuildSystemName: StrictString? {
            switch self {
            case .macOSSwiftPackageManager:
                return "the Swift Package Manager"
            case .macOSXcode:
                return "Xcode"
            case .linux, .iOS, .watchOS, .tvOS, .miscellaneous, .documentation, .deployment:
                return nil
            }
        }

        var name: UserFacing<StrictString, InterfaceLocalization> {
            switch self {
            case .macOSSwiftPackageManager:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "macOS + Swift Package Manager"
                    }
                })
            case .macOSXcode:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "macOS + Xcode"
                    }
                })
            case .linux:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "Linux"
                    }
                })
            case .iOS:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "iOS"
                    }
                })
            case .watchOS:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "watchOS"
                    }
                })
            case .tvOS:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "tvOS"
                    }
                })
            case .miscellaneous:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "Miscellaneous"
                    }
                })
            case .documentation:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "Documentation"
                    }
                })
            case .deployment:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "Deployment"
                    }
                })
            }
        }

        var argumentName: UserFacing<StrictString, InterfaceLocalization> {
            switch self {
            case .macOSSwiftPackageManager:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "macos‐swift‐package‐manager"
                    }
                })
            case .macOSXcode:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "macos‐xcode"
                    }
                })
            case .linux:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "linux"
                    }
                })
            case .iOS:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "ios"
                    }
                })
            case .watchOS:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "watchos"
                    }
                })
            case .tvOS:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "tvos"
                    }
                })
            case .miscellaneous:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "miscellaneous"
                    }
                })
            case .documentation:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "documentation"
                    }
                })
            case .deployment:
                return UserFacing({ (localization) in
                    switch localization {
                    case .englishCanada:
                        return "deployment"
                    }
                })
            }
        }

        func isRequired(by project: PackageRepository, output: Command.Output) throws -> Bool {
            switch self {
            case .macOSSwiftPackageManager, .macOSXcode:
                return try .macOS ∈ project.configuration().supportedOperatingSystems
            case .linux: // [_Exempt from Test Coverage_] False coverage result in Xcode 9.2.
                return try .linux ∈ project.configuration().supportedOperatingSystems
            case .iOS:
                return try .iOS ∈ project.configuration().supportedOperatingSystems
            case .watchOS:
                return try .watchOS ∈ project.configuration().supportedOperatingSystems
            case .tvOS:
                return try .tvOS ∈ project.configuration().supportedOperatingSystems
            case .miscellaneous:
                return true
            case .documentation:
                return try project.configuration().documentation.api.generate
                    ∧ project.hasTargetsToDocument(output: output)
            case .deployment:
                return try project.configuration().documentation.api.generate
                ∧ project.hasTargetsToDocument(output: output)
                ∧ (try project.configuration().documentation.api.encryptedTravisCIDeploymentKey) ≠ nil
            }
        }

        var operatingSystem: OperatingSystem {
            switch self {
            case .macOSSwiftPackageManager, .macOSXcode, .iOS, .watchOS, .tvOS, .documentation, .deployment:
                // [_Workaround: Documentation can be switched to Linux when Jazzy supports it. (jazzy --version 0.9.1)_]
                return .macOS
            case .linux, .miscellaneous:
                return .linux
            }
        }

        var travisOperatingSystemKey: String {
            switch operatingSystem {
            case .macOS:
                return "osx"
            case .linux:
                return "linux"
            case .iOS, .watchOS, .tvOS:
                unreachable()
            }
        }

        var environmentLabel: String {
            return String(Job.environmentVariableName.resolved(for: .englishCanada)) + "=\u{22}" + String(name.resolved(for: .englishCanada)) + "\u{22}"
        }

        var travisSDKKey: String? {
            switch self {
            case .macOSSwiftPackageManager, .macOSXcode, .linux, .watchOS, .miscellaneous, .documentation, .deployment:
                return nil
            case .iOS:
                return "iphonesimulator"
            case .tvOS:
                return "appletvsimulator"
            }
        }

        func script(configuration: WorkspaceConfiguration) throws -> [String] {
            var result: [String] = [
                "    \u{2D} os: " + travisOperatingSystemKey,
                "      env:",
                "        \u{2D} " + environmentLabel
            ]
            if self == .deployment {
                guard let key = configuration.documentation.api.encryptedTravisCIDeploymentKey else {
                    unreachable()
                }

                result.append(contentsOf: [
                    "        \u{2D} secure: \u{22}" + key + "\u{22}",
                    "      if: branch = master and (not type = pull_request)",
                    "",
                    "      deploy:",
                    "        provider: pages",
                    "        local_dir: " + Documentation.defaultDocumentationDirectoryName,
                    "        github_token: $GITHUB_TOKEN",
                    "        skip_cleanup: true"
                    ])
            }

            switch operatingSystem {
            case .macOS:
                result.append("      osx_image: xcode9.3")
            case .linux:
                result.append("      dist: trusty")
            case .iOS, .watchOS, .tvOS:
                unreachable()
            }

            if let sdk = travisSDKKey {
                result.append(contentsOf: [
                    "      language: objective\u{2D}c",
                    "      xcode_sdk: " + sdk
                    ])
            }

            result.append("      script:")

            if operatingSystem == .linux {
                result.append(contentsOf: [
                    ContinuousIntegration.commandEntry("export SWIFT_VERSION=4.1"),
                    ContinuousIntegration.commandEntry("eval \u{22}$(curl -sL https://gist.githubusercontent.com/kylef/5c0475ff02b7c7671d2a/raw/9f442512a46d7a2af7b850d65a7e9bd31edfb09b/swiftenv-install.sh)\u{22}")
                    ])
            }

            result.append(contentsOf: [
                ContinuousIntegration.commandEntry("bash \u{22}./Refresh (macOS).command\u{22}"),
                ContinuousIntegration.commandEntry("bash \u{22}./Validate (macOS).command\u{22} •job " + String(argumentName.resolved(for: .englishCanada)))
                ])

            return result
        }
    }
}

extension Optional where Wrapped == ContinuousIntegration.Job {
    // MARK: - where Wrapped == ContinuousIntegration.Job

    func includes(job: ContinuousIntegration.Job) -> Bool {
        switch self {
        case .none:
            switch job {
            case .macOSSwiftPackageManager, .macOSXcode, .linux, .iOS, .watchOS, .tvOS, .miscellaneous, .documentation:
                return true
            case .deployment:
                return false
            }
        case .some(let currentJob):
            return currentJob == job
        }
    }
}
