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

    enum Job : Int, IterableEnumeration {

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

        var name: UserFacingText<InterfaceLocalization, Void> {
            switch self {
            case .macOSSwiftPackageManager:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "macOS + Swift Package Manager"
                    }
                })
            case .macOSXcode:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "macOS + Xcode"
                    }
                })
            case .linux:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "Linux"
                    }
                })
            case .iOS:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "iOS"
                    }
                })
            case .watchOS:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "watchOS"
                    }
                })
            case .tvOS:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "tvOS"
                    }
                })
            case .miscellaneous:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "Miscellaneous"
                    }
                })
            case .documentation:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "Documentation"
                    }
                })
            case .deployment:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "Deployment"
                    }
                })
            }
        }

        var argumentName: UserFacingText<InterfaceLocalization, Void> {
            switch self {
            case .macOSSwiftPackageManager:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "macos‐swift‐package‐manager"
                    }
                })
            case .macOSXcode:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "macos‐xcode"
                    }
                })
            case .linux:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "linux"
                    }
                })
            case .iOS:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "ios"
                    }
                })
            case .watchOS:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "watchos"
                    }
                })
            case .tvOS:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "tvos"
                    }
                })
            case .miscellaneous:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "miscellaneous"
                    }
                })
            case .documentation:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "documentation"
                    }
                })
            case .deployment:
                return UserFacingText({ (localization, _) in
                    switch localization {
                    case .englishCanada:
                        return "deployment"
                    }
                })
            }
        }

        func isRequired(by project: PackageRepository, output: inout Command.Output) throws -> Bool {
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
                    ∧ project.hasTargetsToDocument(output: &output)
            case .deployment:
                return try project.configuration.shouldGenerateDocumentation()
                ∧ project.hasTargetsToDocument(output: &output)
                ∧ (try project.configuration.encryptedTravisDeploymentKey()) ≠ nil
            }
        }

        var operatingSystem: OperatingSystem {
            switch self {
            case .macOSSwiftPackageManager, .macOSXcode, .iOS, .watchOS, .tvOS, .documentation, .deployment:
                // [_Workaround: Documentation can be switched to Linux when Jazzy supports it. (jazzy --version 0.9.0)_]
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

        func script(configuration: Configuration) throws -> [String] {
            var result: [String] = [
                "    \u{2D} os: " + travisOperatingSystemKey,
                "      env:",
                "        \u{2D} " + environmentLabel
            ]
            if self == .deployment {
                guard let key = try configuration.encryptedTravisDeploymentKey() else {
                    unreachable()
                }

                result.prepend("    \u{2D} stage: deploy")
                result.append(contentsOf: [
                    "        \u{2D} secure: \u{22}" + key + "\u{22}",
                    "",
                    "      deploy:",
                    "        provider: pages",
                    "        local_dir: " + Documentation.defaultDocumentationDirectoryName,
                    "        github_token: $GITHUB_TOKEN",
                    "        skip_cleanup: true",
                    ])
            }

            switch operatingSystem {
            case .macOS:
                result.append("      osx_image: xcode9.1")
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
                    ContinuousIntegration.commandEntry("export SWIFT_VERSION=4.0"),
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

    func includes(job: ContinuousIntegration.Job) -> Bool { // [_Exempt from Code Coverage_] [_Workaround: Until unit‐tests is testable._]
        switch self {
        case .none: // [_Exempt from Code Coverage_] [_Workaround: Until unit‐tests is testable._]
            switch job {
            case .macOSSwiftPackageManager, .macOSXcode, .linux, .iOS, .watchOS, .tvOS, .miscellaneous, .documentation:
                return true
            case .deployment:
                return false
            }
        case .some(let currentJob): // [_Exempt from Code Coverage_] [_Workaround: Until unit‐tests is testable._]
            return currentJob == job
        }
    }
}
