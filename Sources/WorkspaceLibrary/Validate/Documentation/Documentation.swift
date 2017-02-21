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

        func generate(operatingSystemName: OperatingSystem) {

            if let jazzyResult = runThirdPartyTool(
                name: "Jazzy",
                repositoryURL: "https://github.com/realm/jazzy",
                tagPrefix: "v",
                versionCheck: ["jazzy", "--version"],
                continuousIntegrationSetUp: [
                    ["gem", "install", "jazzy"]
                ],
                command: ["jazzy"],
                updateInstructions: [
                    "Command to install Jazzy:",
                    "gem install jazzy",
                    "Command to update Jazzy:",
                    "gem update jazzy"
                ],
                dropOutput: true) {

                if ¬jazzyResult.succeeded {
                    individualFailure("Failed to generate documentation for \(operatingSystemName)")
                }
            }
        }
    }
}
