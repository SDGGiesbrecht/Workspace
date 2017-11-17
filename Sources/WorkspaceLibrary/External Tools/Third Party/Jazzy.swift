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

    func document(target: String, scheme: String, buildOperatingSystem: OperatingSystem, copyright: StrictString, gitHubURL: URL?, outputDirectory: URL, project: PackageRepository, output: inout Command.Output) throws {
        let sdk: String
        switch buildOperatingSystem {
        case .macOS:
            sdk = "macosx"
        case .linux:
            unreachable()
        case .iOS:
            sdk = "iphoneos"
        case .watchOS:
            sdk = "watchos"
        case .tvOS:
            sdk = "appletvos"
        }

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
        project.resetCache(debugReason: "jazzy")

        // Workarounds
        try preventJekyllInterference(in: outputDirectory, for: project, output: &output)
        try fixSplitClusters(in: outputDirectory, for: project, output: &output)
    }

    // MARK: - Workarounds

    private func preventJekyllInterference(in directory: URL, for project: PackageRepository, output: inout Command.Output) throws {
        let nojekyll = directory.appendingPathComponent(".nojekyll")
        TextFile.reportWriteOperation(to: nojekyll, in: project, output: &output)
        try Data().write(to: nojekyll)
        project.resetCache(debugReason: ".nojekyll")
    }

    private func fixSplitClusters(in directory: URL, for project: PackageRepository, output: inout Command.Output) throws {
        for url in try project.trackedFiles(output: &output) {
            if let type = try? FileType(url: url),
                type == .html {

                var file = try TextFile(alreadyAt: url)
                var source = file.contents

                while let error = source.scalars.firstNestingLevel(startingWith: "<span class=\u{22}err\u{22}>".scalars, endingWith: "</span>".scalars) {

                    if let first = error.contents.contents.first {
                        if first ∈ CharacterSet.nonBaseCharacters,
                            let division = source.scalars.firstMatch(for: "</span><span class=\u{22}err\u{22}>".scalars)?.range {
                            source.scalars.removeSubrange(division)
                        } else if let `class` = source.scalars.firstNestingLevel(startingWith: "<span class=\u{22}".scalars, endingWith: "\u{22}>".scalars, in: error.container.range)?.contents.range {
                            if first ∈ SwiftLanguage.operatorHeadCharactersIncludingDot {
                                source.scalars.replaceSubrange(`class`, with: "o".scalars)
                            } else {
                                source.scalars.replaceSubrange(`class`, with: "n".scalars)
                            }
                        }
                    }
                }

                try file.writeChanges(for: project, output: &output)
            }

            notImplementedYet()
            /*
             while let shouldRemove = source.range(of: ReadMe.skipInJazzy.replacingOccurrences(of: "\u{2D}\u{2D}", with: "&ndash;").replacingOccurrences(of: "<", with: "&lt;").replacingOccurrences(of: ">", with: "&gt;")) {
             let relatedLine = source.lineRange(for: shouldRemove)
             source.removeSubrange(relatedLine)
             }

             file.contents = source
             require() { try file.write(output: &output) }
             }*/
        }
    }
}
