/*
 PackageRepository + Documentation.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation
  import Dispatch

  import SDGControlFlow
  import SDGLogic
  import SDGMathematics
  import SDGCollections

  import SDGCommandLine

  import SDGSwift
  import SDGXcode
  import SDGSwiftSource
  import SDGSwiftDocumentation
  import SDGHTML
  import SDGCSS

  import WorkspaceLocalizations
  import WorkspaceConfiguration

  extension PackageRepository {

    // MARK: - Static Properties

    internal static let documentationDirectoryName = "docs"  // Matches GitHub Pages.

    // MARK: - Properties

    internal func hasTargetsToDocument() throws -> Bool {
      guard #available(macOS 10.15, *) else {
        throw SwiftPMUnavailableError()  // @exempt(from: tests)
      }
      return try cachedPackage().products.contains(where: { $0.type.isLibrary })
    }

    // MARK: - Configuration

    internal var defaultDocumentationDirectory: URL {
      return location.appendingPathComponent(PackageRepository.documentationDirectoryName)
    }

    @available(macOS 10.15, *)
    private func loadSwiftInterface(
      output: Command.Output
    ) throws -> SDGSwiftDocumentation.PackageAPI {
      let result = try self.api(
        reportProgress: { output.print($0) }
      ).get()
      output.print("")
      return result
    }

    private func loadCommandLineInterface(
      output: Command.Output
    ) throws -> PackageCLI {
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
        localizations: try configuration(output: output).documentation.localizations
      )
    }

    internal func resolvedCopyright(
      documentationStatus: DocumentationStatus,
      output: Command.Output
    ) throws -> [LocalizationIdentifier?: StrictString] {

      var template: [LocalizationIdentifier?: StrictString] = try documentationCopyright(
        output: output
      ).mapKeys { $0 }
      template[nil] = "#dates"

      let dates: StrictString
      if let specified = try configuration(output: output).documentation.api.yearFirstPublished {
        dates = StrictString(
          WorkspaceImplementation.copyright(fromText: "©\(specified.inEnglishDigits())")
        )
      } else {
        documentationStatus.reportMissingYearFirstPublished()
        dates = StrictString(WorkspaceImplementation.copyright(fromText: ""))
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
          try purgingAutoreleased {
            switch entry {
            case .heading(text: let translations):
              if let text = translations[localization] {
                markdown += [
                  "",
                  "## \(text)",
                ]
              }
            case .project(let url):
              let package = try PackageRepository.relatedPackage(
                SDGSwift.Package(url: url),
                output: output
              )
              let name: StrictString
              if let packageName = try? package.projectName(
                in: localization,
                output: output
              ) {
                name = packageName  // @exempt(from: tests) False positive in Xcode 10.
              } else {
                // @exempt(from: tests) Only reachable with a non‐package repository.
                name = StrictString(url.lastPathComponent)
              }

              markdown += [
                "",
                "### \(name)",  // (DocC ignores links in headers.)
                "",
              ]

              guard #available(macOS 10.15, *) else {
                throw SwiftPMUnavailableError()  // @exempt(from: tests)
              }
              var linkHandled = false
              var parserCache = ParserCache()
              if let packageName = try? package.packageName(),
                let documentation =
                  package
                  .documentation(packageName: String(packageName))
                  .resolved(localizations: localizations)
                  .documentation[localization],
                let description = documentation.documentation().descriptionSection(cache: &parserCache)
              {
                var text = StrictString(description.text())
                if text.contains(name) {
                  text.replaceMatches(for: name, with: "[\(name)](\(url.absoluteString))")
                  linkHandled = true
                }
                markdown += [text]
              }
              if ¬linkHandled {
                markdown += ["[\(url.absoluteString)](\(url.absoluteString))"]
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

    internal func document(
      outputDirectory: URL,
      validationStatus: inout ValidationStatus,
      output: Command.Output
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
            return "Dokumentation wird erstellt ..." + section.anchor
          }
        }).resolved().formattedAsSectionHeader()
      )
      do {
        try prepare(outputDirectory: outputDirectory, output: output)

        let status = DocumentationStatus(output: output)
        try document(
          outputDirectory: outputDirectory,
          documentationStatus: status,
          output: output,
          coverageCheckOnly: false
        )

        try finalizeSite(outputDirectory: outputDirectory, output: output)

        if status.passing {
          validationStatus.passStep(
            message: UserFacing({ localization in
              switch localization {
              case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Generated documentation."
              case .deutschDeutschland:
                return "Dokumentation erstellt."
              }
            })
          )
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
            })
          )
        }
      } catch {
        // @exempt(from: tests) Unreachable without SwiftSyntax or file system failure.
        output.print(error.localizedDescription.formattedAsError())
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
          })
        )
      }
    }

    // Preliminary steps irrelevent to validation.
    private func prepare(outputDirectory: URL, output: Command.Output) throws {
      // Nothing to do anymore.
    }

    // Steps which participate in validation.
    private func document(
      outputDirectory: URL,
      documentationStatus: DocumentationStatus,
      output: Command.Output,
      coverageCheckOnly: Bool
    ) throws {

      let configuration = try self.configuration(output: output)
      let developmentLocalization = try self.developmentLocalization(output: output)

      let copyright = try resolvedCopyright(
        documentationStatus: documentationStatus,
        output: output
      )
      for localization in configuration.localizationsOrSystemFallback {
        if copyright[localization] == nil {
          documentationStatus.reportMissingCopyright(localization: localization)
        }
      }

      guard #available(macOS 10.15, *) else {
        throw SwiftPMUnavailableError()  // @exempt(from: tests)
      }
      // #workaround(Needs to merge graphs from other platforms.)
      let api = try loadSwiftInterface(output: output)
      let cli = try loadCommandLineInterface(
        output: output
      )

      var relatedProjects: [LocalizationIdentifier: Markdown] = [:]
      if ¬coverageCheckOnly {
        relatedProjects = try self.relatedProjects(output: output)
      }

      // Fallback so that documenting produces something the first time a user tries it with an empty configuration, even though the results will change from one device to another.
      let localizations = configuration.localizationsOrSystemFallback

      api.validateCoverage(documentationStatus: documentationStatus, projectRoot: location)

      if ¬coverageCheckOnly {
        let packageName = try projectName(in: developmentLocalization, output: output)
        let hostingBasePath = configuration.documentation.api.hostingBasePath.resolve(configuration)
        let packageBundle = PackageDocumentationBundle(
          localizations: localizations,
          developmentLocalization: developmentLocalization,
          docCBundleName: packageName,
          hostingBasePath: hostingBasePath,
          copyright: copyright,
          installation: configuration.documentation.installationInstructions.resolve(configuration),
          importing: configuration.documentation.importingInstructions.resolve(configuration),
          api: api,
          cli: cli,
          relatedProjects: relatedProjects,
          about: configuration.documentation.about
        )
        try DocumentSyntax.redirect(
          language: ContentLocalization.englishUnitedStates,  // To match DocC
          target: URL(fileURLWithPath: "\(packageName)/documentation/\(String(DocumentationBundle.sanitize(title: packageName)).lowercased())")
        ).source().save(to: outputDirectory.appendingPathComponent("index.html"))
        var packageAlreadyHandled = false
        for module in api.modules {
          try FileManager.default.withTemporaryDirectory(appropriateFor: outputDirectory) { temporary in
            let name = module.names.title
            let bundleURL = temporary.appendingPathComponent("\(name).docc")
            var embededPackageBundle: PackageDocumentationBundle?
            if name == String(packageName) {
              embededPackageBundle = packageBundle
              packageAlreadyHandled = true
            }
            let bundle = ModuleDocumentationBundle(
              developmentLocalization: developmentLocalization,
              copyright: copyright,
              module: module,
              package: api,
              hostingBasePath: hostingBasePath,
              embedPackageBundle: embededPackageBundle
            )
            try bundle.write(to: bundleURL)
            _ = try SwiftCompiler.assembleDocumentation(
              in: outputDirectory.appendingPathComponent(name),
              name: name,
              bundle: bundleURL,
              symbolGraphs: module.symbolGraphs.map({ $0.origin }),
              hostingBasePath: hostingBasePath.appending("/" + name),
              reportProgress: { output.print($0) }
            ).get()
            output.print("")
          }
        }
        if ¬packageAlreadyHandled {
          try FileManager.default.withTemporaryDirectory(appropriateFor: outputDirectory) { temporary in
            let bundleURL = temporary.appendingPathComponent("\(packageName).docc")
            let placeholerGraphURL = temporary.appendingPathComponent(String(PackageDocumentationBundle.placeholderSymbolGraphFileName(packageName: packageName)))
            try PackageDocumentationBundle.placeholderSymbolGraphData(packageName: packageName).save(to: placeholerGraphURL)
            try packageBundle.write(to: bundleURL)
            _ = try SwiftCompiler.assembleDocumentation(
              in: outputDirectory.appendingPathComponent(String(packageName)),
              name: String(packageName),
              bundle: bundleURL,
              symbolGraphs: [placeholerGraphURL],
              hostingBasePath: hostingBasePath.appending("/" + String(packageName)),
              reportProgress: { output.print($0) }
            ).get()
            output.print("")
          }
        }
      }
    }

    // Final steps irrelevent to validation.
    private func finalizeSite(outputDirectory: URL, output: Command.Output) throws {
      try preventJekyllInterference(outputDirectory: outputDirectory)
      try redirectDeadLinks(outputDirectory: outputDirectory, output: output)
    }

    private func redirectDeadLinks(outputDirectory: URL, output: Command.Output) throws {

      output.print(
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Checking for defunct URLs to redirect..."
          case .deutschDeutschland:
            return "Verstorbene Ressourcenzeiger werden weiterleitet ..."
          }
        }).resolved()
      )

      try FileManager.default.withTemporaryDirectory(appropriateFor: outputDirectory) { temporary in
        let repository = temporary.appendingPathComponent("Repository")
        try? FileManager.default.createDirectory(at: repository.deletingLastPathComponent())
        try retrievePublishedDocumentationIfAvailable(
          outputDirectory: repository,
          output: output
        )
        try redirect(urlsDroppedFrom: repository, for: outputDirectory)
      }
    }

    private func retrievePublishedDocumentationIfAvailable(
      outputDirectory: URL,
      output: Command.Output
    ) throws {
      if let packageURL = try configuration(output: output).documentation.repositoryURL {
        FileManager.default
          .withTemporaryDirectory(appropriateFor: outputDirectory) { temporary in
            let package = SDGSwift.Package(url: packageURL)
            do {
              _ = try Git.clone(package, to: temporary).get()
              _ = try PackageRepository(at: temporary).checkout("gh\u{2D}pages").get()
              try FileManager.default.move(temporary, to: outputDirectory)
            } catch {}
          }
      }
    }

    private func redirect(urlsDroppedFrom previous: URL, for current: URL) throws {
      if (try? previous.checkResourceIsReachable()) == true {
        // @exempt(from: tests) Not testable.
        for file in try FileManager.default.deepFileEnumeration(in: previous) {
          try purgingAutoreleased {
            let relative = file.resolvingSymlinksInPath()
              .path(relativeTo: previous.resolvingSymlinksInPath())
            try redirectIfDead(relativePath: relative, in: current)
          }
        }
      }
    }

    private func redirectIfDead(relativePath: String, in outputDirectory: URL) throws {
      // @exempt(from: tests) Not testable.
      let url = outputDirectory.appendingPathComponent(relativePath)
      if url.pathExtension == "html" {
        if (try? url.checkResourceIsReachable()) ≠ true {
          let localization = ContentLocalization.englishUnitedStates  // To match DocC
          if url.lastPathComponent == "index.html" {
            try DocumentSyntax.redirect(
              language: localization,
              target: URL(fileURLWithPath: "../index.html")
            ).source().save(to: url)
            let ancestor = url.deletingLastPathComponent()
            if ancestor.resolvingSymlinksInPath().is(in: outputDirectory.resolvingSymlinksInPath()) {
              try redirectIfDead(
                relativePath: ancestor.resolvingSymlinksInPath()
                  .path(relativeTo: outputDirectory.resolvingSymlinksInPath()),
                in: outputDirectory
              )
            }
          } else {
            try DocumentSyntax.redirect(
              language: localization,
              target: URL(fileURLWithPath: "index.html")
            ).source().save(to: url)
            try redirectIfDead(
              relativePath: url
                .deletingLastPathComponent().appendingPathComponent("index.html")
                .resolvingSymlinksInPath()
                .path(relativeTo: outputDirectory.resolvingSymlinksInPath()),
              in: outputDirectory
            )
          }
        }
      }
    }

    private func preventJekyllInterference(outputDirectory: URL) throws {
      try Data().write(to: outputDirectory.appendingPathComponent(".nojekyll"))
    }

    // MARK: - Validation

    internal func validateDocumentationCoverage(
      validationStatus: inout ValidationStatus,
      output: Command.Output
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
        }).resolved().formattedAsSectionHeader()
      )
      do {
        try FileManager.default.withTemporaryDirectory(appropriateFor: nil) { outputDirectory in

          let status = DocumentationStatus(output: output)
          try document(
            outputDirectory: outputDirectory,
            documentationStatus: status,
            output: output,
            coverageCheckOnly: true
          )

          if status.passing {
            validationStatus.passStep(
              message: UserFacing({ localization in
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                  return "Documentation coverage is complete."
                case .deutschDeutschland:
                  return "Die Dokumentationsabdeckung ist vollständig."
                }
              })
            )
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
              })
            )
          }
        }
      } catch {
        // @exempt(from: tests) Only triggered by system or networking errors.
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
          })
        )
      }
    }

    // MARK: - Inheritance

    private func documentationDefinitions(
      output: Command.Output
    ) throws -> [StrictString: StrictString] {
      return try _withDocumentationCache {

        var list: [StrictString: StrictString] = [:]

        for url in try sourceFiles(output: output) {
          try purgingAutoreleased {

            if let type = FileType(url: url),
              type ∈ Set([.swift, .swiftPackageManifest])
            {
              let file = try TextFile(alreadyAt: url)

              for match in file.contents.scalars.matches(
                for: InterfaceLocalization.documentationDeclaration
              ) {
                let identifier = match.declarationArgument()

                let nextLineStart = match.range.lines(in: file.contents.lines)
                  .upperBound.samePosition(in: file.contents.scalars)
                if let comment = FileType.swiftDocumentationSyntax
                  .contentsOfFirstComment(
                    in: nextLineStart..<file.contents.scalars.endIndex,
                    of: file
                  )
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

    internal func refreshInheritedDocumentation(output: Command.Output) throws {

      for url in try sourceFiles(output: output) {
        try purgingAutoreleased {

          if let type = FileType(url: url),
            type ∈ Set([.swift, .swiftPackageManifest])
          {

            let documentationSyntax = FileType.swiftDocumentationSyntax
            let lineDocumentationSyntax = documentationSyntax.lineCommentSyntax!

            var file = try TextFile(alreadyAt: url)

            var searchIndex = file.contents.scalars.startIndex
            while let match = file.contents.scalars[
              min(searchIndex, file.contents.scalars.endIndex)..<file.contents.scalars.endIndex
            ]
            .firstMatch(for: InterfaceLocalization.documentationDirective.forSubSequence()) {
              searchIndex = match.range.upperBound

              let identifier = match.directiveArgument()
              guard
                let replacement = try documentationDefinitions(output: output)[
                  identifier
                ]
              else {
                throw Command.Error(
                  description:
                    UserFacing<StrictString, InterfaceLocalization>({ localization in
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
                    })
                )
              }

              let matchLines = match.range.lines(in: file.contents.lines)
              let nextLineStart = matchLines.upperBound.samePosition(
                in: file.contents.scalars
              )
              if let commentRange = documentationSyntax.rangeOfFirstComment(
                in: nextLineStart..<file.contents.scalars.endIndex,
                of: file
              ),
                file.contents.scalars[nextLineStart..<commentRange.lowerBound]
                  .firstMatch(
                    for: CharacterSet.newlinePattern(for: String.ScalarView.SubSequence.self)
                  ) == nil
              {

                let indent = StrictString(
                  file.contents.scalars[nextLineStart..<commentRange.lowerBound]
                )

                file.contents.scalars.replaceSubrange(
                  commentRange,
                  with: lineDocumentationSyntax.comment(
                    contents: String(replacement),
                    indent: String(indent)
                  ).scalars
                )
              } else {
                var location: String.ScalarView.Index = nextLineStart
                file.contents.scalars.advance(
                  &location,
                  over: RepetitionPattern(
                    ConditionalPattern({ $0 ∈ CharacterSet.whitespaces })
                  )
                )

                let indent = StrictString(
                  file.contents.scalars[nextLineStart..<location]
                )

                let result =
                  StrictString(
                    lineDocumentationSyntax.comment(
                      contents: String(replacement),
                      indent: String(indent)
                    )
                  )
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
#endif
