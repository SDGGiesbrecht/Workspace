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

    init(localizations: [LocalizationIdentifier], name: String, modules: [ModuleAPI]) {
        self.localizations = localizations
        self.exactName = name.decomposedStringWithCanonicalMapping
        self.name = StrictString(name)
        self.modules = modules
    }

    // MARK: - Properties

    internal var localizations: [LocalizationIdentifier]
    internal var exactName: String
    internal var name: StrictString
    internal var modules: [ModuleAPI]

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
    }
}
