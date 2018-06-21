/*
 Documentation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import WSGeneralImports

import WSProject

enum Documentation {

    static let defaultDocumentationDirectoryName = "docs" // Matches GitHub Pages.
    static func defaultDocumentationDirectory(for project: PackageRepository) -> URL {
        return project.location.appendingPathComponent(defaultDocumentationDirectoryName)
    }
    static func subdirectory(for target: String, in documentationDirectory: URL) -> URL {
        return documentationDirectory.appendingPathComponent(target)
    }

    private static func copyright(for project: PackageRepository) throws -> StrictString {

        var template = try project.documentationCopyright()

        let dates: StrictString
        if let specified = try project.configuration().documentation.api.yearFirstPublished {
            dates = StrictString(FileHeaders.copyright(fromText: "©\(specified.inEnglishDigits())"))
        } else {
            dates = StrictString(FileHeaders.copyright(fromText: ""))
        }
        template.replaceMatches(for: "#dates", with: dates)

        return template
    }

    #if !os(Linux)

    static func document(target: String, for project: PackageRepository, outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Generating documentation for “" + StrictString(target) + "”..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        do {

            let outputSubdirectory = subdirectory(for: target, in: outputDirectory)

            let buildOperatingSystem: OperatingSystem
            if try .macOS ∈ project.configuration().supportedOperatingSystems {
                buildOperatingSystem = .macOS
            } else if try .iOS ∈ project.configuration().supportedOperatingSystems {
                buildOperatingSystem = .iOS
            } else if try .watchOS ∈ project.configuration().supportedOperatingSystems {
                buildOperatingSystem = .watchOS
            } else if try .tvOS ∈ project.configuration().supportedOperatingSystems {
                buildOperatingSystem = .tvOS
            } else {
                buildOperatingSystem = .macOS
            }

            let copyrightText = try copyright(for: project)
            try FileManager.default.do(in: project.location) {
                try Jazzy.default.document(target: target, scheme: try project.scheme(), buildOperatingSystem: buildOperatingSystem, copyright: copyrightText, gitHubURL: try project.configuration().documentation.repositoryURL, outputDirectory: outputSubdirectory, project: project, output: output)
            }

            let transformedMarker = ReadMeConfiguration._skipInJazzy.replacingMatches(for: "\u{2D}\u{2D}".scalars, with: "&ndash;".scalars).replacingMatches(for: "<".scalars, with: "&lt;".scalars).replacingMatches(for: ">".scalars, with: "&gt;".scalars)
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

        } catch {
            output.print(error.localizedDescription.formattedAsError()) // [_Exempt from Test Coverage_]
            validationStatus.failStep(message: UserFacing({ localization in
                switch localization {
                case .englishCanada:
                    return "Failed to generate documentation for “" + StrictString(target) + "”." + section.crossReference.resolved(for: localization)
                }
            }))
        }
    }

    static func validateDocumentationCoverage(for target: String, in project: PackageRepository, outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Checking documentation coverage for “" + StrictString(target) + "”..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        do {

            let warnings = try Jazzy.default.warnings(outputDirectory: subdirectory(for: target, in: outputDirectory))

            for warning in warnings {
                output.print([
                    warning.file.path(relativeTo: project.location) + ":" + String(warning.line?.inDigits() ?? ""), // [_Exempt from Test Coverage_] It is unknown what would cause a missing line number.
                    warning.symbol,
                    ""
                    ].joinedAsLines().formattedAsError())
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
        } catch {
            output.print(error.localizedDescription.formattedAsError()) // [_Exempt from Test Coverage_]
            validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Documentation coverage information is unavailable for “" + StrictString(target) + "”." + section.crossReference.resolved(for: localization)
                }
            }))
        }
    }

    #endif
}
