/*
 ContinuousIntegration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

struct ContinuousIntegration {

    static let jobKey = "JOB"
    static let macOSJob = "macOS"
    static let linuxJob = "Linux"
    static let iOSJob = "iOS"
    static let watchOSJob = "watchOS"
    static let tvOSJob = "tvOS"
    static let miscellaneousJob = "Misc."

    static let operatingSystemsForMiscellaneousJobs: Set<OperatingSystem> = [
        .macOS,
        .linux
    ]

    private static let travisConfigurationPath = RelativePath(".travis.yml")

    private static let managementComment: String = {
        let managementWarning = File.managmentWarning(section: false, documentation: .continuousIntegration)
        return FileType.yaml.syntax.comment(contents: managementWarning)
    }()

    static func refreshContinuousIntegrationConfiguration() {

        var travisConfiguration = File(possiblyAt: travisConfigurationPath)

        var updatedLines: [String] = [
            managementComment,
            "",
            "language: generic",
            "matrix:",
            "  include:"
        ]

        func runCommand(_ command: String) -> String {
            var escapedCommand = command.replacingOccurrences(of: "\u{5C}", with: "\u{5C}\u{5C}")
            escapedCommand = escapedCommand.replacingOccurrences(of: "\u{22}", with: "\u{5C}\u{22}")
            return "        \u{2D} \u{22}\(escapedCommand)\u{22}"
        }

        func runWorkspaceScript(_ name: String) -> String {
            var file = "./\(name) (macOS).command"
            file = file.replacingOccurrences(of: " ", with: "\u{5C} ")
            file = file.replacingOccurrences(of: "(", with: "\u{5C}(")
            file = file.replacingOccurrences(of: ")", with: "\u{5C})")

            return runCommand("bash \(file)")
        }
        let runRefreshWorkspace = runWorkspaceScript("Refresh Workspace")
        let runValidateChanges = runWorkspaceScript("Validate Changes")

        if Configuration.supportMacOS {

            updatedLines.append(contentsOf: [
                "    \u{2D} os: osx",
                "      env:",
                "        \u{2D} \(jobKey)=\u{22}\(macOSJob)\u{22}",
                "      osx_image: xcode8.2",
                "      script:",
                runRefreshWorkspace,
                runValidateChanges
                ])
        }

        if Configuration.supportLinux {

            updatedLines.append(contentsOf: [
                "    \u{2D} os: linux",
                "      dist: trusty",
                "      env:",
                "        \u{2D} \(jobKey)=\u{22}\(linuxJob)\u{22}",
                "        \u{2D} SWIFT_VERSION=3.0.2",
                "      script:",
                runCommand("eval \u{22}$(curl -sL https://gist.githubusercontent.com/kylef/5c0475ff02b7c7671d2a/raw/9f442512a46d7a2af7b850d65a7e9bd31edfb09b/swiftenv-install.sh)\u{22}"),
                runRefreshWorkspace,
                runValidateChanges
                ])
        }

        func addPortableOSJob(name: String, sdk: String) {
            updatedLines.append(contentsOf: [
                "    \u{2D} os: osx",
                "      env:",
                "        \u{2D} \(jobKey)=\u{22}\(name)\u{22}",
                "      osx_image: xcode8.2",
                "      language: objective\u{2D}c",
                "      xcode_sdk: \(sdk)",
                "      script:",
                runRefreshWorkspace,
                runValidateChanges
                ])
        }

        if Configuration.supportIOS {

            addPortableOSJob(name: iOSJob, sdk: "iphonesimulator")
        }

        if Configuration.supportWatchOS {

            addPortableOSJob(name: watchOSJob, sdk: "watchsimulator")
        }

        if Configuration.supportTVOS {

            addPortableOSJob(name: tvOSJob, sdk: "appletvsimulator")
        }

        if Configuration.supportOnlyLinux {
            updatedLines.append(contentsOf: [
                "    \u{2D} os: linux",
                "      dist: trusty",
                "      env:",
                "        \u{2D} \(jobKey)=\u{22}\(miscellaneousJob)\u{22}",
                "        \u{2D} SWIFT_VERSION=3.0.2",
                "      script:",
                runCommand("eval \u{22}$(curl -sL https://gist.githubusercontent.com/kylef/5c0475ff02b7c7671d2a/raw/9f442512a46d7a2af7b850d65a7e9bd31edfb09b/swiftenv-install.sh)\u{22}"),
                runRefreshWorkspace,
                runValidateChanges
                ])
        } else {
            // Miscellaneous must be done on macOS because of SwiftLint.
            updatedLines.append(contentsOf: [
                "    \u{2D} os: osx",
                "      env:",
                "        \u{2D} \(jobKey)=\u{22}\(miscellaneousJob)\u{22}",
                "      osx_image: xcode8.2",
                "      script:",
                runRefreshWorkspace,
                runValidateChanges
                ])
        }

        updatedLines.append(contentsOf: [
            "",
            "cache:",
            "  directories:",
            // Workspace
            "  \u{2D} $HOME/.Workspace"
            ])

        let newBody = join(lines: updatedLines)
        travisConfiguration.body = newBody
        require() { try travisConfiguration.write() }
    }

    static func relinquishControl() {

        var configuration = File(possiblyAt: travisConfigurationPath)
        if let range = configuration.contents.range(of: managementComment) {
            printHeader(["Cancelling continuous integration management..."])
            configuration.contents.removeSubrange(range)
            force() { try configuration.write() }
        }
    }

}
