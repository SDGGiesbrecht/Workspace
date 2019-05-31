/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import WSProject
import WSExamples

import SDGSwiftSource

extension PackageRepository {

    private func refreshReadMe(at location: URL, for localization: LocalizationIdentifier, output: Command.Output) throws {

        guard var readMe = try readMe(output: output)[localization] else {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ errorLocalization in
                switch errorLocalization {
                case .englishCanada:
                    return "There is no read‐me for “\(arbitraryDescriptionOf: localization)”. (documentation.readMe.contents)"
                }
            }))
        }

        var fromDocumentation: StrictString = ""
        #warning("Should localize.")
        if let documentation = try? PackageAPI.documentation(for: package().get()).last?.documentationComment {
            if let description = documentation.descriptionSection {
                fromDocumentation.append(contentsOf: description.text.scalars)
            }
            for paragraph in documentation.discussionEntries {
                fromDocumentation.append(contentsOf: paragraph.text.scalars)
            }
        }
        readMe.replaceMatches(for: "#packageDocumentation".scalars, with: fromDocumentation)

        // Word Elements

        for (key, example) in try examples(output: output) {
            readMe.replaceMatches(for: "\u{23}example(\(key))", with: [
                "```swift",
                StrictString(example),
                "```"
                ].joinedAsLines())
        }

        var file = try TextFile(possiblyAt: location)
        file.body = String(readMe)
        try file.writeChanges(for: self, output: output)
    }

    public func refreshReadMe(output: Command.Output) throws {

        try refreshReadMe(at: location.appendingPathComponent("README.md"), for: try developmentLocalization(output: output), output: output)

        // Deprecated file locations.
        delete(location.appendingPathComponent("Documentation/Related Projects.md"), output: output)
        for localization in try configuration(output: output).documentation.localizations {
            autoreleasepool {
                delete(ReadMeConfiguration._readMeLocation(for: location, localization: localization), output: output)
                delete(ReadMeConfiguration._relatedProjectsLocation(for: location, localization: localization), output: output)
            }
        }
    }
}
