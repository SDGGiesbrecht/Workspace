/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports
import WSProject

extension PackageRepository {

    public func refreshLicence(output: Command.Output) throws {

        guard let licence = try configuration(output: output).licence.licence else {
            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return StrictString("No licence has been selected. (licence.licence)")
                }
            }))
        }

        var text = licence.text

        var file = try TextFile(possiblyAt: location.appendingPathComponent("LICENSE.md"))
        let oldContents = file.contents

        let copyright = WSProject.copyright(fromText: oldContents)
        var authors: StrictString = "the " + StrictString(try projectName()) + " project contributors."
        if let configuredAuthor = try configuration(output: output).documentation.primaryAuthor {
            authors = configuredAuthor + " and " + authors
        }

        text.scalars.replaceMatches(for: "#copyright".scalars, with: copyright)
        text.scalars.replaceMatches(for: "#authors".scalars, with: authors)

        file.contents = String(text)
        try file.writeChanges(for: self, output: output)

        // Delete alternate licence files to prevent duplicates.
        delete(location.appendingPathComponent("LICENSE.txt"), output: output)
    }
}
