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

#if os(Linux)

    func linuxJazzyError() -> Command.Error {
        return Command.Error(description: UserFacingText({(localization: InterfaceLocalization, _: Void) in
            switch localization {
            case .englishCanada:
                return StrictString(join(lines: [
                    "Workspace cannot perform documentation tasks from Linux, because Jazzy does not run on Linux.",
                    "You can file a request with Jazzy:",
                    "https://github.com/realm/jazzy/issues".in(Underline.underlined)
                    ]))
            }
        }))
    }

#else

    class Jazzy : RubyGem {

        // MARK: - Static Properties

        static let `default` = Jazzy(version: Version(0, 9, 0))

        override class var name: UserFacingText<InterfaceLocalization, Void> { // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Jazzy.
            return UserFacingText({ (localization, _) in // [_Exempt from Code Coverage_]
                switch localization {
                case .englishCanada: // [_Exempt from Code Coverage_]
                    return "Jazzy"
                }
            })
        }

        override class var installationInstructionsURL: UserFacingText<InterfaceLocalization, Void> { // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Jazzy.
            return UserFacingText({ (localization, _) in // [_Exempt from Code Coverage_]
                switch localization {
                case .englishCanada: // [_Exempt from Code Coverage_]
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

            // [_Workaround: Jazzy is incompatible with Jekyll. (jazzy --version 0.9.0)_]
            try preventJekyllInterference(in: outputDirectory, for: project, output: &output)
            // [_Workaround: Jazzy expects only ASCII. (jazzy --version 0.9.0)_]
            try fixSplitClusters(in: outputDirectory, for: project, output: &output)
        }

        private func parseError(undocumented json: String) -> Command.Error { // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Jazzy.
            return Command.Error(description: UserFacingText<InterfaceLocalization, Void>({ (localization, _) in // [_Exempt from Code Coverage_]
                switch localization {
                case .englishCanada: // [_Exempt from Code Coverage_]
                    return StrictString("Error loading list of undocumented symbols:\n\(json)")
                }
            }))
        }

        func warnings(outputDirectory: URL) throws -> [(file: URL, line: Int?, symbol: String)] {

            let json = try TextFile(alreadyAt: outputDirectory.appendingPathComponent("undocumented.json")).contents

            guard let information = (try JSONSerialization.jsonObject(with: json.file, options: []) as? PropertyListValue)?.as([String: Any].self) else { // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Jazzy.
                throw parseError(undocumented: json)
            }

            guard let warnings = (information["warnings"] as? PropertyListValue)?.as([Any].self) else { // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Jazzy.
                throw parseError(undocumented: json)
            }

            var result: [(file: URL, line: Int?, symbol: String)] = []

            for entry in warnings {
                guard let warning = (entry as? PropertyListValue)?.as([String: Any].self),
                    let path = (warning["file"] as? PropertyListValue)?.as(String.self),
                    let symbol = (warning["symbol"] as? PropertyListValue)?.as(String.self) else {
                        throw parseError(undocumented: json) // [_Exempt from Code Coverage_] Reachable only with an incompatible version of Jazzy.
                }
                let line = (warning["line"] as? PropertyListValue)?.as(Int.self) // Occasionally “null” for some reason.

                result.append((file: URL(fileURLWithPath: path), line: line, symbol: symbol))
            }

            return result
        }

        // MARK: - Workarounds

        private func preventJekyllInterference(in directory: URL, for project: PackageRepository, output: inout Command.Output) throws {
            let nojekyll = directory.appendingPathComponent(".nojekyll")
            TextFile.reportWriteOperation(to: nojekyll, in: project, output: &output)
            try Data().write(to: nojekyll)
            project.resetCache(debugReason: ".nojekyll")
        }

        private func fixSplitClusters(in directory: URL, for project: PackageRepository, output: inout Command.Output) throws {
            for url in try project.trackedFiles(output: &output) where url.is(in: directory) {
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
                                } else { // [_Exempt from Code Coverage_] Possibly no longer occurs in Jazzy output.
                                    source.scalars.replaceSubrange(`class`, with: "n".scalars)
                                }
                            }
                        }
                    }

                    file.contents = source
                    try file.writeChanges(for: project, output: &output)
                }
            }
        }
    }

#endif
