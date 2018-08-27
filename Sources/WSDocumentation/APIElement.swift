/*
 APIElement.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGSwiftSource

import WSProject

extension APIElement {

    internal var fileName: StrictString {
        return Page.sanitize(fileName: StrictString(name))
    }

    internal var relativePagePath: [LocalizationIdentifier: StrictString] {
        get {
            return (userInformation as? [LocalizationIdentifier: StrictString]) ?? [:]
        }
        set {
            userInformation = newValue
        }
    }

    internal func pageURL(in outputDirectory: URL, for localization: LocalizationIdentifier) -> URL {
        return outputDirectory.appendingPathComponent(String(relativePagePath[localization]!))
    }

    internal func determinePaths(for localizations: [LocalizationIdentifier]) {
        for localization in localizations {
            var result = StrictString(localization.code) + "/"

            result += fileName + ".html"
            relativePagePath[localization] = result
        }
    }
}
