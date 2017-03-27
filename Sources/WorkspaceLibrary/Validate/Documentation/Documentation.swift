/*
 Documentation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic

struct Documentation {

    static func copyright(folder: String) -> String {

        var copyright = Configuration.documentationCopyright

        func key(_ name: String) -> String {
            return "[_\(name)_]"
        }

        let existing = File(possiblyAt: RelativePath(folder).subfolderOrFile("index.html")).contents
        let searchArea: String
        if let footerStart = existing.range(of: "<section id=\u{22}footer\u{22}>")?.upperBound {
            searchArea = existing.substring(from: footerStart)
        } else {
            searchArea = ""
        }
        let dates = FileHeaders.copyright(fromText: searchArea)

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

    static let operatorCharacters: CharacterSet = {
        let sections: [CharacterSet] = [
            CharacterSet(charactersIn: "\u{2F}=\u{2D}+\u{21}\u{2A}%<>&|^~?"),
            CharacterSet(charactersIn: "\u{A1}" ..< "\u{A7}"),
            CharacterSet(charactersIn: "©«¬®°±¶»¿×÷‖\u{2017}"),
            CharacterSet(charactersIn: "\u{2020}" ..< "\u{2027}"),
            CharacterSet(charactersIn: "\u{2030}" ..< "\u{203E}"),
            CharacterSet(charactersIn: "\u{2041}" ..< "\u{2053}"),
            CharacterSet(charactersIn: "\u{2055}" ..< "\u{205E}"),
            CharacterSet(charactersIn: "\u{2190}" ..< "\u{23FF}"),
            CharacterSet(charactersIn: "\u{2500}" ..< "\u{2775}"),
            CharacterSet(charactersIn: "\u{2794}" ..< "\u{2BFF}"),
            CharacterSet(charactersIn: "\u{2E00}" ..< "\u{2E7F}"),
            CharacterSet(charactersIn: "\u{3001}" ..< "\u{3003}"),
            CharacterSet(charactersIn: "\u{3008}" ..< "\u{3030}"),

            CharacterSet(charactersIn: ".")
        ]
        return sections.reduce(CharacterSet()) { $0.union($1) }
    }()

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
                "\u{2D}target", Configuration.primaryXcodeTarget,
                "\u{2D}sdk", sdk
            ]
            if let extraCondition = condition {
                xcodebuildArguments.append("SWIFT_ACTIVE_COMPILATION_CONDITIONS=\(extraCondition)")
            }

            var command = ["jazzy", "\u{2D}\u{2D}clean", "\u{2D}\u{2D}use\u{2D}safe\u{2D}filenames", "\u{2D}\u{2D}skip\u{2D}undocumented",
                           "\u{2D}\u{2D}output", documentationFolder,
                           "\u{2D}\u{2D}xcodebuild\u{2D}arguments", xcodebuildArguments.joined(separator: ","),
                           "\u{2D}\u{2D}module", Configuration.moduleName,
                           "\u{2D}\u{2D}copyright", copyright(folder: documentationFolder)
            ]
            if let github = Configuration.repositoryURL {
                command.append(contentsOf: [
                    "\u{2D}\u{2D}github_url", github
                    ])
            }
            if ¬Configuration.relatedProjects.isEmpty {
                command.append(contentsOf: [
                    "\u{2D}\u{2D}documentation=Documentation/*/*.md"
                    ])
            }

            if let jazzyResult = runThirdPartyTool(
                name: "Jazzy",
                repositoryURL: "https://github.com/realm/jazzy",
                versionCheck: ["jazzy", "\u{2D}\u{2D}version"],
                continuousIntegrationSetUp: [
                    ["gem", "install", "jazzy"]
                ],
                // [_Workaround: Jazzy produces symbols from unbuilt #if directives with no documentation. Removing them by skipping undocumented symbols. (jazzy --version 0.7.5)_]
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

                if jazzyResult.succeeded ∧ Configuration.enforceDocumentationCoverage {

                    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
                    printHeader(["Checking documentation coverage for \(operatingSystemName)..."])
                    // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••

                    let undocumented = require() { try File(at: RelativePath("docs/\(operatingSystemName)/undocumented.json")) }

                    guard let jsonData = undocumented.contents.data(using: String.Encoding.utf8) else {
                        fatalError(message: [
                            "“undocumented.json” is not in UTF‐8.",
                            "This may indicate a bug in Workspace."
                            ])
                    }

                    do {
                        guard let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                            fatalError(message: [
                                "Failed to parse “undocumented.json” as a dictionary.",
                                "This may indicate a bug in Workspace."
                                ])
                        }

                        guard let warnings = jsonDictionary["warnings"] as? [Any] else {
                            fatalError(message: [
                                "Failed to parse “warnings” in “undocumented.json”.",
                                "This may indicate a bug in Workspace."
                                ])
                        }

                        for warning in warnings {
                            print(["\(warning)"], in: .red, spaced: true)
                        }

                        if warnings.isEmpty {
                            individualSuccess("Documentation coverage is complete for \(operatingSystemName).")
                        } else {
                            individualFailure("Documentation coverage is incomplete for \(operatingSystemName). (See above for details.)")
                        }

                    } catch let error {
                        fatalError(message: [
                            "An error occurred while parsing “undocumented.json”.",
                            "",
                            error.localizedDescription
                            ])
                    }
                }
            }
        }

        if Environment.shouldDoMacOSJobs {

            // macOS

            generate(operatingSystemName: "macOS", sdk: "macosx")
        }

        if Environment.shouldDoMiscellaneousJobs ∧ Configuration.supportLinux {
            // [_Workaround: Generate Linux documentation on macOS instead. (jazzy --version 0.7.5)_]

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

        for path in Repository.trackedFiles(at: RelativePath("docs")) {
            if let fileType = FileType(filePath: path),
                fileType == .html {

                var file = require() { try File(at: path) }
                var source = file.contents

                let tokens = ("<span class=\u{22}err\u{22}>", "</span>")
                while let error = source.range(of: tokens) {

                    func parseError() -> Never {
                        fatalError(message: [
                            "Error parsing HTML:",
                            "",
                            source.substring(with: error),
                            "",
                            "This may indicate a bug in Workspace."
                            ])
                    }

                    guard let contents = source.contents(of: tokens),
                        let first = contents.unicodeScalars.first else {
                            parseError()
                    }

                    if CharacterSet.nonBaseCharacters.contains(first) {
                        guard let division = source.range(of: "</span><span class=\u{22}err\u{22}>") else {
                            parseError()
                        }
                        source.removeSubrange(division)
                    } else {
                        guard let `class` = source.rangeOfContents(of: ("<span class=\u{22}", "\u{22}>"), in: error) else {
                            parseError()
                        }

                        if operatorCharacters.contains(first) {
                            source.replaceSubrange(`class`, with: "o")
                        } else {
                            source.replaceSubrange(`class`, with: "n")
                        }
                    }
                }

                while let relatedLink = source.range(of: "Related%20Projects.md") {
                    let relatedLine = source.lineRange(for: relatedLink)
                    source.removeSubrange(relatedLine)
                }
                while let relatedLink = source.range(of: "Read%20Me.md") {
                    let relatedLine = source.lineRange(for: relatedLink)
                    source.removeSubrange(relatedLine)
                }

                file.contents = source
                require() { try file.write() }
            }
        }
    }
}
