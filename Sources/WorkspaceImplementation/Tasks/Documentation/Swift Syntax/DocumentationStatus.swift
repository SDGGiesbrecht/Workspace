/*
 DocumentationStatus.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGCommandLine

  import SymbolKit
  import SDGSwiftDocumentation

  import WorkspaceLocalizations
  import WorkspaceConfiguration

  internal class DocumentationStatus {

    // MARK: - Initialization

    internal init(output: Command.Output) {
      passing = true
      self.output = output
    }

    // MARK: - Properties

    internal var passing: Bool
    internal let output: Command.Output
    private var missingCopyrightLocalizations: Set<LocalizationIdentifier> = []

    // MARK: - Reporting

    private func report(problem: UserFacing<StrictString, InterfaceLocalization>) {
      passing = false
      output.print(problem.resolved().formattedAsError().separated())
    }

    private func report<SymbolType>(
      problem: UserFacing<StrictString, InterfaceLocalization>,
      with symbol: SymbolType,
      navigationPath: [SymbolLike],
      projectRoot: URL,
      localization: LocalizationIdentifier? = nil,
      hint: UserFacing<StrictString, InterfaceLocalization>? = nil
    ) where SymbolType: SymbolLike {
      var symbolName: StrictString
      switch symbol {
      case is PackageAPI, is LibraryAPI, is ModuleAPI:
        symbolName = StrictString(symbol.names.title)
      default:
        symbolName = navigationPath.dropFirst()
          .map({ StrictString($0.names.title.components(separatedBy: ".").last!) })
          .joined(separator: ".")
      }
      if let localized = localization {
        symbolName += "." + localized._iconOrCode
      }
      report(
        problem: UserFacing({ localization in
          var result: [StrictString] = [
            problem.resolved(for: localization),
            symbolName,
          ]
          if let theHint = hint {
            result.append(theHint.resolved(for: localization))
          }
          if let location = symbol.location {
            result.append(contentsOf: [
              StrictString(
                location.url?.path(relativeTo: projectRoot)
                  ?? location.uri  // @exempt(from: tests) Should never happen.
              ),
              CommandLineProofreadingReporter.lineNumberReport(location.position.line).resolved(
                for: localization
              ),
            ])
          }
          return result.joined(separator: "\n")
        })
      )
    }

    internal func reportMissingDescription<SymbolType>(
      symbol: SymbolType,
      navigationPath: [SymbolLike],
      projectRoot: URL,
      localization: LocalizationIdentifier
    ) where SymbolType: SymbolLike {
      var hint: UserFacing<StrictString, InterfaceLocalization>?

      var possibleSearch: StrictString?
      switch symbol {
      case is PackageAPI:
        possibleSearch = "Package"
      case is LibraryAPI:
        possibleSearch = ".library"
      case is ModuleAPI:
        possibleSearch = ".target"
      default:
        break
      }
      if var search = possibleSearch {
        search.append(
          contentsOf: "(name: \u{22}" + StrictString(symbol.names.title) + "\u{22}"
        )

        hint = UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom:
            return
              "(Packages, products and modules (targets) can be documented in the package manifest the same way as other symbols.\nWorkspace will look for documentation on the line above ‘"
              + search + "’.)"
          case .englishUnitedStates, .englishCanada:
            return
              "(Packages, products and modules (targets) can be documented in the package manifest the same way as other symbols.\nWorkspace will look for documentation on the line above “"
              + search + "”.)"
          case .deutschDeutschland:
            return
              "(Pakete, Produkte und Module (Ziele) können in der Ladeliste wie alle andere Symbole Dokumentiert werden.\nArbeitsbereich sucht für die Dokumentation in der Zeile über „"
              + search + "“.)"
          }
        })
      }

      report(
        problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "A symbol has no description:"
          case .deutschDeutschland:
            return "Einem Symbol fehlt die Beschreibung."
          }
        }),
        with: symbol,
        navigationPath: navigationPath,
        projectRoot: projectRoot,
        localization: localization,
        hint: hint
      )
    }

    internal func reportMismatchedParameters<SymbolType>(
      _ parameters: [String],
      expected: [String],
      symbol: SymbolType,
      navigationPath: [SymbolLike],
      projectRoot: URL,
      localization: LocalizationIdentifier
    ) where SymbolType: SymbolLike {
      report(
        problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "A symbol has mismatched parameter descriptions: \(parameters.joined(separator: ", "))"
          case .deutschDeutschland:
            return "Ein Symbol hat fehlangepasste Übergabewertenbeschreibungen: \(parameters.joined(separator: ", "))"
          }
        }),
        with: symbol,
        navigationPath: navigationPath,
        projectRoot: projectRoot,
        localization: localization,
        hint: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "(Expected: \(expected.joined(separator: ", ")))"
          case .deutschDeutschland:
            return "(Erwartete: \(expected.joined(separator: ", ")))"
          }
        })
      )
    }

    internal func reportMissingYearFirstPublished() {
      report(
        problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return
              ([
                "No original copyright date is specified.",
                WorkspaceConfiguration.configurationRecommendation(
                  for: "documentation.api.yearFirstPublished",
                  localization: localization
                ),
              ] as [StrictString]).joinedAsLines()
          case .deutschDeutschland:
            return
              ([
                "Kein ursprüngliche Urheberrechtsdatum wurde angegeben.",
                WorkspaceConfiguration.configurationRecommendation(
                  for: "dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung",
                  localization: localization
                ),
              ] as [StrictString]).joinedAsLines()
          }
        })
      )
    }

    internal func reportMissingCopyright(localization: LocalizationIdentifier) {
      if ¬missingCopyrightLocalizations.contains(localization) {
        missingCopyrightLocalizations.insert(localization)
        report(
          problem: UserFacing<StrictString, InterfaceLocalization>({ warningLocalization in
            switch warningLocalization {
            case .englishUnitedKingdom:
              return
                ([
                  "A localisation has no copyright specified: \(arbitraryDescriptionOf: localization)",
                  WorkspaceConfiguration.configurationRecommendation(
                    for: "documentation.api.copyrightNotice",
                    localization: warningLocalization
                  ),
                ] as [StrictString]).joinedAsLines()
            case .englishUnitedStates, .englishCanada:
              return
                ([
                  "A localization has no copyright specified: \(arbitraryDescriptionOf: localization)",
                  WorkspaceConfiguration.configurationRecommendation(
                    for: "documentation.api.copyrightNotice",
                    localization: warningLocalization
                  ),
                ] as [StrictString]).joinedAsLines()
            case .deutschDeutschland:
              return
                ([
                  "Einer Lokalization fehlt die Urheberrechtsschutzvermerk: \(arbitraryDescriptionOf: localization)",
                  WorkspaceConfiguration.configurationRecommendation(
                    for: "dokumentation.programmierschnittstelle.urheberrechtsschutzvermerk",
                    localization: warningLocalization
                  ),
                ] as [StrictString]).joinedAsLines()
            }
          })
        )
      }
    }

    internal func reportExcessiveHeading<SymbolType>(
      symbol: SymbolType,
      navigationPath: [SymbolLike],
      projectRoot: URL,
      localization: LocalizationIdentifier
    ) where SymbolType: SymbolLike {
      report(
        problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "A symbol’s documentation contains excessively strong headings:"
          case .deutschDeutschland:
            return "Die Dokumentation eines Symbols enthaltet überstarke Überschrifte:"
          }
        }),
        with: symbol,
        navigationPath: navigationPath,
        projectRoot: projectRoot,
        localization: localization,
        hint: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return
              "(Use heading levels three to six. Levels one and two are reserved for the surrounding context.)"
          case .deutschDeutschland:
            return
              "(Überschriftsebenen drei bis sechs stehen offen. Ebene eins und zwei sind für den umliegenden Rahmen vorbehalten.)"
          }
        })
      )
    }
  }
#endif