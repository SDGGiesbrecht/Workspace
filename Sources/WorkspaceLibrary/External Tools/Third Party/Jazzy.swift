/*
 Jazzy.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

class Jazzy : RubyGem {

    // MARK: - Static Properties

    static let `default` = Jazzy(version: Version(0, 9, 0))

    override class var name: UserFacingText<InterfaceLocalization, Void> {
        return UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Jazzy"
            }
        })
    }

    override class var installationInstructionsURL: UserFacingText<InterfaceLocalization, Void> {
        return UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "https://github.com/realm/jazzy"
            }
        })
    }

    // MARK: - Initialization

    init(version: Version) {
        super.init(command: "jazzy",
                   repositoryURL: URL(string: "https://github.com/realm/jazzy")!,
                   version: version,
                   versionCheck: ["\u{2D}\u{2D}version"])
    }

    // MARK: - Usage

    func document(target: String, scheme: String, sdk: String, copyright: StrictString, gitHubURL: URL?, outputDirectory: URL, output: inout Command.Output) throws {

        let buildDirectory = FileManager.default.url(in: .temporary, at: "Jazzy Build Artifacts")
        try? FileManager.default.removeItem(at: buildDirectory)
        defer { try? FileManager.default.removeItem(at: buildDirectory) }

        var jazzyArguments: [String] = [
            "\u{2D}\u{2D}module", target,
            "\u{2D}\u{2D}copyright", String(copyright)
        ]

        if let gitHub = gitHubURL {
            jazzyArguments.append(contentsOf: [
                "\u{2D}\u{2D}github_url", Shell.quote(gitHub.absoluteString)
                ])
        }

        jazzyArguments.append(contentsOf: [
            "\u{2D}\u{2D}documentation=Documentation/*.md",
            "\u{2D}\u{2D}clean",
            "\u{2D}\u{2D}use\u{2D}safe\u{2D}filenames",
            "\u{2D}\u{2D}output", Shell.quote(outputDirectory.path),
            "\u{2D}\u{2D}xcodebuild\u{2D}arguments", [
                "\u{2D}scheme", scheme,
                "\u{2D}target", target,
                "\u{2D}sdk", sdk,
                "\u{2D}derivedDataPath", buildDirectory.path
                ].joined(separator: ",")
            ])

        try executeInCompatibilityMode(with: jazzyArguments, output: &output)
    }
}
