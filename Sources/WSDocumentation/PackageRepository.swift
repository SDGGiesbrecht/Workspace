/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2019 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

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

  public static let documentationDirectoryName = "docs"  // Matches GitHub Pages.

  // MARK: - Properties

  public func hasTargetsToDocument() throws -> Bool {
    return try cachedPackage().products.contains(where: { $0.type.isLibrary })
  }

  // MARK: - Configuration

  public var defaultDocumentationDirectory: URL {
    return location.appendingPathComponent(PackageRepository.documentationDirectoryName)
  }

  private func platforms(
    output: Command.Output
  ) throws -> [LocalizationIdentifier: [StrictString]] {
    var result: [LocalizationIdentifier: [StrictString]] = [:]
    for localization in try configuration(output: output).documentation.localizations {
      var list: [StrictString] = []
      for platform in try configuration(output: output).supportedPlatforms {
        list.append(platform._isolatedName(for: localization._bestMatch))
      }
      result[localization] = list.sorted()
    }
    return result
  }

  private func loadCommandLineInterface(output: Command.Output) throws -> PackageCLI {
    let productsURL = try productsDirectory(releaseConfiguration: false).get()
    let toolNames = try configurationContext().manifest.products.lazy.filter({ product in
      switch product.type {
      case .library:
        return false
      case .executable:
        return true
      }
    }).lazy.map({ $0.name })
    build(releaseConfiguration: false)
    let toolLocations = Array(toolNames.map({ productsURL.appendingPathComponent($0) }))
    return PackageCLI(
      tools: toolLocations,
      localizations: try configuration(output: output).documentation.localizations)
  }

  internal func resolvedCopyright(
    documentationStatus: DocumentationStatus, output: Command.Output
  ) throws -> [LocalizationIdentifier?: StrictString] {

    var template: [LocalizationIdentifier?: StrictString] = try documentationCopyright(
      output: output).mapKeys { $0 }
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

  private func relatedProjects(
    output: Command.Output
  ) throws -> [LocalizationIdentifier: Markdown] {
    let relatedProjects = try configuration(output: output).documentation.relatedProjects
    let localizations = try configuration(output: output).documentation.localizations
    var result: [LocalizationIdentifier: Markdown] = [:]
    for localization in localizations {
      var markdown: [Markdown] = []
      for entry in relatedProjects {
        try autoreleasepool {
          switch entry {
          case .heading(text: let translations):
            if let text = translations[localization] {
              markdown += [
                "",
                "## \(text)"
              ]
            }
          case .project(url: let url):
            let package = try PackageRepository.relatedPackage(
              Package(url: url), output: output)
            let name: StrictString
            if let packageName = try? package.projectName(
              in: localization, output: output)
            {
              name = packageName  // @exempt(from: tests) False positive in Xcode 10.
            } else {
              // @exempt(from: tests) Only reachable with a non‐package repository.
              name = StrictString(url.lastPathComponent)
            }

            markdown += [
              "",
              "### [\(name)](\(url.absoluteString))"
            ]

            if let packageDocumentation = try? PackageAPI.documentation(
              for: package.package().get()),
              let documentation = packageDocumentation.resolved(
                localizations: localizations).documentation[localization],
              let description = documentation.descriptionSection
            {
              markdown += [
                "",
                StrictString(description.text)
              ]
            }
          }
        }
      }
      if ¬markdown.isEmpty {
        result[localization] = markdown.joinedAsLines()
      }
    }
    return result
  }

  // MARK: - Documentation

  public func document(
    outputDirectory: URL, validationStatus: inout ValidationStatus, output: Command.Output
  ) throws {

    if try ¬hasTargetsToDocument() {
      return
    }

    let section = validationStatus.newSection()
    output.print(
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Generating documentation..." + section.anchor
        case .deutschDeutschland:
          return "Dokumentation wird erstellt ..."
        }
      }).resolved().formattedAsSectionHeader())
    do {
      try prepare(outputDirectory: outputDirectory, output: output)

      let status = DocumentationStatus(output: output)
      try document(
        outputDirectory: outputDirectory, documentationStatus: status,
        validationStatus: &validationStatus, output: output, coverageCheckOnly: false)

      try finalizeSite(outputDirectory: outputDirectory)

      if status.passing {
        validationStatus.passStep(
          message: UserFacing({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Generated documentation."
            case .deutschDeutschland:
              return "Dokumentation erstellt."
            }
          }))
      } else {
        validationStatus.failStep(
          message: UserFacing({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Generated documentation, but encountered warnings."
                + section.crossReference.resolved(for: localization)
            case .deutschDeutschland:
              return
                "Dokumentation wurde erstellt, aber Warnungen wurden dabei ausgelöst."
            }
          }))
      }
    } catch {
      output.print(error.localizedDescription.formattedAsError())  // @exempt(from: tests) Unreachable without SwiftSyntax or file system failure.
      validationStatus.failStep(
        message: UserFacing({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Failed to generate documentation."
              + section.crossReference.resolved(for: localization)
          case .deutschDeutschland:
            return "Dokumentationserstellung ist fehlgeschlagen."
              + section.crossReference.resolved(for: localization)
          }
        }))
    }
  }

  // Preliminary steps irrelevent to validation.
  private func prepare(outputDirectory: URL, output: Command.Output) throws {
    try retrievePublishedDocumentationIfAvailable(
      outputDirectory: outputDirectory, output: output)
    try redirectExistingURLs(outputDirectory: outputDirectory)
  }

  // Steps which participate in validation.
  private func document(
    outputDirectory: URL, documentationStatus: DocumentationStatus,
    validationStatus: inout ValidationStatus, output: Command.Output, coverageCheckOnly: Bool
  ) throws {

    if ProcessInfo.isInContinuousIntegration {
      DispatchQueue.global(qos: .background).async {  // @exempt(from: tests)
        while true {  // @exempt(from: tests)
          print("...")
          Thread.sleep(until: Date(timeIntervalSinceNow: 9 × 60))
        }
      }
    }

    let configuration = try self.configuration(output: output)
    let copyright = try resolvedCopyright(
      documentationStatus: documentationStatus, output: output)

    let developmentLocalization = try self.developmentLocalization(output: output)
    let api = try PackageAPI(
      package: cachedPackageGraph(),
      ignoredDependencies: configuration.documentation.api.ignoredDependencies,
      reportProgress: { output.print($0) })
    let cli = try loadCommandLineInterface(output: output)

    var relatedProjects: [LocalizationIdentifier: Markdown] = [:]
    if ¬coverageCheckOnly {
      relatedProjects = try self.relatedProjects(output: output)
    }

    let interface = PackageInterface(
      localizations: configuration.documentation.localizations,
      developmentLocalization: developmentLocalization,
      api: api,
      cli: cli,
      packageURL: configuration.documentation.repositoryURL,
      version: configuration.documentation.currentVersion,
      platforms: try platforms(output: output),
      installation: configuration.documentation.installationInstructions
        .resolve(configuration),
      importing: configuration.documentation.importingInstructions.resolve(configuration),
      relatedProjects: relatedProjects,
      about: configuration.documentation.about,
      copyright: copyright,
      output: output)

    try interface.outputHTML(
      to: outputDirectory, status: documentationStatus, output: output,
      coverageCheckOnly: coverageCheckOnly)
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
    try siteJavaScript.contents.save(
      to: outputDirectory.appendingPathComponent("JavaScript/Site.js"))

    try preventJekyllInterference(outputDirectory: outputDirectory)
  }

  private func retrievePublishedDocumentationIfAvailable(
    outputDirectory: URL, output: Command.Output
  ) throws {
    if let packageURL = try configuration(output: output).documentation.repositoryURL {

      output.print(
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Checking for defunct URLs to redirect..."
          case .deutschDeutschland:
            return "Verstorbene Ressourcenzeiger werden weiterleitet ..."
          }
        }).resolved())

      FileManager.default.withTemporaryDirectory(appropriateFor: outputDirectory) {
        temporary in
        let package = Package(url: packageURL)
        do {
          _ = try Git.clone(package, to: temporary).get()
          _ = try Git.runCustomSubcommand(
            ["checkout", "gh\u{2D}pages"],
            in: temporary).get()
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

  public func validateDocumentationCoverage(
    validationStatus: inout ValidationStatus, output: Command.Output
  ) throws {

    if try ¬hasTargetsToDocument() {
      return
    }

    let section = validationStatus.newSection()
    output.print(
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Checking documentation coverage..." + section.anchor
        case .deutschDeutschland:
          return "Die Dokumentationsabdeckung wird überprüft ..." + section.anchor
        }
      }).resolved().formattedAsSectionHeader())
    do {
      try FileManager.default.withTemporaryDirectory(appropriateFor: nil) { outputDirectory in

        let status = DocumentationStatus(output: output)
        try document(
          outputDirectory: outputDirectory, documentationStatus: status,
          validationStatus: &validationStatus, output: output, coverageCheckOnly: true)

        if status.passing {
          validationStatus.passStep(
            message: UserFacing({ localization in
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Documentation coverage is complete."
              case .deutschDeutschland:
                return "Die Dokumentationsabdeckung ist vollständig."
              }
            }))
        } else {
          validationStatus.failStep(
            message: UserFacing({ localization in
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Documentation coverage is incomplete."
                  + section.crossReference.resolved(for: localization)
              case .deutschDeutschland:
                return "Die Dokumentationsabdeckung ist unvollständig."
                  + section.crossReference.resolved(for: localization)
              }
            }))
        }
      }
    } catch {
      output.print(error.localizedDescription.formattedAsError())
      validationStatus.failStep(
        message: UserFacing({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Failed to process documentation."
              + section.crossReference.resolved(for: localization)
          case .deutschDeutschland:
            return "Die Dokumentationsverarbeitung ist fehlgeschlagen."
              + section.crossReference.resolved(for: localization)
          }
        }))
    }
  }

  // MARK: - Inheritance

  private func documentationDefinitions(output: Command.Output) throws -> [StrictString:
    StrictString]
  {
    return try _withDocumentationCache {

      var list: [StrictString: StrictString] = [:]

      for url in try sourceFiles(output: output) {
        try autoreleasepool {

          if let type = FileType(url: url),
            type ∈ Set([.swift, .swiftPackageManifest])
          {
            let file = try TextFile(alreadyAt: url)

            for match in file.contents.scalars.matches(
              for: InterfaceLocalization.documentationDeclaration)
            {
              let identifier = match.declarationArgument()

              let nextLineStart = match.range.lines(in: file.contents.lines)
                .upperBound.samePosition(in: file.contents.scalars)
              if let comment = FileType.swiftDocumentationSyntax
                .contentsOfFirstComment(
                  in: nextLineStart ..< file.contents.scalars.endIndex, of: file)
              {
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

        if let type = FileType(url: url),
          type ∈ Set([.swift, .swiftPackageManifest])
        {

          let documentationSyntax = FileType.swiftDocumentationSyntax
          let lineDocumentationSyntax = documentationSyntax.lineCommentSyntax!

          var file = try TextFile(alreadyAt: url)

          var searchIndex = file.contents.scalars.startIndex
          while let match = file.contents.scalars[
            min(searchIndex, file.contents.scalars.endIndex)
              ..< file.contents.scalars.endIndex]
            .firstMatch(for: InterfaceLocalization.documentationDirective)
          {
            searchIndex = match.range.upperBound

            let identifier = match.directiveArgument()
            guard
              let replacement = try documentationDefinitions(output: output)[
                identifier]
            else {
              throw Command.Error(
                description: UserFacing<StrictString, InterfaceLocalization>({
                  localization in
                  switch localization {
                  case .englishUnitedKingdom:
                    return "There is no documentation named ‘" + identifier
                      + "’."
                  case .englishUnitedStates, .englishCanada:
                    return "There is no documentation named “" + identifier
                      + "”."
                  case .deutschDeutschland:
                    return "Es gibt keine Dokumentation Namens „" + identifier
                      + "“."
                  }
                }))
            }

            let matchLines = match.range.lines(in: file.contents.lines)
            let nextLineStart = matchLines.upperBound.samePosition(
              in: file.contents.scalars)
            if let commentRange = documentationSyntax.rangeOfFirstComment(
              in: nextLineStart ..< file.contents.scalars.endIndex, of: file),
              file.contents.scalars[nextLineStart ..< commentRange.lowerBound]
                .firstMatch(for: CharacterSet.newlinePattern) == nil
            {

              let indent = StrictString(
                file.contents.scalars[nextLineStart ..< commentRange.lowerBound])

              file.contents.scalars.replaceSubrange(
                commentRange,
                with: lineDocumentationSyntax.comment(
                  contents: String(replacement), indent: String(indent)).scalars)
            } else {
              var location: String.ScalarView.Index = nextLineStart
              file.contents.scalars.advance(
                &location,
                over: RepetitionPattern(
                  ConditionalPattern({ $0 ∈ CharacterSet.whitespaces })))

              let indent = StrictString(
                file.contents.scalars[nextLineStart ..< location])

              let result
                = StrictString(
                  lineDocumentationSyntax.comment(
                    contents: String(replacement), indent: String(indent)))
                + "\n" + indent

              file.contents.scalars.insert(contentsOf: result.scalars, at: location)
            }
          }

          try file.writeChanges(for: self, output: output)
        }
      }
    }
  }
}
