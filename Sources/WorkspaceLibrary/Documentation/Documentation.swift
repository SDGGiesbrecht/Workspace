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

    static func document(target: String, for project: PackageRepository, output: inout Command.Output) throws {

        let outputDirectory = documentationDirectory(for: project).appendingPathComponent(target)

        let macOSSDK = "macosx"
        let sdk: String
        if try project.configuration.supports(.macOS) {
            sdk = macOSSDK
        } else if try project.configuration.supports(.iOS) {
            sdk = "iphoneos"
        } else if try project.configuration.supports(.watchOS) {
            sdk = "watchos"
        } else if try project.configuration.supports(.tvOS) {
            sdk = "appletvos"
        } else {
            sdk = macOSSDK
        }

        let copyrightText = try copyright(for: outputDirectory, in: project)
        try Jazzy.default.document(target: target, scheme: try project.configuration.xcodeScheme(), sdk: sdk, copyright: copyrightText, gitHubURL: try project.configuration.repositoryURL(), outputDirectory: outputDirectory, output: &output)

        notImplementedYet()
        /*

         func generate(operatingSystemName: String, sdk: String, output: inout Command.Output, condition: String? = nil) {

         if let github = Configuration.repositoryURL {
         }

         requireBash(["touch", "docs/.nojekyll"])

         if jazzyResult.succeeded {
         individualSuccess("Generated documentation for \(operatingSystemName).")
         } else {
         individualFailure("Failed to generate documentation for \(operatingSystemName).")
         }

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
