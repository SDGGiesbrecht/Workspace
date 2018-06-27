/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import WSGeneralImports

import SDGXcode

import WSProject
import WSValidation
import WSXcode

extension PackageRepository {

    // MARK: - Static Properties

    public static let documentationDirectoryName = "docs" // Matches GitHub Pages.

    // MARK: - Properties

    public func hasTargetsToDocument() throws -> Bool {
        return try cachedPackage().products.contains(where: { $0.type.isLibrary })
    }

    // MARK: - Configuration

    public var defaultDocumentationDirectory: URL {
        return location.appendingPathComponent(PackageRepository.documentationDirectoryName)
    }

    private static func subdirectory(for target: String, in documentationDirectory: URL) -> URL {
        return documentationDirectory.appendingPathComponent(target)
    }

    private func resolvedCopyright(output: Command.Output) throws -> StrictString {

        var template = try documentationCopyright(output: output)

        let dates: StrictString
        if let specified = try configuration(output: output).documentation.api.yearFirstPublished {
            dates = StrictString(WSProject.copyright(fromText: "©\(specified.inEnglishDigits())"))
        } else {
            dates = StrictString(WSProject.copyright(fromText: ""))
        }
        template.replaceMatches(for: "#dates", with: dates)

        return template
    }

    // MARK: - Documentation

    #if !os(Linux)
    // MARK: - #if os(Linux)

    public func document(outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        for product in try productModules() {
            try autoreleasepool {
                try document(target: product.name, outputDirectory: outputDirectory, validationStatus: &validationStatus, output: output)
            }
        }
    }

    private func document(target: String, outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Generating documentation for “" + StrictString(target) + "”..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        do {

            let outputSubdirectory = PackageRepository.subdirectory(for: target, in: outputDirectory)

            let buildOperatingSystem: OperatingSystem
            if try .macOS ∈ configuration(output: output).supportedOperatingSystems {
                buildOperatingSystem = .macOS
            } else if try .iOS ∈ configuration(output: output).supportedOperatingSystems {
                buildOperatingSystem = .iOS
            } else if try .watchOS ∈ configuration(output: output).supportedOperatingSystems {
                buildOperatingSystem = .watchOS
            } else if try .tvOS ∈ configuration(output: output).supportedOperatingSystems {
                buildOperatingSystem = .tvOS
            } else {
                buildOperatingSystem = .macOS
            }

            let copyrightText = try resolvedCopyright(output: output)
            try FileManager.default.do(in: location) {
                try Jazzy.default.document(target: target, scheme: try scheme(), buildOperatingSystem: buildOperatingSystem, copyright: copyrightText, gitHubURL: try configuration(output: output).documentation.repositoryURL, outputDirectory: outputSubdirectory, project: self, output: output)
            }

            let transformedMarker = ReadMeConfiguration._skipInJazzy.replacingMatches(for: "\u{2D}\u{2D}".scalars, with: "&ndash;".scalars).replacingMatches(for: "<".scalars, with: "&lt;".scalars).replacingMatches(for: ">".scalars, with: "&gt;".scalars)
            for url in try trackedFiles(output: output) where url.is(in: outputSubdirectory) {
                if let type = FileType(url: url),
                    type == .html {
                    try autoreleasepool {

                        var file = try TextFile(alreadyAt: url)
                        var source = file.contents
                        while let skipMarker = source.scalars.firstMatch(for: transformedMarker.scalars) {
                            let line = skipMarker.range.lines(in: source.lines)
                            source.lines.removeSubrange(line)
                        }

                        file.contents = source
                        try file.writeChanges(for: self, output: output)
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
            var description = StrictString(error.localizedDescription)
            if let noXcode = error as? Xcode.Error,
                noXcode == .noXcodeProject {
                description += "\n" + PackageRepository.xcodeProjectInstructions.resolved()
            }
            output.print(description.formattedAsError())

            validationStatus.failStep(message: UserFacing({ localization in
                switch localization {
                case .englishCanada:
                    return "Failed to generate documentation for “" + StrictString(target) + "”." + section.crossReference.resolved(for: localization)
                }
            }))
        }
    }

    public func validateDocumentationCoverage(outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        for product in try productModules() {
            try autoreleasepool {
                try validateDocumentationCoverage(for: product.name, outputDirectory: outputDirectory, validationStatus: &validationStatus, output: output)
            }
        }
    }

    private func validateDocumentationCoverage(for target: String, outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Checking documentation coverage for “" + StrictString(target) + "”..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        do {

            let warnings = try Jazzy.default.warnings(outputDirectory: PackageRepository.subdirectory(for: target, in: outputDirectory))

            for warning in warnings {
                output.print([
                    warning.file.path(relativeTo: location) + ":" + String(warning.line?.inDigits() ?? ""), // [_Exempt from Test Coverage_] It is unknown what would cause a missing line number.
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
            output.print(error.localizedDescription.formattedAsError())
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
