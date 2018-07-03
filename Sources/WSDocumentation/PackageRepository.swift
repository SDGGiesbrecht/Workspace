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

    private static func subdirectory(for target: String, in documentationDirectory: URL) -> URL {
        return documentationDirectory.appendingPathComponent(target)
    }

    private func resolvedCopyright(output: Command.Output) throws -> StrictString {

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

    #if !os(Linux)
    // MARK: - #if os(Linux)

    public func document(outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

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

    public func validateDocumentationCoverage(outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        for product in try productModules() {
            try autoreleasepool {
                try validateDocumentationCoverage(for: product.name, outputDirectory: outputDirectory, validationStatus: &validationStatus, output: output)
            }
        }
    }

    private func validateDocumentationCoverage(for target: String, outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output) throws {

        let section = validationStatus.newSection()

        output.print(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishCanada:
                return "Checking documentation coverage for “" + StrictString(target) + "”..." + section.anchor
            }
        }).resolved().formattedAsSectionHeader())

        do {

            let warnings = try Jazzy.default.warnings(outputDirectory: PackageRepository.subdirectory(for: target, in: outputDirectory))

            for warning in warnings {
                output.print([
                    warning.file.path(relativeTo: location) + ":" + String(warning.line?.inDigits() ?? ""), // [_Exempt from Test Coverage_] It is unknown what would cause a missing line number.
                    warning.symbol,
                    ""
                    ].joinedAsLines().formattedAsError())
            }

            if warnings.isEmpty {
                validationStatus.passStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Documentation coverage is complete for “" + StrictString(target) + "”."
                    }
                }))
            } else {
                validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishCanada:
                        return "Documentation coverage is incomplete for “" + StrictString(target) + "”." + section.crossReference.resolved(for: localization)
                    }
                }))
            }
        } catch {
            output.print(error.localizedDescription.formattedAsError())
            validationStatus.failStep(message: UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch localization {
                case .englishCanada:
                    return "Documentation coverage information is unavailable for “" + StrictString(target) + "”." + section.crossReference.resolved(for: localization)
                }
            }))
        }
    }

    #endif

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

            try resolve(reportProgress: { output.print($0) })
            resetFileCache(debugReason: "resolve")

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

                    if FileType(url: url) == .swift {
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

        for url in try sourceFiles(output: output) {
            try autoreleasepool {

                if FileType(url: url) == .swift {
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
