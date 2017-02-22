/*
 Documentation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

struct Documentation {

    static func generate(individualSuccess: @escaping (String) -> Void, individualFailure: @escaping (String) -> Void) {

        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
        printHeader(["Generating documentation..."])
        // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

        func generate(operatingSystemName: String, sdk: String, condition: String? = nil) {

            let documentationFolder = "docs/\(operatingSystemName)"

            var xcodebuildArguments = [
                "-scheme", Configuration.primaryXcodeTarget,
                "-sdk", sdk
                ]
            if let extraCondition = condition {
                xcodebuildArguments.append("SWIFT_ACTIVE_COMPILATION_CONDITIONS=\(extraCondition)")
            }

            if let jazzyResult = runThirdPartyTool(
                name: "Jazzy",
                repositoryURL: "https://github.com/realm/jazzy",
                versionCheck: ["jazzy", "--version"],
                continuousIntegrationSetUp: [
                    ["gem", "install", "jazzy"]
                ],
                command: ["jazzy", "--clean", "--use-safe-filenames",
                          "--output", documentationFolder,
                          "--xcodebuild-arguments", xcodebuildArguments.joined(separator: ",")
                ],
                updateInstructions: [
                    "Command to install Jazzy:",
                    "gem install jazzy",
                    "Command to update Jazzy:",
                    "gem update jazzy"
                ],
                dropOutput: true) {

                requireBash(["touch", "docs/.nojekyll"])

                if jazzyResult.succeeded {
                    individualSuccess("Generated documentation for \(operatingSystemName).")
                } else {
                    individualFailure("Failed to generate documentation for \(operatingSystemName).")
                }
            }
        }

        if Environment.shouldDoMacOSJobs {

            // macOS

            generate(operatingSystemName: "macOS", sdk: "macosx")
        }

        if Environment.shouldDoMiscellaneousJobs ∧ Configuration.supportLinux {
            // [_Workaround: Generate Linux documentation on macOS instead. (Jazzy 0.7.4)_]

            generate(operatingSystemName: "Linux", sdk: "macosx", condition: "LinuxDocs")
        }

        if Environment.shouldDoIOSJobs {

            // iOS

            generate(operatingSystemName: "iOS", sdk: "iphoneos")
        }

        if Environment.shouldDoWatchOSJobs {

            // watchOS

            generate(operatingSystemName: "watchOS", sdk: "watchos")
        }

        if Environment.shouldDoTVOSJobs {

            // tvOS

            generate(operatingSystemName: "tvOS", sdk: "appletvos")
        }
    }
}
