/*
 ContinuousIntegration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCommandLine

enum ContinuousIntegration {

    static func refreshContinuousIntegration(for project: PackageRepository, output: inout Command.Output) throws {

        var travisConfiguration: [String] = [
            "language: generic",
            "matrix:",
            "  include:"
        ]

        for job in Job.cases where try job.isRequired(by: project) {
            travisConfiguration.append(contentsOf: job.script)
        }

        travisConfiguration.append(contentsOf: [
            "",
            "cache:",
            "  directories:",
            "  \u{2D} $HOME/Library/Caches/ca.solideogloria.Workspace",
            "  \u{2D} $HOME/.cache/ca.solideogloria.Workspace"
            ])

        var travisConfigurationFile = try TextFile(possiblyAt: project.url(for: ".travis.yml"))
        travisConfigurationFile.body = join(lines: travisConfiguration)
        print(travisConfigurationFile.body)
        try travisConfigurationFile.writeChanges(for: project, output: &output)
    }

    static func commandEntry(_ command: String) -> String {
        var escapedCommand = command.replacingOccurrences(of: "\u{5C}", with: "\u{5C}\u{5C}")
        escapedCommand = escapedCommand.replacingOccurrences(of: "\u{22}", with: "\u{5C}\u{22}")
        return "        \u{2D} \u{22}\(escapedCommand)\u{22}"
    }

    /*

    static func refreshContinuousIntegrationConfiguration(output: inout Command.Output) {

        // [_Workaround: Pipes are required to safely update SwiftLint. Shell functions currently do not support them._]
        let updateHomebrew = runCommand("brew update")
        let updateSwiftLint = runCommand("brew outdated swiftlint \u{7C}\u{7C} brew upgrade swiftlint")

        func runWorkspaceScript(_ name: String) -> String {
            var file = "./\(name) (macOS).command"
            file = file.replacingOccurrences(of: " ", with: "\u{5C} ")
            file = file.replacingOccurrences(of: "(", with: "\u{5C}(")
            file = file.replacingOccurrences(of: ")", with: "\u{5C})")

            return runCommand("bash \(file)")
        }
        let runRefreshWorkspace = runWorkspaceScript("Refresh")
        let runValidateChanges = runWorkspaceScript("Validate")

        if Configuration.supportMacOS {

            updatedLines.append(contentsOf: [
                "    \u{2D} os: osx",
                "      env:",
                "        \u{2D} \(jobKey)=\u{22}\(macOSJob)\u{22}",
                "      osx_image: xcode9",
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
                "        \u{2D} SWIFT_VERSION=4.0",
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
                "      osx_image: xcode9",
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
                "        \u{2D} SWIFT_VERSION=4.0",
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
                "      osx_image: xcode9",
                "      script:",
                updateHomebrew,
                updateSwiftLint,
                runRefreshWorkspace,
                runValidateChanges
                ])
     }
    }

    static func relinquishControl(output: inout Command.Output) {

        var configuration = File(possiblyAt: travisConfigurationPath)
        if let range = configuration.contents.range(of: managementComment) {
            print("Cancelling continuous integration management...".formattedAsSectionHeader(), to: &output)
            configuration.contents.removeSubrange(range)
            try? configuration.write(output: &output)
        }
    }*/
}
