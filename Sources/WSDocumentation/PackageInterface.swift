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
import SDGCollections
import WSGeneralImports

import SDGSwiftSource

import WorkspaceConfiguration

internal struct PackageInterface {

    // MARK: - Initialization

    init(localizations: [LocalizationIdentifier], developmentLocalization: LocalizationIdentifier, api: PackageAPI) {
        self.localizations = localizations
        self.developmentLocalization = developmentLocalization
        self.api = api

        self.packageIdentifiers = api.identifierList

        var paths: [LocalizationIdentifier: [String: String]] = [:]
        for localization in localizations {
            paths[localization] = api.determinePaths(for: localization)
        }
        self.symbolLinks = paths
    }

    // MARK: - Properties

    private let localizations: [LocalizationIdentifier]
    private let developmentLocalization: LocalizationIdentifier
    private let api: PackageAPI
    private let packageIdentifiers: Set<String>
    private let symbolLinks: [LocalizationIdentifier: [String: String]]

    // MARK: - Output

    internal func outputHTML(to outputDirectory: URL, status: DocumentationStatus, output: Command.Output) throws {
        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Generating HTML..."
            }
        }).resolved())

        try outputPackagePages(to: outputDirectory, status: status)
        try outputLibraryPages(to: outputDirectory, status: status)
        try outputModulePages(to: outputDirectory, status: status)
        try outputTopLevelSymbols(to: outputDirectory, status: status)
    }

    private func outputPackagePages(to outputDirectory: URL, status: DocumentationStatus) throws {
        try Redirect(target: String(developmentLocalization.directoryName) + "/index.html").contents.save(to: outputDirectory.appendingPathComponent("index.html"))
        for localization in localizations {
            let localizationDirectory = outputDirectory.appendingPathComponent(String(localization.directoryName))
            let redirectURL = localizationDirectory.appendingPathComponent("index.html")
            let pageURL = api.pageURL(in: outputDirectory, for: localization)
            if redirectURL ≠ pageURL {
                try Redirect(target: pageURL.lastPathComponent).contents.save(to: redirectURL)
            }

            try SymbolPage(localization: localization, pathToSiteRoot: "../", navigationPath: [api], symbol: api, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks[localization]!, status: status).contents.save(to: pageURL)
        }
    }

    private func outputLibraryPages(to outputDirectory: URL, status: DocumentationStatus) throws {
        for localization in localizations {
            var redirected: Void?
            for library in api.libraries {
                let location = library.pageURL(in: outputDirectory, for: localization)
                _ = try cached(in: &redirected) {
                    try Redirect(target: "../index.html").contents.save(to: location.deletingLastPathComponent().appendingPathComponent("index.html"))
                    return ()
                }
                try SymbolPage(localization: localization, pathToSiteRoot: "../../", navigationPath: [api, library], symbol: library, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks[localization]!, status: status).contents.save(to: location)
            }
        }
    }

    private func outputModulePages(to outputDirectory: URL, status: DocumentationStatus) throws {
        for localization in localizations {
            var redirected: Void?
            for module in api.modules {
                let location = module.pageURL(in: outputDirectory, for: localization)
                _ = try cached(in: &redirected) {
                    try Redirect(target: "../index.html").contents.save(to: location.deletingLastPathComponent().appendingPathComponent("index.html"))
                    return ()
                }
                try SymbolPage(localization: localization, pathToSiteRoot: "../../", navigationPath: [api, module], symbol: module, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks[localization]!, status: status).contents.save(to: location)
            }
        }
    }

    private func outputTopLevelSymbols(to outputDirectory: URL, status: DocumentationStatus) throws {
        for localization in localizations {
            var redirected: Set<URL> = []
            for module in api.modules {
                for symbol in module.children {
                    let location = symbol.pageURL(in: outputDirectory, for: localization)
                    let directory = location.deletingLastPathComponent()
                    if directory ∉ redirected {
                        redirected.insert(directory)
                        try Redirect(target: "../index.html").contents.save(to: directory.appendingPathComponent("index.html"))
                    }
                    try SymbolPage(localization: localization, pathToSiteRoot: "../../", navigationPath: [api, symbol], symbol: symbol, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks[localization]!, status: status).contents.save(to: location)

                    if let scope = symbol as? APIScope {
                        try outputNestedSymbols(of: scope, namespace: [scope], to: outputDirectory, localization: localization, status: status)
                    }
                }
            }
        }
    }

    private func outputNestedSymbols(of parent: APIScope, namespace: [APIScope], to outputDirectory: URL, localization: LocalizationIdentifier, status: DocumentationStatus) throws {
        var redirected: Set<URL> = []
        for symbol in parent.children where symbol.receivesPage {
            let location = symbol.pageURL(in: outputDirectory, for: localization)
            let directory = location.deletingLastPathComponent()
            if directory ∉ redirected {
                redirected.insert(directory)
                try Redirect(target: "../index.html").contents.save(to: directory.appendingPathComponent("index.html"))
            }

            var modifiedRoot: StrictString = "../../"
            for _ in namespace.indices {
                modifiedRoot += "../".scalars
            }

            var navigation: [APIElement] = [api]
            navigation += namespace as [APIElement]
            navigation += [symbol]

            try SymbolPage(localization: localization, pathToSiteRoot: modifiedRoot, navigationPath: navigation, symbol: symbol, packageIdentifiers: packageIdentifiers, symbolLinks: symbolLinks[localization]!, status: status).contents.save(to: location)

            if let scope = symbol as? APIScope {
                try outputNestedSymbols(of: scope, namespace: namespace + [scope], to: outputDirectory, localization: localization, status: status)
            }
        }
    }
}
