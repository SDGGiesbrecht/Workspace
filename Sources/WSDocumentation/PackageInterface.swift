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

    init(localizations: [LocalizationIdentifier], developmentLocalization: LocalizationIdentifier, api: PackageAPI) {
        self.localizations = localizations
        self.developmentLocalization = developmentLocalization
        self.api = api
    }

    // MARK: - Properties

    private let localizations: [LocalizationIdentifier]
    private let developmentLocalization: LocalizationIdentifier
    private let api: PackageAPI

    private class Cache {
        fileprivate init() {}
        fileprivate var packageIdentifiers: Set<String>?
    }
    private let cache = Cache()

    private var packageIdentifiers: Set<String> {
        return cached(in: &cache.packageIdentifiers) {
            return api.identifierList
        }
    }

    // MARK: - Output

    internal func outputHTML(to outputDirectory: URL, status: DocumentationStatus) throws {
        try outputPackagePages(to: outputDirectory, status: status)
    }

    private func outputPackagePages(to outputDirectory: URL, status: DocumentationStatus) throws {
        try Redirect(target: developmentLocalization.code + "/index.html").contents.save(to: outputDirectory.appendingPathComponent("index.html"))
        for localization in localizations {
            let localizationDirectory = outputDirectory.appendingPathComponent(localization.code)
            let redirectURL = localizationDirectory.appendingPathComponent("index.html")
            let pageURL = localizationDirectory.appendingPathComponent(api.name + ".html")
            if redirectURL ≠ pageURL {
                try Redirect(target: pageURL.lastPathComponent).contents.save(to: redirectURL)
            }

            try SymbolPage(localization: localization, pathToSiteRoot: "../", navigationPath: [api], symbol: api, packageIdentifiers: packageIdentifiers, status: status).contents.save(to: pageURL)
        }
    }
}
