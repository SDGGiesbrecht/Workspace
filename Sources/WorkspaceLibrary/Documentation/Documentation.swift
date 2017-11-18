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

import SDGCornerstone
import SDGCommandLine

enum Documentation {

    static func documentationDirectory(for project: PackageRepository) -> URL {
        return project.location.appendingPathComponent("docs")
    }
    static func documentationDirectory(for target: String, in project: PackageRepository) -> URL {
        return documentationDirectory(for: project).appendingPathComponent(target)
    }

    private static func copyright(for directory: URL, in project: PackageRepository) throws -> StrictString {

        let existing = try TextFile(possiblyAt: directory.appendingPathComponent("index.html")).contents
        let searchArea: String
        if let footerStart = existing.range(of: "<section id=\u{22}footer\u{22}>")?.upperBound {
            searchArea = String(existing[footerStart...])
        } else {
            searchArea = ""
        }
        let dates = StrictString(FileHeaders.copyright(fromText: searchArea))

        var template = try project.configuration.documentationCopyright()

        template.insert(dates, for: "Copyright")
        try template.insert(resultOf: { try project.configuration.author() }, for: "Author")
        template.insert(try project.configuration.projectName(), for: "Project")

        return template.text
    }

    static func document(target: String, for project: PackageRepository, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {

        print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "Generating documentation for “" + StrictString(target) + "”..."
            }
        }).resolved().formattedAsSectionHeader(), to: &output)

        let outputDirectory = documentationDirectory(for: target, in: project)

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

        let copyrightText = try copyright(for: outputDirectory, in: project)
        try FileManager.default.do(in: project.location) {
            try Jazzy.default.document(target: target, scheme: try project.configuration.xcodeScheme(), buildOperatingSystem: buildOperatingSystem, copyright: copyrightText, gitHubURL: try project.configuration.repositoryURL(), outputDirectory: outputDirectory, project: project, output: &output)
        }

        for url in try project.trackedFiles(output: &output) where url.is(in: outputDirectory) {
            if let type = try? FileType(url: url),
                type == .html {

                let transformedMarker = ReadMe.skipInJazzy.replacingOccurrences(of: "\u{2D}\u{2D}", with: "&ndash;").replacingOccurrences(of: "<", with: "&lt;").replacingOccurrences(of: ">", with: "&gt;")

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

    static func validateDocumentationCoverage(for target: String, in project: PackageRepository, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {

        print(UserFacingText<InterfaceLocalization, Void>({ (localization: InterfaceLocalization, _) -> StrictString in
            switch localization {
            case .englishCanada:
                return "Checking documentation coverage for “" + StrictString(target) + "”..."
            }
        }).resolved().formattedAsSectionHeader(), to: &output)

        let warnings = try Jazzy.default.warnings(outputDirectory: documentationDirectory(for: target, in: project))

        for warning in warnings {
            print(join(lines: [
                warning.file.path(relativeTo: project.location),
                String(warning.line.inDigits()),
                warning.symbol
                ]).formattedAsError(), to: &output)
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
                    return "Documentation coverage is incomplete for “" + StrictString(target) + "”. (See above for details.)"
                }
            }))
        }
    }
}
