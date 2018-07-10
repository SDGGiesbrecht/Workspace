/*
 Jazzy.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Dispatch

import SDGLogic
import SDGMathematics
import SDGCollections
import WSGeneralImports

import SDGExternalProcess

import WSProject
import WSSwift
import WSThirdParty

#if os(Linux)
// MARK: - #if os(Linux)

public func linuxJazzyError() -> Command.Error {
    return Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return StrictString([
                "Workspace cannot perform documentation tasks from Linux, because Jazzy does not run on Linux.",
                "You can file a request with Jazzy:",
                "https://github.com/realm/jazzy/issues".in(Underline.underlined)
                ].joinedAsLines())
        }
    }))
}

#else

internal class Jazzy : RubyGem {

    // MARK: - Static Properties

    internal static let `default` = Jazzy(version: Version(0, 9, 3))

    internal override class var name: UserFacing<StrictString, InterfaceLocalization> { // @exempt(from: tests) Reachable only with an incompatible version of Jazzy.
        return UserFacing({ localization in // @exempt(from: tests)
            switch localization {
            case .englishCanada: // @exempt(from: tests)
                return "Jazzy"
            }
        })
    }

    internal override class var installationInstructionsURL: UserFacing<StrictString, InterfaceLocalization> { // @exempt(from: tests) Reachable only with an incompatible version of Jazzy.
        return UserFacing({ localization in // @exempt(from: tests)
            switch localization {
            case .englishCanada: // @exempt(from: tests)
                return "https://github.com/realm/jazzy"
            }
        })
    }

    // MARK: - Initialization

    private init(version: Version) {
        super.init(command: "jazzy",
                   repositoryURL: URL(string: "https://github.com/realm/jazzy")!,
                   version: version,
                   versionCheck: ["\u{2D}\u{2D}version"])
    }

    // MARK: - Usage

    internal func document(target: String, scheme: String, buildOperatingSystem: OperatingSystem, copyright: StrictString, gitHubURL: URL?, outputDirectory: URL, project: PackageRepository, output: Command.Output) throws {
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

        try TravisCI.keepAlive {
            try executeInCompatibilityMode(with: jazzyArguments, output: output)
        }
        project.resetFileCache(debugReason: "jazzy")

        // #workaround(jazzy --version 0.9.3, Jazzy is incompatible with Jekyll.)
        try preventJekyllInterference(in: outputDirectory, for: project, output: output)
        // #workaround(jazzy --version 0.9.3, Jazzy expects only ASCII.)
        try fixSplitClusters(in: outputDirectory, for: project, output: output)
    }

    private func parseError(undocumented json: String) -> Command.Error { // @exempt(from: tests) Reachable only with an incompatible version of Jazzy.
        return Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in // @exempt(from: tests)
            switch localization {
            case .englishCanada: // @exempt(from: tests)
                return StrictString("Error loading list of undocumented symbols:\n\(json)")
            }
        }))
    }

    internal func warnings(outputDirectory: URL) throws -> [(file: URL, line: Int?, symbol: String)] {

        let json = try TextFile(alreadyAt: outputDirectory.appendingPathComponent("undocumented.json")).contents

        guard let information = try JSONSerialization.jsonObject(with: json.file, options: []) as? [String: Any] else {
            throw parseError(undocumented: json) // @exempt(from: tests) Reachable only with an incompatible version of Jazzy.
        }

        guard let warnings = information["warnings"] as? [Any] else {
            throw parseError(undocumented: json) // @exempt(from: tests) Reachable only with an incompatible version of Jazzy.
        }

        var result: [(file: URL, line: Int?, symbol: String)] = []

        for entry in warnings {
            guard let warning = entry as? [String: Any],
                let path = warning["file"] as? String,
                let symbol = warning["symbol"] as? String else {
                    throw parseError(undocumented: json) // @exempt(from: tests) Reachable only with an incompatible version of Jazzy.
            }
            let line = warning["line"] as? Int // Occasionally “null” for some reason.

            result.append((file: URL(fileURLWithPath: path), line: line, symbol: symbol))
        }

        return result
    }

    // MARK: - Workarounds

    private func preventJekyllInterference(in directory: URL, for project: PackageRepository, output: Command.Output) throws {
        let nojekyll = directory.appendingPathComponent(".nojekyll")
        TextFile.reportWriteOperation(to: nojekyll, in: project, output: output)
        try Data().write(to: nojekyll)
    }

    private func fixSplitClusters(in directory: URL, for project: PackageRepository, output: Command.Output) throws {
        for url in try project.trackedFiles(output: output) where url.is(in: directory) {
            if let type = FileType(url: url),
                type == .html {
                try autoreleasepool {

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
                                    // @exempt(from: tests) Possibly no longer occurs in Jazzy output.
                                    source.scalars.replaceSubrange(`class`, with: "n".scalars)
                                }
                            }
                        }
                    }

                    file.contents = source
                    try file.writeChanges(for: project, output: output)
                }
            }
        }
    }
}

#endif
