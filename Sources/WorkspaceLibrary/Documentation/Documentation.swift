/*
 Documentation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

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

    private static func copyright(for directory: URL, in project: PackageRepository, output: inout Command.Output) throws -> StrictString {

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

        template.insert(dates, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Copyright"
            }
        }))
        try template.insert(resultOf: { try project.configuration.requireAuthor() }, for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Author"
            }
        }))
        template.insert(try project.projectName(output: &output), for: UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                return "Project"
            }
        }))

        return template.text
    }

    #if !os(Linux)

    static func document(target: String, for project: PackageRepository, outputDirectory: URL, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {

        print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "Generating documentation for “" + StrictString(target) + "”..."
            }
        }).resolved().formattedAsSectionHeader(), to: &output)

        let outputSubdirectory = subdirectory(for: target, in: outputDirectory)

        let buildOperatingSystem: OperatingSystem
        if try project.configuration.supports(.macOS) {
            buildOperatingSystem = .macOS
        } else if try project.configuration.supports(.iOS) {
            buildOperatingSystem = .iOS
        } else if try project.configuration.supports(.watchOS) {
            buildOperatingSystem = .watchOS
        } else if try project.configuration.supports(.tvOS) {
            buildOperatingSystem = .tvOS
        } else {
            buildOperatingSystem = .macOS
        }

        let copyrightText = try copyright(for: outputSubdirectory, in: project, output: &output)
        try FileManager.default.do(in: project.location) {
            try Jazzy.default.document(target: target, scheme: try project.xcodeScheme(output: &output), buildOperatingSystem: buildOperatingSystem, copyright: copyrightText, gitHubURL: try project.configuration.repositoryURL(), outputDirectory: outputSubdirectory, project: project, output: &output)
        }

        let transformedMarker = ReadMe.skipInJazzy.replacingMatches(for: "\u{2D}\u{2D}".scalars, with: "&ndash;".scalars).replacingMatches(for: "<".scalars, with: "&lt;".scalars).replacingMatches(for: ">".scalars, with: "&gt;".scalars)
        for url in try project.trackedFiles(output: &output) where url.is(in: outputSubdirectory) {
            if let type = try? FileType(url: url),
                type == .html {

                var file = try TextFile(alreadyAt: url)
                var source = file.contents
                while let skipMarker = source.scalars.firstMatch(for: transformedMarker.scalars) {
                    let line = skipMarker.range.lines(in: source.lines)
                    source.lines.removeSubrange(line)
                }

                file.contents = source
                try file.writeChanges(for: project, output: &output)
            }
        }

        validationStatus.passStep(message: UserFacingText({ localization, _ in
            switch localization {
            case .englishCanada:
                return "Generated documentation for “" + StrictString(target) + "”."
            }
        }))
    }

    static func validateDocumentationCoverage(for target: String, in project: PackageRepository, outputDirectory: URL, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {

        let section = validationStatus.newSection()

        print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "Checking documentation coverage for “" + StrictString(target) + "”..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader(), to: &output)

        let warnings = try Jazzy.default.warnings(outputDirectory: subdirectory(for: target, in: outputDirectory))

        for warning in warnings {
            print([
                warning.file.path(relativeTo: project.location) + ":" + String(warning.line?.inDigits() ?? ""), // [_Exempt from Code Coverage_] It is unknown what would cause a missing line number.
                warning.symbol,
                ""
                ].joinAsLines().formattedAsError(), to: &output)
        }

        if warnings.isEmpty {
            validationStatus.passStep(message: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                switch localization {
                case .englishCanada:
                    return "Documentation coverage is complete for “" + StrictString(target) + "”."
                }
            }))
        } else {
            validationStatus.failStep(message: UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
                switch localization {
                case .englishCanada:
                    return "Documentation coverage is incomplete for “" + StrictString(target) + "”." + section.crossReference.resolved(for: localization)
                }
            }))
        }
    }

    #endif
}
