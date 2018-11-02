/*
 ContinuousIntegrationJob.swift

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
import WSDocumentation

public enum ContinuousIntegrationJob : Int, CaseIterable {

    // MARK: - Static Properties

    private static let environmentVariableName = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "JOB"
        }
    })

    // MARK: - Cases

    case macOSSwiftPackageManager
    case macOSXcode
    case linux
    case iOS
    case watchOS
    case tvOS
    case miscellaneous
    case deployment

    public static let simulatorJobs: Set<ContinuousIntegrationJob> = [
        .iOS,
        .tvOS
    ]

    // MARK: - Properties

    private var name: UserFacing<StrictString, InterfaceLocalization> {
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
        case .deployment:
            return UserFacing({ (localization) in
                switch localization {
                case .englishCanada:
                    return "Deployment"
                }
            })
        }
    }

    public var argumentName: UserFacing<StrictString, InterfaceLocalization> {
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
        case .deployment:
            return UserFacing({ (localization) in
                switch localization {
                case .englishCanada:
                    return "deployment"
                }
            })
        }
    }

    public func isRequired(by project: PackageRepository, output: Command.Output) throws -> Bool {
        switch self {
        case .macOSSwiftPackageManager, .macOSXcode:
            return try .macOS ∈ project.configuration(output: output).supportedOperatingSystems
        case .linux: // @exempt(from: tests) False coverage result in Xcode 9.2.
            return try .linux ∈ project.configuration(output: output).supportedOperatingSystems
        case .iOS:
            return try .iOS ∈ project.configuration(output: output).supportedOperatingSystems
        case .watchOS:
            return try .watchOS ∈ project.configuration(output: output).supportedOperatingSystems
        case .tvOS:
            return try .tvOS ∈ project.configuration(output: output).supportedOperatingSystems
        case .miscellaneous:
            return true
        case .deployment:
            return try project.configuration(output: output).documentation.api.generate
                ∧ project.hasTargetsToDocument()
                ∧ (try project.configuration(output: output).documentation.api.encryptedTravisCIDeploymentKey) ≠ nil
        }
    }

    public var operatingSystem: OperatingSystem {
        switch self {
        case .macOSSwiftPackageManager, .macOSXcode, .iOS, .watchOS, .tvOS:
            return .macOS
        case .linux, .miscellaneous, .deployment:
            return .linux
        }
    }

    private var travisOperatingSystemKey: String {
        switch operatingSystem {
        case .macOS:
            return "osx"
        case .linux:
            return "linux"
        case .iOS, .watchOS, .tvOS:
            unreachable()
        }
    }

    private var environmentLabel: String {
        return String(ContinuousIntegrationJob.environmentVariableName.resolved(for: .englishCanada)) + "=\u{22}" + String(name.resolved(for: .englishCanada)) + "\u{22}"
    }

    private var travisSDKKey: String? {
        switch self {
        case .macOSSwiftPackageManager, .macOSXcode, .linux, .watchOS, .miscellaneous, .deployment:
            return nil
        case .iOS:
            return "iphonesimulator"
        case .tvOS:
            return "appletvsimulator"
        }
    }

    internal func script(configuration: WorkspaceConfiguration) throws -> [String] {
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
                "        local_dir: " + PackageRepository.documentationDirectoryName,
                "        github_token: $GITHUB_TOKEN",
                "        skip_cleanup: true"
                ])
        }

        switch operatingSystem {
        case .macOS:
            result.append("      osx_image: xcode10")
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

        func commandEntry(_ command: String) -> String {
            var escapedCommand = command.replacingOccurrences(of: "\u{5C}", with: "\u{5C}\u{5C}")
            escapedCommand = escapedCommand.replacingOccurrences(of: "\u{22}", with: "\u{5C}\u{22}")
            return "        \u{2D} \u{22}\(escapedCommand)\u{22}"
        }

        if operatingSystem == .linux {
            result.append(contentsOf: [
                commandEntry("export SWIFT_VERSION=4.2"),
                commandEntry("eval \u{22}$(curl -sL https://gist.githubusercontent.com/kylef/5c0475ff02b7c7671d2a/raw/9f442512a46d7a2af7b850d65a7e9bd31edfb09b/swiftenv-install.sh)\u{22}")
                ])
        }

        result.append(contentsOf: [
            commandEntry("bash \u{22}./Refresh (macOS).command\u{22}"),
            commandEntry("bash \u{22}./Validate (macOS).command\u{22} •job " + String(argumentName.resolved(for: .englishCanada)))
            ])

        return result
    }
}

extension Optional where Wrapped == ContinuousIntegrationJob {

    public func includes(job: ContinuousIntegrationJob) -> Bool {
        switch self {
        case .none:
            switch job {
            case .macOSSwiftPackageManager, .macOSXcode, .linux, .iOS, .watchOS, .tvOS, .miscellaneous:
                return true
            case .deployment:
                return false
            }
        case .some(let currentJob):
            return currentJob == job
        }
    }
}
