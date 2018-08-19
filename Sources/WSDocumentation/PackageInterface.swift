/*
 PackageInterface.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

import SDGSwiftSource

import WorkspaceConfiguration

internal struct PackageInterface {

    // MARK: - Initialization

    init(localizations: [LocalizationIdentifier], developmentLocalization: LocalizationIdentifier, name: String, modules: [ModuleAPI]) {
        self.localizations = localizations
        self.developmentLocalization = developmentLocalization
        self.exactName = name.decomposedStringWithCanonicalMapping
        self.name = StrictString(name)
        self.modules = modules
    }

    // MARK: - Properties

    internal let localizations: [LocalizationIdentifier]
    internal let developmentLocalization: LocalizationIdentifier
    internal let exactName: String
    internal let name: StrictString
    internal let modules: [ModuleAPI]

    // MARK: - Output

    internal func outputHTML(to outputDirectory: URL) throws {
        try outputPackagePages(to: outputDirectory)
    }

    private func outputPackagePages(to outputDirectory: URL) throws {
        for localization in localizations {
            let page = Page(title: name, localization: localization)

            let localizationDirectory = outputDirectory.appendingPathComponent(localization.code)
            let redirectURL = localizationDirectory.appendingPathComponent("index.html")
            let pageURL = localizationDirectory.appendingPathComponent(String(name) + ".html")
            if redirectURL ≠ pageURL {
                try Redirect(target: pageURL.lastPathComponent).contents.save(to: redirectURL)
            }
            try page.contents.save(to: pageURL)
        }
        try Redirect(target: developmentLocalization.code + "/index.html").contents.save(to: outputDirectory.appendingPathComponent("index.html"))
    }
}
