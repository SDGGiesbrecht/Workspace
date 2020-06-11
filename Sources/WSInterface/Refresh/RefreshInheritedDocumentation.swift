/*
 RefreshInheritedDocumentation.swift

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

import WSDocumentation

extension Workspace.Refresh {

  enum InheritedDocumentation {

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "inherited‐documentation"
      case .deutschDeutschland:
        return "geerbte‐dokumentation"
      }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom:
          return "synchronises the project’s inherited documentation."
        case .englishUnitedStates, .englishCanada:
          return "synchronizes the project’s inherited documentation."
        case .deutschDeutschland:
          return "stimmt die geerbte Dokumentation des Projekts ab."
        }
      })

    private static let discussion = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          let quotationMarks: (StrictString, StrictString)
          switch localization {
          case .englishUnitedKingdom:
            quotationMarks = ("‘", "’")
          case .englishUnitedStates, .englishCanada:
            quotationMarks = ("“", "”")
          case .deutschDeutschland:
            unreachable()
          }
          return [
            "It can be tedious re‐writing the same documentation over again. Workspace can make documentation comments re‐usable.",
            "",
            "Note: Both Xcode and Workspace now do this automatically in many situations when the child symbol is left undocumented, such as protocol conformances, default implementations and subclass overrides. The explicit directives described here should only be used as a fall‐back in situations where the tools cannot deduce the parent symbol automatically.",
            "",
            "To designate a documentation comment as a definition, place \(quotationMarks.0)@documentation(identifier)\(quotationMarks.1) on the line above. Anything on the same line will be ignored (such as \(quotationMarks.0)//\(quotationMarks.1)).",
            "",
            "protocol Rambler {",
            "    // @documentation(MyLibrary.Rambler.ramble)",
            "    /// Rambles on and on and on and on...",
            "    func ramble() \u{2D}> Never",
            "}",
            "",
            "Workspace can find definitions in any Swift file in the project.",
            "",
            "To inherit the documentation elsewhere, place \(quotationMarks.0)\u{23}documentation(identifier)\(quotationMarks.1) where the documentation would go (or above it if it already exists). Anything on the same line will be ignored (such as \(quotationMarks.0)//\(quotationMarks.1)).",
            "",
            "struct Teacher : Rambler {",
            "    // \u{23}documentation(Rambler.ramble)",
            "    /// (Workspace will automatically fill this in whenever the project is refreshed.)",
            "    func ramble() \u{2D}> Never {",
            "        print(\u{22}Blah\u{22})",
            "        while true {",
            "            print(\u{22}, blah\u{22})",
            "        }",
            "    }",
            "}",
          ].joinedAsLines()
        case .deutschDeutschland:
          return [
            "Dokementationskommentare immer wieder neu zu schreiben kann mühsam werden. Arbeitsbereich kann Dokumentationskommentare wiederverwendbar machen.",
            "",
            "Hinweis: Beide Xcode und Arbeitsbereich verstehen automatisch die Erbe von Dokumentation wenn das Kindsymbol keine Dokumentation hat, so wie Protokollübereinstimmungen, Standardimplementierungen und Unterklassenüberschreibungen. Die ausdrückliche Anweisungen, die hier beschrieben sind, sollen nur in Fällen verwendet werden, wo die Werkzeuge den Elternsymbol nicht automatisch rückschließen können.",
            "",
            "Um einen Dokumentationskommentar als Bestimmung zu bezeichnen, wird „@dokumentation(kennzeichen)“ auf der vorstehenden Zeile gestellt. Alles anderes auf der Zeile wird nicht beachtet (z. B. „//“).",
            "",
            "protocol Schwafler {",
            "    // @dokumentation(Schwafler.schwafeln)",
            "    /// Schwafelt weiter und weiter und weiter und weiter ...",
            "    func schwafeln() \u{2D}> Nie",
            "}",
            "",
            "Arbeitsbereich kann Bestimmungen in alle Swift‐Dateien des Projekts finden.",
            "",
            "Um die Dokemuntation sonstwo zu erben, wird „\u{23}dokumentation(kennzeichen)“ dort gestellt, wo die Dokumentation gehört (oder darüber, falls es schon existiert). Alles anderes auf der Zeile wird nicht beachtet (z. B. „//“).",
            "",
            "struct Lehrer : Schwafler {",
            "    // \u{23}dokumentation(Schwafler.schwafeln)",
            "    /// (Arbeitsbereich füllt es hier ein, wenn das Projekt aufgefrischt wird.)",
            "    func schwafeln() \u{2D}> Nie {",
            "        drucken(\u{22}Bla\u{22})",
            "        while true {",
            "            drucken(\u{22}bla\u{22})",
            "        }",
            "    }",
            "}",
          ].joinedAsLines()
        }
      })

    internal static let command = Command(
      name: name,
      description: description,
      discussion: discussion,
      directArguments: [],
      options: Workspace.standardOptions,
      execution: { (_, options: Options, output: Command.Output) throws in

        output.print(
          UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "Refreshing inherited documentation..."
            case .deutschDeutschland:
              return "Geerbte Dokumentation wird aufgefrischt ..."
            }
          }).resolved().formattedAsSectionHeader()
        )

        // #workaround(Swift 5.2.4, Web lacks Foundation.)
        #if !os(WASI)
          try options.project.refreshInheritedDocumentation(output: output)
        #endif
      }
    )
  }
}
