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

    static func copyright(folder: String) -> String {

        var copyright = Configuration.documentationCopyright

        func key(_ name: String) -> String {
            return "[_\(name)_]"
        }

        let existing = File(possiblyAt: RelativePath(folder).subfolderOrFile("index.html")).contents
        let dates = FileHeaders.copyright(fromText: existing)

        var possibleAuthor: String?
        if copyright.contains(key("Author")) {
            possibleAuthor = Configuration.requiredAuthor
        }

        copyright = copyright.replacingOccurrences(of: key("Copyright"), with: dates)
        if let author = possibleAuthor {
            copyright = copyright.replacingOccurrences(of: key("Author"), with: author)
        }
        copyright = copyright.replacingOccurrences(of: key("Project"), with: Configuration.projectName)

        return copyright
    }

    static func generate(individualSuccess: @escaping (String) -> Void, individualFailure: @escaping (String) -> Void) {

        Xcode.temporarilyDisableProofreading()
        defer {
            Xcode.reEnableProofreading()
        }

        func generate(operatingSystemName: String, sdk: String, condition: String? = nil) {

            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
            printHeader(["Generating documentation for \(operatingSystemName)..."])
            // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

            let documentationFolder = "docs/\(operatingSystemName)"

            var xcodebuildArguments = [
                "-target", Configuration.primaryXcodeTarget,
                "-sdk", sdk
                ]
            if let extraCondition = condition {
                xcodebuildArguments.append("SWIFT_ACTIVE_COMPILATION_CONDITIONS=\(extraCondition)")
            }

            if Environment.isInContinuousIntegration {
                // [_Workaround: Testing in CI._]
                let _ = bash(["xcodebuild"] + xcodebuildArguments)
            }

            var command = ["jazzy", "--clean", "--use-safe-filenames", "--skip-undocumented",
                           "--output", documentationFolder,
                           "--xcodebuild-arguments", xcodebuildArguments.joined(separator: ","),
                           "--module", Configuration.primaryXcodeTarget,
                           "--copyright", copyright(folder: documentationFolder)
            ]
            if let github = Configuration.projectWebsite {
                command.append(contentsOf: [
                    "--github_url", github
                    ])
            }

            if let jazzyResult = runThirdPartyTool(
                name: "Jazzy",
                repositoryURL: "https://github.com/realm/jazzy",
                versionCheck: ["jazzy", "--version"],
                continuousIntegrationSetUp: [
                    ["gem", "install", "jazzy"]
                ],
                // [_Workaround: Jazzy produces symbols from unbuilt #if directives with no documentation. Removing them with --skip-undocumented. (Jazzy 0.7.4)_]
                command: command,
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
