/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import SDGXcode
import SDGSwiftSource

import WSProject
import WSValidation
import WSXcode

extension PackageRepository {

    // MARK: - Static Properties

    public static let documentationDirectoryName = "docs" // Matches GitHub Pages.

    // MARK: - Properties

    public func hasTargetsToDocument(usingJazzy: Bool) throws -> Bool {
        return try cachedPackage().products.contains(where: { $0.type.isLibrary ∨ (¬usingJazzy ∧ $0.type == .executable) })
    }

    // MARK: - Configuration

    public var defaultDocumentationDirectory: URL {
        return location.appendingPathComponent(PackageRepository.documentationDirectoryName)
    }

    private static func subdirectory(for target: String, in documentationDirectory: URL) -> URL {
        return documentationDirectory.appendingPathComponent(target)
    }

    internal func resolvedCopyright(output: Command.Output) throws -> StrictString {

        var template = try documentationCopyright(output: output)

        let dates: StrictString
        if let specified = try configuration(output: output).documentation.api.yearFirstPublished {
            dates = StrictString(WSProject.copyright(fromText: "©\(specified.inEnglishDigits())"))
        } else {
            dates = StrictString(WSProject.copyright(fromText: ""))
        }
        template.replaceMatches(for: "#dates", with: dates)

        return template
    }

    // MARK: - Documentation

    public func document(outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output, usingJazzy: Bool) throws {
        if ¬usingJazzy {
            try document(outputDirectory: outputDirectory, validationStatus: &validationStatus, output: output)
        } else {
            #if !os(Linux)
            try documentUsingJazzy(outputDirectory: outputDirectory, validationStatus: &validationStatus, output: output)
            #endif
        }
    }

    private func document(outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        if ¬(try hasTargetsToDocument(usingJazzy: false)) {
            return
        }

        let section = validationStatus.newSection()
        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Generating documentation..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())
        do {
            try prepare(outputDirectory: outputDirectory, output: output)

            let status = DocumentationStatus(output: output)
            try document(outputDirectory: outputDirectory, documentationStatus: status, validationStatus: &validationStatus, output: output)

            try finalizeSite(outputDirectory: outputDirectory)

            if status.passing {
                validationStatus.passStep(message: UserFacing({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Generated documentation."
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacing({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Generated documentation, but encountered warnings." + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        } catch {
            output.print(error.localizedDescription.formattedAsError())
            validationStatus.failStep(message: UserFacing({ localization in
                switch localization {
                case .englishCanada:
                    return "Failed to generate documentation." + section.crossReference.resolved(for: localization)
                }
            }))
        }
    }

    // Preliminary steps irrelevent to validation.
    private func prepare(outputDirectory: URL, output: Command.Output) throws {
        try retrievePublishedDocumentationIfAvailable(outputDirectory: outputDirectory, output: output)
        try redirectExistingURLs(outputDirectory: outputDirectory)
    }

    // Steps which participate in validation.
    private func document(outputDirectory: URL, documentationStatus: DocumentationStatus, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let configuration = try self.configuration(output: output)
        let copyrightNotice = try resolvedCopyright(output: output)
        var copyright: [LocalizationIdentifier: StrictString] = [:]
        for localization in configuration.documentation.localizations {
            copyright[localization] = copyrightNotice
        }

        let interface = PackageInterface(
            localizations: configuration.documentation.localizations,
            developmentLocalization: try developmentLocalization(output: output),
            api: try PackageAPI(package: cachedPackage(), reportProgress: { output.print($0) }),
            packageURL: configuration.documentation.repositoryURL,
            version: configuration.documentation.currentVersion,
            copyright: copyright,
            output: output)
        try interface.outputHTML(to: outputDirectory, status: documentationStatus, output: output)
    }

    // Final steps irrelevent to validation.
    private func finalizeSite(outputDirectory: URL) throws {

        var rootCSS = TextFile(mockFileWithContents: Resources.root, fileType: .css)
        rootCSS.header = ""
        try rootCSS.contents.save(to: outputDirectory.appendingPathComponent("CSS/Root.css"))
        try Syntax.css.save(to: outputDirectory.appendingPathComponent("CSS/Swift.css"))
        var siteCSS = TextFile(mockFileWithContents: Resources.site, fileType: .css)
        siteCSS.header = ""
        try siteCSS.contents.save(to: outputDirectory.appendingPathComponent("CSS/Site.css"))
        var siteJavaScript = TextFile(mockFileWithContents: Resources.script, fileType: .javaScript)
        siteJavaScript.header = ""
        try siteJavaScript.contents.save(to: outputDirectory.appendingPathComponent("JavaScript/Site.js"))

        try preventJekyllInterference(outputDirectory: outputDirectory)
    }

    private func retrievePublishedDocumentationIfAvailable(outputDirectory: URL, output: Command.Output) throws {
        if let packageURL = try configuration(output: output).documentation.repositoryURL {

            output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Checking for defunct URLs to redirect..."
                }
            }).resolved())

            let temporary = FileManager.default.url(in: .temporary, at: "Published Documentation")
            defer { try? FileManager.default.removeItem(at: temporary) }

            let package = Package(url: packageURL)
            do {
                try Git.clone(package, to: temporary)
                try Git.runCustomSubcommand(["checkout", "gh\u{2D}pages"], in: temporary)
                try FileManager.default.removeItem(at: outputDirectory)
                try FileManager.default.move(temporary, to: outputDirectory)
            } catch {}
        }
    }

    private func redirectExistingURLs(outputDirectory: URL) throws {
        let generalRedirect = Redirect(target: "index.html")
        let indexRedirect = Redirect(target: "../index.html")
        for file in try FileManager.default.deepFileEnumeration(in: outputDirectory) {
            try autoreleasepool {
                if file.pathExtension == "html" {
                    if file.lastPathComponent == "index.html" {
                        try indexRedirect.contents.save(to: file)
                    } else {
                        try generalRedirect.contents.save(to: file)
                    }
                } else {
                    try? FileManager.default.removeItem(at: file)
                }
            }
        }
    }

    private func preventJekyllInterference(outputDirectory: URL) throws {
        try Data().write(to: outputDirectory.appendingPathComponent(".nojekyll"))
    }

    // MARK: - Jazzy

    private func documentUsingJazzy(outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        for product in try productModules() {
            try autoreleasepool {
                try document(target: product.name, outputDirectory: outputDirectory, validationStatus: &validationStatus, output: output)
            }
        }
    }

    private func document(target: String, outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Generating documentation for “" + StrictString(target) + "”..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        do {

            let outputSubdirectory = PackageRepository.subdirectory(for: target, in: outputDirectory)

            let buildOperatingSystem: OperatingSystem
            if try .macOS ∈ configuration(output: output).supportedOperatingSystems {
                buildOperatingSystem = .macOS
            } else if try .iOS ∈ configuration(output: output).supportedOperatingSystems {
                buildOperatingSystem = .iOS
            } else if try .watchOS ∈ configuration(output: output).supportedOperatingSystems {
                buildOperatingSystem = .watchOS
            } else if try .tvOS ∈ configuration(output: output).supportedOperatingSystems {
                buildOperatingSystem = .tvOS
            } else {
                buildOperatingSystem = .macOS
            }

            let copyrightText = try resolvedCopyright(output: output)
            try FileManager.default.do(in: location) {
                try Jazzy.default.document(target: target, scheme: try scheme(), buildOperatingSystem: buildOperatingSystem, copyright: copyrightText, gitHubURL: try configuration(output: output).documentation.repositoryURL, outputDirectory: outputSubdirectory, project: self, output: output)
            }

            let transformedMarker = ReadMeConfiguration._skipInJazzy.replacingMatches(for: "\u{2D}\u{2D}".scalars, with: "&ndash;".scalars).replacingMatches(for: "<".scalars, with: "&lt;".scalars).replacingMatches(for: ">".scalars, with: "&gt;".scalars)
            for url in try trackedFiles(output: output) where url.is(in: outputSubdirectory) {
                if let type = FileType(url: url),
                    type == .html {
                    try autoreleasepool {

                        var file = try TextFile(alreadyAt: url)
                        var source = file.contents
                        while let skipMarker = source.scalars.firstMatch(for: transformedMarker.scalars) {
                            let line = skipMarker.range.lines(in: source.lines)
                            source.lines.removeSubrange(line)
                        }

                        file.contents = source
                        try file.writeChanges(for: self, output: output)
                    }
                }
            }

            validationStatus.passStep(message: UserFacing({ localization in
                switch localization {
                case .englishCanada:
                    return "Generated documentation for “" + StrictString(target) + "”."
                }
            }))

        } catch {
            var description = StrictString(error.localizedDescription)
            if let noXcode = error as? Xcode.Error,
                noXcode == .noXcodeProject {
                description += "\n" + PackageRepository.xcodeProjectInstructions.resolved()
            }
            output.print(description.formattedAsError())

            validationStatus.failStep(message: UserFacing({ localization in
                switch localization {
                case .englishCanada:
                    return "Failed to generate documentation for “" + StrictString(target) + "”." + section.crossReference.resolved(for: localization)
                }
            }))
        }
    }

    // End Jazzy section.

    public func validateDocumentationCoverage(outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) {

        let section = validationStatus.newSection()
        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Checking documentation coverage..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())
        do {
            try prepare(outputDirectory: outputDirectory, output: output)

            let status = DocumentationStatus(output: output)
            try document(outputDirectory: outputDirectory, documentationStatus: status, validationStatus: &validationStatus, output: output)

            try finalizeSite(outputDirectory: outputDirectory)

            if status.passing {
                validationStatus.passStep(message: UserFacing({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Documentation coverage is complete."
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacing({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Documentation coverage is incomplete." + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        } catch {
            output.print(error.localizedDescription.formattedAsError())
            validationStatus.failStep(message: UserFacing({ localization in
                switch localization {
                case .englishCanada:
                    return "Failed to process documentation." + section.crossReference.resolved(for: localization)
                }
            }))
        }
    }

    // MARK: - Inheritance

    private static let documentationAttribute: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "documentation"
        }
    })

    private static let documentationDirective: UserFacing<StrictString, InterfaceLocalization> = UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "documentation"
        }
    })

    private static var documentationDeclarationPatterns: [CompositePattern<Unicode.Scalar>] {
        return InterfaceLocalization.cases.map { localization in
            return CompositePattern<Unicode.Scalar>([
                LiteralPattern("@".scalars),
                LiteralPattern(documentationAttribute.resolved(for: localization)),
                LiteralPattern("(".scalars),
                RepetitionPattern(ConditionalPattern({ $0 ∉ CharacterSet.newlines }), consumption: .greedy),
                LiteralPattern(")".scalars)
                ])
        }
    }

    private static var documentationDirectivePatterns: [CompositePattern<Unicode.Scalar>] {
        return InterfaceLocalization.cases.map { localization in
            return CompositePattern<Unicode.Scalar>([
                LiteralPattern("#".scalars),
                LiteralPattern(documentationDirective.resolved(for: localization)),
                LiteralPattern("(".scalars),
                RepetitionPattern(ConditionalPattern({ $0 ∉ CharacterSet.newlines }), consumption: .greedy),
                LiteralPattern(")".scalars)
                ])
        }
    }

    private func documentationDefinitions(output: Command.Output) throws -> [StrictString: StrictString] {
        return try _withDocumentationCache {

            var list: [StrictString: StrictString] = [:]

            let dependencies = try allFiles().filter { url in
                guard url.is(in: location.appendingPathComponent("Packages"))
                    ∨ url.is(in: location.appendingPathComponent(".build/checkouts")) else {
                        return false
                }
                if url.absoluteString.contains(".git") ∨ url.absoluteString.contains("/docs/") {
                    return false
                }
                return true
            }

            for url in try dependencies + sourceFiles(output: output) {
                try autoreleasepool {

                    if let type = FileType(url: url),
                        type ∈ Set([.swift, .swiftPackageManifest]) {
                        let file = try TextFile(alreadyAt: url)

                        for match in file.contents.scalars.matches(for: AlternativePatterns(PackageRepository.documentationDeclarationPatterns)) {
                            guard let openingParenthesis = match.contents.firstMatch(for: "(".scalars),
                                let closingParenthesis = match.contents.lastMatch(for: ")".scalars) else {
                                    unreachable()
                            }

                            var identifier = StrictString(file.contents.scalars[openingParenthesis.range.upperBound ..< closingParenthesis.range.lowerBound])
                            identifier.trimMarginalWhitespace()

                            let nextLineStart = match.range.lines(in: file.contents.lines).upperBound.samePosition(in: file.contents.scalars)
                            if let comment = FileType.swiftDocumentationSyntax.contentsOfFirstComment(in: nextLineStart ..< file.contents.scalars.endIndex, of: file) {
                                list[identifier] = StrictString(comment)
                            }
                        }
                    }
                }
            }

            return list
        }
    }

    public func refreshInheritedDocumentation(output: Command.Output) throws {

        try resolve(reportProgress: { output.print($0) })
        resetFileCache(debugReason: "resolve")

        for url in try sourceFiles(output: output) {
            try autoreleasepool {

                if let type = FileType(url: url),
                    type ∈ Set([.swift, .swiftPackageManifest]) {

                    let documentationSyntax = FileType.swiftDocumentationSyntax
                    let lineDocumentationSyntax = documentationSyntax.lineCommentSyntax!

                    var file = try TextFile(alreadyAt: url)

                    var searchIndex = file.contents.scalars.startIndex
                    while let match = file.contents.scalars.firstMatch(for: AlternativePatterns(PackageRepository.documentationDirectivePatterns), in: min(searchIndex, file.contents.scalars.endIndex) ..< file.contents.scalars.endIndex) {
                        searchIndex = match.range.upperBound

                        guard let openingParenthesis = match.contents.firstMatch(for: "(".scalars),
                            let closingParenthesis = match.contents.lastMatch(for: ")".scalars) else {
                                unreachable()
                        }

                        var identifier = StrictString(file.contents.scalars[openingParenthesis.range.upperBound ..< closingParenthesis.range.lowerBound])
                        identifier.trimMarginalWhitespace()
                        guard let replacement = try documentationDefinitions(output: output)[identifier] else {
                            throw Command.Error(description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                                switch localization {
                                case .englishCanada:
                                    return "There is no documentation named “" + identifier + "”."
                                }
                            }))
                        }

                        let matchLines = match.range.lines(in: file.contents.lines)
                        let nextLineStart = matchLines.upperBound.samePosition(in: file.contents.scalars)
                        if let commentRange = documentationSyntax.rangeOfFirstComment(in: nextLineStart ..< file.contents.scalars.endIndex, of: file),
                            file.contents.scalars[nextLineStart ..< commentRange.lowerBound].firstMatch(for: CharacterSet.newlinePattern) == nil {

                            let indent = StrictString(file.contents.scalars[nextLineStart ..< commentRange.lowerBound])

                            file.contents.scalars.replaceSubrange(commentRange, with: lineDocumentationSyntax.comment(contents: String(replacement), indent: String(indent)).scalars)
                        } else {
                            var location: String.ScalarView.Index = nextLineStart
                            file.contents.scalars.advance(&location, over: RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces })))

                            let indent = StrictString(file.contents.scalars[nextLineStart ..< location])

                            let result = StrictString(lineDocumentationSyntax.comment(contents: String(replacement), indent: String(indent))) + "\n" + indent

                            file.contents.scalars.insert(contentsOf: result.scalars, at: location)
                        }
                    }

                    try file.writeChanges(for: self, output: output)
                }
            }
        }
    }
}
