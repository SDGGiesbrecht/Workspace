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

    static func document(target: String, for project: PackageRepository, validationStatus: inout ValidationStatus, output: inout Command.Output) throws {

        let outputDirectory = documentationDirectory(for: project).appendingPathComponent(target)

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
        project.resetCache(debugReason: "jazzy")

        validationStatus.passStep(message: UserFacingText({ localization, _ in
            switch localization {
            case .englishCanada:
                return "Generated documentation for " + StrictString(target) + "."
            }
        }))

        notImplementedYet()
        /*

         if jazzyResult.succeeded ∧ Configuration.enforceDocumentationCoverage {

         // ••••••• ••••••• ••••••• ••••••• ••••••• ••••••• •••••••
         print("Checking documentation coverage for \(operatingSystemName)...".formattedAsSectionHeader(), to: &output)
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

         if job == .documentation ∨ job == nil {
         generate(operatingSystemName: "macOS", sdk: "macosx", output: &output)
         }

         for path in Repository.trackedFiles(at: RelativePath("docs")) {
         if let fileType = FileType(filePath: path),
         fileType == .html {

         var file = require() { try File(at: path) }
         var source = file.contents

         let tokens = ("<span class=\u{22}err\u{22}>", "</span>")
         while let error = source.scalars.firstNestingLevel(startingWith: tokens.0.scalars, endingWith: tokens.1.scalars) {

         func parseError() -> Never {
         fatalError(message: [
         "Error parsing HTML:",
         "",
         String(error.container.contents),
         "",
         "This may indicate a bug in Workspace."
         ])
         }

         guard let first = error.contents.contents.first else {
         parseError()
         }

         if first ∈ CharacterSet.nonBaseCharacters {
         guard let division = source.scalars.firstMatch(for: "</span><span class=\u{22}err\u{22}>".scalars) else {
         parseError()
         }
         source.scalars.removeSubrange(division.range)
         } else {
         guard let `class` = source.scalars.firstNestingLevel(startingWith: "<span class=\u{22}".scalars, endingWith: "\u{22}>".scalars, in: error.container.range)?.contents.range else {
         parseError()
         }

         if first ∈ operatorCharacters {
         source.scalars.replaceSubrange(`class`, with: "o".scalars)
         } else {
         source.scalars.replaceSubrange(`class`, with: "n".scalars)
         }
         }
         }

         while let shouldRemove = source.range(of: ReadMe.skipInJazzy.replacingOccurrences(of: "\u{2D}\u{2D}", with: "&ndash;").replacingOccurrences(of: "<", with: "&lt;").replacingOccurrences(of: ">", with: "&gt;")) {
         let relatedLine = source.lineRange(for: shouldRemove)
         source.removeSubrange(relatedLine)
         }

         file.contents = source
         require() { try file.write(output: &output) }
         }*/
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
}
