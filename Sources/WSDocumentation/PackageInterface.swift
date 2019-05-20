/*
 PackageInterface.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import SDGSwiftSource
import enum SDGHTML.HTML
import struct SDGHTML.ElementSyntax

import WorkspaceConfiguration

internal struct PackageInterface {

    private static func specify(package: URL?, version: Version?) -> StrictString? {
        guard let specified = package else {
            return nil
        }
        let packageURL = StrictString(specified.absoluteString)

        var result = [
            ElementSyntax("span", attributes: ["class": "punctuation"], contents: ".", inline: true).normalizedSource(),
            ElementSyntax("span", attributes: ["class": "external identifier"], contents: "package", inline: true).normalizedSource(),
            ElementSyntax("span", attributes: ["class": "punctuation"], contents: "(", inline: true).normalizedSource(),
            ElementSyntax("span", attributes: ["class": "external identifier"], contents: "url", inline: true).normalizedSource(),
            ElementSyntax("span", attributes: ["class": "punctuation"], contents: ":", inline: true).normalizedSource(),
            " ",
            ElementSyntax("span", attributes: ["class": "string"], contents: [
                ElementSyntax("span", attributes: ["class": "punctuation"], contents: "\u{22}", inline: true).normalizedSource(),
                ElementSyntax("a", attributes: ["href": packageURL], contents: [
                    ElementSyntax(
                        "span",
                        attributes: ["class": "text"],
                        contents: HTML.escapeTextForCharacterData(packageURL),
                        inline: true).normalizedSource()
                    ].joined(), inline: true).normalizedSource(),
                ElementSyntax("span", attributes: ["class": "punctuation"], contents: "\u{22}", inline: true).normalizedSource()
                ].joined(), inline: true).normalizedSource()
            ].joined()

        if let specified = specify(version: version) {
            result.append(contentsOf: [
                ElementSyntax("span", attributes: ["class": "punctuation"], contents: ",", inline: true).normalizedSource(),
                " ",
                specified
                ].joined())
        }

        result.append(contentsOf: ElementSyntax("span", attributes: ["class": "punctuation"], contents: ")", inline: true).normalizedSource())

        return ElementSyntax("span", attributes: ["class": "swift blockquote"], contents: result, inline: true).normalizedSource()
    }

    private static func specify(version: Version?) -> StrictString? {
        guard let specified = version else {
            return nil
        }

        var result = [
            ElementSyntax("span", attributes: ["class": "external identifier"], contents: "from", inline: true).normalizedSource(),
            ElementSyntax("span", attributes: ["class": "punctuation"], contents: ":", inline: true).normalizedSource(),
            " ",
            ElementSyntax("span", attributes: ["class": "string"], contents: [
                ElementSyntax("span", attributes: ["class": "punctuation"], contents: "\u{22}", inline: true).normalizedSource(),
                ElementSyntax("span", attributes: ["class": "text"], contents: StrictString(specified.string()), inline: true).normalizedSource(),
                ElementSyntax("span", attributes: ["class": "punctuation"], contents: "\u{22}", inline: true).normalizedSource()
                ].joined(), inline: true).normalizedSource()
            ].joined()

        if specified.major == 0 {
            result = [
                ElementSyntax("span", attributes: ["class": "punctuation"], contents: ".", inline: true).normalizedSource(),
                ElementSyntax("span", attributes: ["class": "external identifier"], contents: "upToNextMinor", inline: true).normalizedSource(),
                ElementSyntax("span", attributes: ["class": "punctuation"], contents: "(", inline: true).normalizedSource(),
                result,
                ElementSyntax("span", attributes: ["class": "punctuation"], contents: ")", inline: true).normalizedSource()
                ].joined()
        }

        return result
    }

    private static func generateIndices(
        for package: PackageAPI,
        about: [LocalizationIdentifier: StrictString],
        localizations: [LocalizationIdentifier]) -> [LocalizationIdentifier: StrictString] {
        var result: [LocalizationIdentifier: StrictString] = [:]
        for localization in localizations {
            autoreleasepool {
                result[localization] = generateIndex(
                    for: package,
                    hasAbout: about[localization] ≠ nil,
                    localization: localization)
            }
        }
        return result
    }

    private static func packageHeader(localization: LocalizationIdentifier) -> StrictString {
        if let match = localization._reasonableMatch {
            switch match {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Package"
            }
        } else {
            return "Package" // From “let ... = Package(...)”
        }
    }

    private static func generateIndex(
        for package: PackageAPI,
        hasAbout: Bool,
        localization: LocalizationIdentifier) -> StrictString {
        var result: [StrictString] = []

        result.append(generateIndexSection(named: packageHeader(localization: localization), contents: [
            ElementSyntax(
                "a",
                attributes: [
                "href": "[*site root*]\(HTML.percentEncodeURLPath(APIElement.package(package).relativePagePath[localization]!))"
                ],
                contents: HTML.escapeTextForCharacterData(StrictString(package.name.source())),
                inline: false).normalizedSource()
            ].joinedAsLines()))

        if ¬package.libraries.isEmpty {
            result.append(generateIndexSection(named: SymbolPage.librariesHeader(localization: localization), apiEntries: package.libraries.lazy.map({ APIElement.library($0) }), localization: localization))
        }
        if ¬package.modules.isEmpty {
            result.append(generateIndexSection(named: SymbolPage.modulesHeader(localization: localization), apiEntries: package.modules.lazy.map({ APIElement.module($0) }), localization: localization))
        }
        if ¬package.types.isEmpty {
            result.append(generateIndexSection(named: SymbolPage.typesHeader(localization: localization), apiEntries: package.types.lazy.map({ APIElement.type($0) }), localization: localization))
        }
        if ¬package.uniqueExtensions.isEmpty {
            result.append(generateIndexSection(named: SymbolPage.extensionsHeader(localization: localization), apiEntries: package.uniqueExtensions.lazy.map({ APIElement.extension($0) }), localization: localization))
        }
        if ¬package.protocols.isEmpty {
            result.append(generateIndexSection(named: SymbolPage.protocolsHeader(localization: localization), apiEntries: package.protocols.lazy.map({ APIElement.protocol($0) }), localization: localization))
        }
        if ¬package.functions.isEmpty {
            result.append(generateIndexSection(named: SymbolPage.functionsHeader(localization: localization), apiEntries: package.functions.lazy.map({ APIElement.function($0) }), localization: localization))
        }
        if ¬package.globalVariables.isEmpty {
            result.append(generateIndexSection(named: SymbolPage.variablesHeader(localization: localization), apiEntries: package.globalVariables.lazy.map({ APIElement.variable($0) }), localization: localization))
        }
        if ¬package.operators.isEmpty {
            result.append(generateIndexSection(named: SymbolPage.operatorsHeader(localization: localization), apiEntries: package.operators.lazy.map({ APIElement.operator($0) }), localization: localization))
        }
        if ¬package.functions.isEmpty {
            result.append(generateIndexSection(named: SymbolPage.precedenceGroupsHeader(localization: localization), apiEntries: package.precedenceGroups.lazy.map({ APIElement.precedence($0) }), localization: localization))
        }

        if hasAbout {
            result.append(generateLoneIndexEntry(
                named: about(localization: localization),
                target: aboutLocation(localization: localization)))
        }

        return result.joinedAsLines()
    }

    private static func generateIndexSection(named name: StrictString, apiEntries: [APIElement], localization: LocalizationIdentifier) -> StrictString {
        var entries: [StrictString] = []
        for entry in apiEntries {
            entries.append(ElementSyntax(
                "a",
                attributes: [
                "href": "[*site root*]\(HTML.percentEncodeURLPath(entry.relativePagePath[localization]!))"
                ],
                contents: HTML.escapeTextForCharacterData(StrictString(entry.name.source())),
                inline: false).normalizedSource())
        }
        return generateIndexSection(named: name, contents: entries.joinedAsLines())
    }

    private static func generateIndexSection(named name: StrictString, contents: StrictString) -> StrictString {
        return ElementSyntax(
            "div",
            contents: [
                ElementSyntax("a", attributes: [
                    "class": "heading",
                    "onclick": "toggleIndexSectionVisibility(this)"
                    ], contents: HTML.escapeTextForCharacterData(name), inline: true).normalizedSource(),
                contents
                ].joinedAsLines(),
            inline: false).normalizedSource()
    }

    private static func generateLoneIndexEntry(named name: StrictString, target: StrictString) -> StrictString {
        return ElementSyntax(
            "div",
            contents: ElementSyntax("a", attributes: [
                "class": "heading",
                "href": "[*site root*]\(HTML.percentEncodeURLPath(target))"
                ], contents: HTML.escapeTextForCharacterData(name), inline: true).normalizedSource(),
            inline: false).normalizedSource()
    }

    private static func about(localization: LocalizationIdentifier) -> StrictString {
        switch localization._bestMatch {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "About"
        }
    }
    private static func aboutLocation(localization: LocalizationIdentifier) -> StrictString {
        return "\(localization._directoryName)/\(about(localization: localization)).html"
    }

    // MARK: - Initialization

    init(localizations: [LocalizationIdentifier],
         developmentLocalization: LocalizationIdentifier,
         api: PackageAPI,
         packageURL: URL?,
         version: Version?,
         about: [LocalizationIdentifier: StrictString],
         copyright: [LocalizationIdentifier?: StrictString],
         output: Command.Output) {

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Processing API..."
            }
        }).resolved())

        self.localizations = localizations
        self.developmentLocalization = developmentLocalization
        self.packageAPI = api
        self.api = APIElement.package(api)
        api.computeMergedAPI()

        self.packageImport = PackageInterface.specify(package: packageURL, version: version)
        self.about = about
        self.copyrightNotices = copyright

        self.packageIdentifiers = api.identifierList()

        var paths: [LocalizationIdentifier: [String: String]] = [:]
        for localization in localizations {
            paths[localization] = APIElement.package(api).determinePaths(for: localization)
        }
        self.symbolLinks = paths.mapValues { localization in
            localization.mapValues { link in
                return HTML.percentEncodeURLPath(link)
            }
        }

        self.indices = PackageInterface.generateIndices(
            for: api,
            about: about,
            localizations: localizations)
    }

    // MARK: - Properties

    private let localizations: [LocalizationIdentifier]
    private let developmentLocalization: LocalizationIdentifier
    private let packageAPI: PackageAPI
    private let api: APIElement
    private let packageImport: StrictString?
    private let indices: [LocalizationIdentifier: StrictString]
    private let about: [LocalizationIdentifier: Markdown]
    private let copyrightNotices: [LocalizationIdentifier?: StrictString]
    private let packageIdentifiers: Set<String>
    private let symbolLinks: [LocalizationIdentifier: [String: String]]

    private func copyright(for localization: LocalizationIdentifier, status: DocumentationStatus) -> StrictString {
        if let result = copyrightNotices[localization] {
            return result
        } else {
            status.reportMissingCopyright(localization: localization)
            return copyrightNotices[nil]!
        }
    }

    // MARK: - Output

    internal func outputHTML(to outputDirectory: URL, status: DocumentationStatus, output: Command.Output, coverageCheckOnly: Bool) throws {
        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Generating HTML..."
            }
        }).resolved())

        try outputPackagePages(to: outputDirectory, status: status, output: output, coverageCheckOnly: coverageCheckOnly)
        try outputLibraryPages(to: outputDirectory, status: status, output: output, coverageCheckOnly: coverageCheckOnly)
        try outputModulePages(to: outputDirectory, status: status, output: output, coverageCheckOnly: coverageCheckOnly)
        try outputTopLevelSymbols(to: outputDirectory, status: status, output: output, coverageCheckOnly: coverageCheckOnly)

        if coverageCheckOnly {
            return
        }

        try outputGeneralPage(
            to: outputDirectory,
            location: PackageInterface.aboutLocation,
            title: PackageInterface.about,
            content: about,
            status: status,
            output: output)

        try outputRedirects(to: outputDirectory)
    }

    private func outputPackagePages(to outputDirectory: URL, status: DocumentationStatus, output: Command.Output, coverageCheckOnly: Bool) throws {
        for localization in localizations {
            try autoreleasepool {
                let pageURL = api.pageURL(in: outputDirectory, for: localization)
                try SymbolPage(
                    localization: localization,
                    pathToSiteRoot: "../",
                    navigationPath: [api],
                    packageImport: packageImport,
                    index: indices[localization]!,
                    symbol: api,
                    package: packageAPI,
                    copyright: copyright(for: localization, status: status),
                    packageIdentifiers: packageIdentifiers,
                    symbolLinks: symbolLinks[localization]!,
                    status: status,
                    output: output,
                    coverageCheckOnly: coverageCheckOnly
                    )?.contents.save(to: pageURL)
            }
        }
    }

    private func outputLibraryPages(to outputDirectory: URL, status: DocumentationStatus, output: Command.Output, coverageCheckOnly: Bool) throws {
        for localization in localizations {
            for library in api.libraries.lazy.map({ APIElement.library($0) }) {
                try autoreleasepool {
                    let location = library.pageURL(in: outputDirectory, for: localization)
                    try SymbolPage(
                        localization: localization,
                        pathToSiteRoot: "../../",
                        navigationPath: [api, library],
                        packageImport: packageImport,
                        index: indices[localization]!,
                        symbol: library,
                        package: packageAPI,
                        copyright: copyright(for: localization, status: status),
                        packageIdentifiers: packageIdentifiers,
                        symbolLinks: symbolLinks[localization]!,
                        status: status,
                        output: output,
                        coverageCheckOnly: coverageCheckOnly
                        )?.contents.save(to: location)
                }
            }
        }
    }

    private func outputModulePages(to outputDirectory: URL, status: DocumentationStatus, output: Command.Output, coverageCheckOnly: Bool) throws {
        for localization in localizations {
            for module in api.modules.lazy.map({ APIElement.module($0) }) {
                try autoreleasepool {
                    let location = module.pageURL(in: outputDirectory, for: localization)
                    try SymbolPage(
                        localization: localization,
                        pathToSiteRoot: "../../",
                        navigationPath: [api, module],
                        packageImport: packageImport,
                        index: indices[localization]!,
                        symbol: module,
                        package: packageAPI,
                        copyright: copyright(for: localization, status: status),
                        packageIdentifiers: packageIdentifiers,
                        symbolLinks: symbolLinks[localization]!,
                        status: status,
                        output: output,
                        coverageCheckOnly: coverageCheckOnly
                        )?.contents.save(to: location)
                }
            }
        }
    }

    private func outputTopLevelSymbols(to outputDirectory: URL, status: DocumentationStatus, output: Command.Output, coverageCheckOnly: Bool) throws {
        for localization in localizations {
            for symbol in [
                packageAPI.types.map({ APIElement.type($0) }),
                packageAPI.uniqueExtensions.map({ APIElement.extension($0) }),
                packageAPI.protocols.map({ APIElement.protocol($0) }),
                packageAPI.functions.map({ APIElement.function($0) }),
                packageAPI.globalVariables.map({ APIElement.variable($0) }),
                packageAPI.operators.map({ APIElement.operator($0) }),
                packageAPI.precedenceGroups.map({ APIElement.precedence($0) })
                ].joined() {
                    try autoreleasepool {
                        let location = symbol.pageURL(in: outputDirectory, for: localization)
                        try SymbolPage(
                            localization: localization,
                            pathToSiteRoot: "../../",
                            navigationPath: [api, symbol],
                            packageImport: packageImport,
                            index: indices[localization]!,
                            symbol: symbol,
                            package: packageAPI,
                            copyright: copyright(for: localization, status: status),
                            packageIdentifiers: packageIdentifiers,
                            symbolLinks: symbolLinks[localization]!,
                            status: status,
                            output: output,
                            coverageCheckOnly: coverageCheckOnly
                            )?.contents.save(to: location)

                        switch symbol {
                        case .package, .library, .module, .case, .initializer, .variable, .subscript, .function, .operator, .precedence, .conformance:
                            break
                        case .type, .protocol, .extension:
                            try outputNestedSymbols(of: symbol, namespace: [symbol], to: outputDirectory, localization: localization, status: status, output: output, coverageCheckOnly: coverageCheckOnly)
                        }
                    }
            }

            for `extension` in packageAPI.allExtensions.filter({ ¬packageAPI.uniqueExtensions.contains($0) }) {
                let apiElement = APIElement.extension(`extension`)
                try outputNestedSymbols(of: apiElement, namespace: [apiElement], to: outputDirectory, localization: localization, status: status, output: output, coverageCheckOnly: coverageCheckOnly)
            }
        }
    }

    private func outputNestedSymbols(of parent: APIElement, namespace: [APIElement], to outputDirectory: URL, localization: LocalizationIdentifier, status: DocumentationStatus, output: Command.Output, coverageCheckOnly: Bool) throws {
        for symbol in parent.children where symbol.receivesPage {
            try autoreleasepool {
                let location = symbol.pageURL(in: outputDirectory, for: localization)

                var modifiedRoot: StrictString = "../../"
                for _ in namespace.indices {
                    modifiedRoot += "../../".scalars
                }

                var navigation: [APIElement] = [api]
                navigation += namespace as [APIElement]
                navigation += [symbol]

                try SymbolPage(
                    localization: localization,
                    pathToSiteRoot: modifiedRoot,
                    navigationPath: navigation,
                    packageImport: packageImport,
                    index: indices[localization]!,
                    symbol: symbol,
                    package: packageAPI,
                    copyright: copyright(for: localization, status: status),
                    packageIdentifiers: packageIdentifiers,
                    symbolLinks: symbolLinks[localization]!,
                    status: status,
                    output: output,
                    coverageCheckOnly: coverageCheckOnly
                    )?.contents.save(to: location)

                switch symbol {
                case .package, .library, .module, .case, .initializer, .variable, .subscript, .function, .operator, .precedence, .conformance:
                    break
                case .type, .protocol, .extension:
                    try outputNestedSymbols(of: symbol, namespace: namespace + [symbol], to: outputDirectory, localization: localization, status: status, output: output, coverageCheckOnly: coverageCheckOnly)
                }
            }
        }
    }

    private func outputGeneralPage(
        to outputDirectory: URL,
        location: (LocalizationIdentifier) -> StrictString,
        title: (LocalizationIdentifier) -> StrictString,
        content: [LocalizationIdentifier: Markdown],
        status: DocumentationStatus,
        output: Command.Output) throws {
        for localization in localizations {
            if let specifiedContent = content[localization] {
                let pathToSiteRoot: StrictString = "../"
                let pageTitle = title(localization)
                let pagePath = location(localization)

                // Parse via proxy Swift file.
                var documentationMarkup = StrictString(specifiedContent.lines.lazy.map({ line in
                    return "/// " + StrictString(line.line)
                }).joined(separator: "\n"))
                documentationMarkup.append(contentsOf: "\npublic func function() {}\n")
                let parsed = try SyntaxTreeParser.parse(String(documentationMarkup))
                let documentation = parsed.api().first!.documentation

                var content = ""
                if let firstParagraph = documentation?.descriptionSection?.renderedHTML(
                    localization: localization.code,
                    symbolLinks: symbolLinks[localization]!) {
                    content.append(contentsOf: firstParagraph)
                }
                for paragraph in documentation?.discussionEntries ?? [] { // @exempt(from: tests)
                    content.append("\n")
                    content.append(contentsOf: paragraph.renderedHTML(
                        localization: localization.code,
                        symbolLinks: symbolLinks[localization]!))
                }

                let page = Page(
                    localization: localization,
                    pathToSiteRoot: pathToSiteRoot,
                    navigationPath: SymbolPage.generateNavigationPath(
                        localization: localization,
                        pathToSiteRoot: pathToSiteRoot,
                        navigationPath: [
                            (label: StrictString(api.name.source()), path: api.relativePagePath[localization]!),
                            (label: pageTitle, path: pagePath)
                        ]),
                    packageImport: packageImport,
                    index: indices[localization]!,
                    symbolImports: "",
                    symbolType: nil,
                    compilationConditions: nil,
                    constraints: nil,
                    title: HTML.escapeTextForCharacterData(pageTitle),
                    content: StrictString(content),
                    extensions: "",
                    copyright: copyright(for: localization, status: status))
                let url = outputDirectory.appendingPathComponent(String(location(localization)))
                try page.contents.save(to: url)
            }
        }
    }

    private func outputRedirects(to outputDirectory: URL) throws {
        // Out of directories.
        var handled = Set<URL>()
        for url in try FileManager.default.deepFileEnumeration(in: outputDirectory) {
            try autoreleasepool {
                var directory = url.deletingLastPathComponent()
                while directory ∉ handled,
                    directory.is(in: outputDirectory) {
                        defer {
                            handled.insert(directory)
                            directory = directory.deletingLastPathComponent()
                        }

                        let redirect = directory.appendingPathComponent("index.html")
                        if (try? redirect.checkResourceIsReachable()) ≠ true { // Do not overwrite if there is a file name clash.
                            try Redirect(target: "../index.html").contents.save(to: redirect)
                        }
                }
            }
        }

        // To home page.
        try Redirect(target: String(developmentLocalization._directoryName) + "/index.html").contents.save(to: outputDirectory.appendingPathComponent("index.html"))
        for localization in localizations {
            let localizationDirectory = outputDirectory.appendingPathComponent(String(localization._directoryName))
            let redirectURL = localizationDirectory.appendingPathComponent("index.html")
            let pageURL = api.pageURL(in: outputDirectory, for: localization)
            if redirectURL ≠ pageURL {
                try Redirect(target: pageURL.lastPathComponent).contents.save(to: redirectURL)
            }
        }
    }
}
