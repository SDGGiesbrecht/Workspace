/*
 DocumentationStatus.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGSwiftSource

import WSProject

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

  #if !(os(Windows) || os(Android))  // #workaround(SwiftSyntax 0.50100.0, Cannot build.)
    private func report(
      problem: UserFacing<StrictString, InterfaceLocalization>,
      with symbol: APIElement,
      navigationPath: [APIElement],
      parameter: String? = nil,
      localization: LocalizationIdentifier? = nil,
      hint: UserFacing<StrictString, InterfaceLocalization>? = nil
    ) {
      var symbolName: StrictString
      switch symbol {
      case .package, .library, .module:
        symbolName = StrictString(symbol.name.source())
      case .type, .protocol, .extension, .case, .initializer, .variable, .subscript, .function,
        .operator, .precedence, .conformance:
        symbolName = navigationPath.dropFirst().map({ StrictString($0.name.source()) })
          .joined(separator: ".")
      }
      if let specificParameter = parameter {
        symbolName += "." + StrictString(specificParameter)
      }
      if let localized = localization {
        symbolName += "." + localized._iconOrCode
      }
      report(
        problem: UserFacing({ localization in
          var result: [StrictString] = [
            problem.resolved(for: localization),
            symbolName
          ]
          if let theHint = hint {
            result.append(theHint.resolved(for: localization))
          }
          return result.joined(separator: "\n")
        })
      )
    }

    internal func reportMissingDescription(
      symbol: APIElement,
      navigationPath: [APIElement],
      localization: LocalizationIdentifier
    ) {
      var hint: UserFacing<StrictString, InterfaceLocalization>?

      var possibleSearch: StrictString?
      switch symbol {
      case .package:
        possibleSearch = "Package"
      case .library:
        possibleSearch = ".library"
      case .module:
        possibleSearch = ".target"
      case .type, .protocol, .extension, .case, .initializer, .variable, .subscript, .function,
        .operator, .precedence, .conformance:
        break
      }
      if var search = possibleSearch {
        search.append(
          contentsOf: "(name: \u{22}" + StrictString(symbol.name.source()) + "\u{22}"
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
        localization: localization,
        hint: hint
      )
    }

    internal func reportMismatchedParameters(
      _ parameters: [String],
      expected: [String],
      symbol: APIElement,
      navigationPath: [APIElement],
      localization: LocalizationIdentifier
    ) {
      report(
        problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "A symbol has mismatched parameter descriptions:"
          case .deutschDeutschland:
            return "Ein Symbol hat fehlangepasste Übergabewertenbeschreibungen."
          }
        }),
        with: symbol,
        navigationPath: navigationPath,
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

    internal func reportUnlabelledParameter(
      _ closureType: String,
      symbol: APIElement,
      navigationPath: [APIElement]
    ) {
      report(
        problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "A closure parameter has no label:"
          case .deutschDeutschland:
            return "Einem Abschluss fehlt die Beschriftung."
          }
        }),
        with: symbol,
        navigationPath: navigationPath,
        parameter: closureType
      )
    }

    internal func reportMissingVariableType(_ variable: VariableAPI, navigationPath: [APIElement]) {
      report(
        problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "A public variable has no explicit type:"
          case .deutschDeutschland:
            return "Einem öffentlichen Variable fehlt der ausdrückliche Typ."
          }
        }),
        with: APIElement.variable(variable),
        navigationPath: navigationPath
      )
    }
  #endif

  internal func reportMissingYearFirstPublished() {
    report(
      problem: UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return (
            [
              "No original copyright date is specified.",
              "(Configure it under “documentation.api.yearFirstPublished”.)"
            ] as [StrictString]
          ).joinedAsLines()
        case .deutschDeutschland:
          return (
            [
              "Kein ursprüngliche Urheberrechtsdatum wurde angegeben.",
              "(Es ist unter „dokumentation.programmierschnittstelle.jahrErsterVeröffentlichung“ zu konfigurieren.)"
            ] as [StrictString]
          ).joinedAsLines()
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
            return (
              [
                "A localisation has no copyright specified: \(arbitraryDescriptionOf: localization)",
                "(Configure it under “documentation.api.copyrightNotice”.)"
              ] as [StrictString]
            ).joinedAsLines()
          case .englishUnitedStates, .englishCanada:
            return (
              [
                "A localization has no copyright specified: \(arbitraryDescriptionOf: localization)",
                "(Configure it under “documentation.api.copyrightNotice”.)"
              ] as [StrictString]
            ).joinedAsLines()
          case .deutschDeutschland:
            return (
              [
                "Einer Lokalization fehlt die Urheberrechtsschutzvermerk: \(arbitraryDescriptionOf: localization)",
                "(Es ist unter „dokumentation.programmierschnittstelle.urheberrechtsschutzvermerk“ zu konfigurieren.)"
              ] as [StrictString]
            ).joinedAsLines()
          }
        })
      )
    }
  }

  #if !(os(Windows) || os(Android))  // #workaround(SwiftSyntax 0.50100.0, Cannot build.)
    internal func reportExcessiveHeading(
      symbol: APIElement,
      navigationPath: [APIElement],
      localization: LocalizationIdentifier
    ) {
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
  #endif
}
