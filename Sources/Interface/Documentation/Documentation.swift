/*
 Documentation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import GeneralImports

enum Documentation {

    static let defaultDocumentationDirectoryName = "docs" // Matches GitHub Pages.
    static func defaultDocumentationDirectory(for project: PackageRepository) -> URL {
        return project.location.appendingPathComponent(defaultDocumentationDirectoryName)
    }
    static func subdirectory(for target: String, in documentationDirectory: URL) -> URL {
        return documentationDirectory.appendingPathComponent(target)
    }

    static func defaultCopyrightTemplate(configuration: Configuration) throws -> Template {
        return Template(source: try FileHeaders.defaultCopyright(configuration: configuration).text + " All rights reserved.")
    }

    private static func copyright(for directory: URL, in project: PackageRepository, output: Command.Output) throws -> StrictString {

        let existing = try TextFile(possiblyAt: directory.appendingPathComponent("index.html")).contents
        let searchArea: String
        if let override = try project.configuration.originalDocumentationCopyrightYear() {
            searchArea = "©" + String(override)
        } else if let footerStart = existing.range(of: "<section id=\u{22}footer\u{22}>")?.upperBound {
            searchArea = String(existing[footerStart...])
        } else {
            searchArea = ""
        }
        let dates = StrictString(FileHeaders.copyright(fromText: searchArea))

        var template = try project.configuration.documentationCopyright()

        template.insert(dates, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Copyright"
            }
        }))
        try template.insert(resultOf: { try project.configuration.requireAuthor() }, for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Author"
            }
        }))
        template.insert(try project.projectName(), for: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Project"
            }
        }))

        return template.text
    }

    #if !os(Linux)

    static func document(target: String, for project: PackageRepository, outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Generating documentation for “" + StrictString(target) + "”..."
            }
        }).resolved().formattedAsSectionHeader())

        let outputSubdirectory = subdirectory(for: target, in: outputDirectory)

        let buildOperatingSystem: OperatingSystem
        if try project.configuration.supports(.macOS, project: project, output: output) {
            buildOperatingSystem = .macOS
        } else if try project.configuration.supports(.iOS, project: project, output: output) {
            buildOperatingSystem = .iOS
        } else if try project.configuration.supports(.watchOS, project: project, output: output) {
            buildOperatingSystem = .watchOS
        } else if try project.configuration.supports(.tvOS, project: project, output: output) {
            buildOperatingSystem = .tvOS
        } else {
            buildOperatingSystem = .macOS
        }

        let copyrightText = try copyright(for: outputSubdirectory, in: project, output: output)
        try FileManager.default.do(in: project.location) {
            try Jazzy.default.document(target: target, scheme: try project.scheme(), buildOperatingSystem: buildOperatingSystem, copyright: copyrightText, gitHubURL: try project.configuration.repositoryURL(), outputDirectory: outputSubdirectory, project: project, output: output)
        }

        let transformedMarker = ReadMe.skipInJazzy.replacingMatches(for: "\u{2D}\u{2D}".scalars, with: "&ndash;".scalars).replacingMatches(for: "<".scalars, with: "&lt;".scalars).replacingMatches(for: ">".scalars, with: "&gt;".scalars)
        for url in try project.trackedFiles(output: output) where url.is(in: outputSubdirectory) {
            if let type = try? FileType(url: url),
                type == .html {
                try autoreleasepool {

                    var file = try TextFile(alreadyAt: url)
                    var source = file.contents
                    while let skipMarker = source.scalars.firstMatch(for: transformedMarker.scalars) {
                        let line = skipMarker.range.lines(in: source.lines)
                        source.lines.removeSubrange(line)
                    }

                    file.contents = source
                    try file.writeChanges(for: project, output: output)
                }
            }
        }

        validationStatus.passStep(message: UserFacing({ localization in
            switch localization {
            case .englishCanada:
                return "Generated documentation for “" + StrictString(target) + "”."
            }
        }))
    }

    static func validateDocumentationCoverage(for target: String, in project: PackageRepository, outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Checking documentation coverage for “" + StrictString(target) + "”..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        let warnings = try Jazzy.default.warnings(outputDirectory: subdirectory(for: target, in: outputDirectory))

        for warning in warnings {
            output.print([
                warning.file.path(relativeTo: project.location) + ":" + String(warning.line?.inDigits() ?? ""), // [_Exempt from Test Coverage_] It is unknown what would cause a missing line number.
                warning.symbol,
                ""
                ].joinAsLines().formattedAsError())
        }

        if warnings.isEmpty {
            validationStatus.passStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Documentation coverage is complete for “" + StrictString(target) + "”."
                }
            }))
        } else {
            validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Documentation coverage is incomplete for “" + StrictString(target) + "”." + section.crossReference.resolved(for: localization)
                }
            }))
        }
    }

    #endif
}
