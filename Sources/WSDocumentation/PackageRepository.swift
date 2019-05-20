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
import SDGMathematics
import SDGCollections
import WSGeneralImports

import SDGXcode
import SDGSwiftSource
import SDGHTML
import SDGCSS

import WSProject
import WSValidation
import WSXcode

extension PackageRepository {

    // MARK: - Static Properties

    public static let documentationDirectoryName = "docs" // Matches GitHub Pages.

    // MARK: - Properties

    public func hasTargetsToDocument() throws -> Bool {
        return try cachedPackage().products.contains(where: { $0.type.isLibrary })
    }

    // MARK: - Configuration

    public var defaultDocumentationDirectory: URL {
        return location.appendingPathComponent(PackageRepository.documentationDirectoryName)
    }

    internal func resolvedCopyright(documentationStatus: DocumentationStatus, output: Command.Output) throws -> [LocalizationIdentifier?: StrictString] {

        var template: [LocalizationIdentifier?: StrictString] = try documentationCopyright(output: output).mapKeys { $0 }
        template[nil] = "#dates"

        let dates: StrictString
        if let specified = try configuration(output: output).documentation.api.yearFirstPublished {
            dates = StrictString(WSProject.copyright(fromText: "©\(specified.inEnglishDigits())"))
        } else {
            documentationStatus.reportMissingYearFirstPublished()
            dates = StrictString(WSProject.copyright(fromText: ""))
        }
        template = template.mapValues { $0.replacingMatches(for: "#dates", with: dates) }

        return template
    }

    // MARK: - Documentation

    public func document(outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        if try ¬hasTargetsToDocument() {
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
            try document(outputDirectory: outputDirectory, documentationStatus: status, validationStatus: &validationStatus, output: output, coverageCheckOnly: false)

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
            output.print(error.localizedDescription.formattedAsError()) // @exempt(from: tests) Unreachable without SwiftSyntax or file system failure.
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
    private func document(outputDirectory: URL, documentationStatus: DocumentationStatus, validationStatus: inout ValidationStatus, output: Command.Output, coverageCheckOnly: Bool) throws {

        if ProcessInfo.isInContinuousIntegration {
            // #workaround(SwiftSyntax 0.50000.0, SwiftSyntax is too slow for Travis CI.)
            DispatchQueue.global(qos: .background).async { // @exempt(from: tests)
                while true { // @exempt(from: tests)
                    print("...")
                    Thread.sleep(until: Date(timeIntervalSinceNow: 9 × 60))
                }
            }
        }

        let configuration = try self.configuration(output: output)
        let copyright = try resolvedCopyright(documentationStatus: documentationStatus, output: output)

        let developmentLocalization = try self.developmentLocalization(output: output)
        let api = try PackageAPI(
            package: cachedPackageGraph(),
            ignoredDependencies: configuration.documentation.api.ignoredDependencies,
            reportProgress: { output.print($0) })

        let interface = PackageInterface(
            localizations: configuration.documentation.localizations,
            developmentLocalization: developmentLocalization,
            api: api,
            packageURL: configuration.documentation.repositoryURL,
            version: configuration.documentation.currentVersion,
            about: configuration.documentation.readMe.about,
            copyright: copyright,
            output: output)

        try interface.outputHTML(to: outputDirectory, status: documentationStatus, output: output, coverageCheckOnly: coverageCheckOnly)
    }

    // Final steps irrelevent to validation.
    private func finalizeSite(outputDirectory: URL) throws {

        try CSS.root.save(to: outputDirectory.appendingPathComponent("CSS/Root.css"))
        try SyntaxHighlighter.css.save(to: outputDirectory.appendingPathComponent("CSS/Swift.css"))
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

            FileManager.default.withTemporaryDirectory(appropriateFor: outputDirectory) { temporary in
                let package = Package(url: packageURL)
                do {
                    _ = try Git.clone(package, to: temporary).get()
                    _ = try Git.runCustomSubcommand(["checkout", "gh\u{2D}pages"], in: temporary).get()
                    try FileManager.default.removeItem(at: outputDirectory)
                    try FileManager.default.move(temporary, to: outputDirectory)
                } catch {}
            }
        }
    }

    private func redirectExistingURLs(outputDirectory: URL) throws {
        if (try? outputDirectory.checkResourceIsReachable()) == true {
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
    }

    private func preventJekyllInterference(outputDirectory: URL) throws {
        try Data().write(to: outputDirectory.appendingPathComponent(".nojekyll"))
    }

    // MARK: - Validation

    public func validateDocumentationCoverage(validationStatus: inout ValidationStatus, output: Command.Output) throws {

        if try ¬hasTargetsToDocument() {
            return
        }

        let section = validationStatus.newSection()
        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Checking documentation coverage..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())
        do {
            try FileManager.default.withTemporaryDirectory(appropriateFor: nil) { outputDirectory in

                let status = DocumentationStatus(output: output)
                try document(outputDirectory: outputDirectory, documentationStatus: status, validationStatus: &validationStatus, output: output, coverageCheckOnly: true)

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
        return InterfaceLocalization.allCases.map { localization in
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
        return InterfaceLocalization.allCases.map { localization in
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

            for url in try sourceFiles(output: output) {
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

        for url in try sourceFiles(output: output) where ¬url.path.hasSuffix("Sources/WorkspaceConfiguration/Documentation/DocumentationInheritance.swift") {
            try autoreleasepool {

                if let type = FileType(url: url),
                    type ∈ Set([.swift, .swiftPackageManifest]) {

                    let documentationSyntax = FileType.swiftDocumentationSyntax
                    let lineDocumentationSyntax = documentationSyntax.lineCommentSyntax!

                    var file = try TextFile(alreadyAt: url)

                    var searchIndex = file.contents.scalars.startIndex
                    while let match = file.contents.scalars[min(searchIndex, file.contents.scalars.endIndex) ..< file.contents.scalars.endIndex].firstMatch(for: AlternativePatterns(PackageRepository.documentationDirectivePatterns)) {
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
