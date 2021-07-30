/*
 RefreshExamples.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift

import WorkspaceLocalizations

extension Workspace.Refresh {

  internal enum Examples {

    private static let name = UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "examples"
      case .deutschDeutschland:
        return "beispiele"
      }
    })

    private static let description = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom:
          return "synchronises the project’s compiled examples."
        case .englishUnitedStates, .englishCanada:
          return "synchronizes the project’s compiled examples."
        case .deutschDeutschland:
          return "stimmt die übersetzte Beispiele des Projekts miteinander ab."
        }
      })

    private static let discussion = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom:
          return [
            "When APIs change, it is easy to forget to update any examples in the documentation. Workspace allows examples to be synchronised with real, compiled source code in a test module. That way, when an API change makes an example invalid, it will be caught by the compiler.",
            "",
            "Examples can be defined anywhere in the project, but usually the best place for them is in a test module.",
            "",
            "To define an example, place it between ‘@example(identifier)’ and ‘@endExample’. Anything on the same line as either token will be ignored (such as ‘//’).",
            "",
            "func forTheSakeOfLeavingTheGlobalScope() {",
            "    let a = 0",
            "    let b = 0",
            "    let c = 0",
            "",
            "    // @example(symmetry)",
            "    if a == b {",
            "        assert(b == a)",
            "    }",
            "    // @endExample",
            "",
            "    // @example(transitivity)",
            "    if a == b ∧ b == c {",
            "        assert(a == c)",
            "    }",
            "    // @endExample",
            "}",
            "",
            "To use an example in a symbol’s documentation, add one or more instances of ‘#example(0, identifier)’ to the line immediately preceding the documentation.",
            "",
            "// #example(1, symmetry) #example(2, transitivity)",
            "/// Returns `true` if `lhs` is equal to `rhs`.",
            "///",
            "/// Equality is symmetrical:",
            "///",
            "/// ```swift",
            "/// (Workspace will automatically fill these in whenever the project is refreshed.)",
            "/// ```",
            "///",
            "/// Equality is transitive:",
            "///",
            "/// ```swift",
            "///",
            "/// ```",
            "func == (lhs: Thing, rhs: Thing) \u{2D}> Bool {",
            "    return lhs.rawValue == rhs.rawValue",
            "}",
          ].joinedAsLines()
        case .englishUnitedStates, .englishCanada:
          return [
            "When APIs change, it is easy to forget to update any examples in the documentation. Workspace allows examples to be synchronized with real, compiled source code in a test module. That way, when an API change makes an example invalid, it will be caught by the compiler.",
            "",
            "Examples can be defined anywhere in the project, but usually the best place for them is in a test module.",
            "",
            "To define an example, place it between “@example(identifier)” and “@endExample”. Anything on the same line as either token will be ignored (such as “//”).",
            "",
            "func forTheSakeOfLeavingTheGlobalScope() {",
            "    let a = 0",
            "    let b = 0",
            "    let c = 0",
            "",
            "    // @example(symmetry)",
            "    if a == b {",
            "        assert(b == a)",
            "    }",
            "    // @endExample",
            "",
            "    // @example(transitivity)",
            "    if a == b ∧ b == c {",
            "        assert(a == c)",
            "    }",
            "    // @endExample",
            "}",
            "",
            "To use an example in a symbol’s documentation, add one or more instances of “#example(0, identifier)” to the line immediately preceding the documentation.",
            "",
            "// #example(1, symmetry) #example(2, transitivity)",
            "/// Returns `true` if `lhs` is equal to `rhs`.",
            "///",
            "/// Equality is symmetrical:",
            "///",
            "/// ```swift",
            "/// (Workspace will automatically fill these in whenever the project is refreshed.)",
            "/// ```",
            "///",
            "/// Equality is transitive:",
            "///",
            "/// ```swift",
            "///",
            "/// ```",
            "func == (lhs: Thing, rhs: Thing) \u{2D}> Bool {",
            "    return lhs.rawValue == rhs.rawValue",
            "}",
          ].joinedAsLines()
        case .deutschDeutschland:
          return [
            "Bei Änderungen zu der Programmierschnittstelle, werden oft Beispiele in der Dokumentation vergessen. Arbeitsbereich ermöglicht das Abstimmen zwischen Beispiele und echten, Übersetzten Quelltext in einem Testmodul. So werden überholte Beispiele von dem Übersetzer erwischt.",
            "",
            "Beispiele können überall im Projekt festgelegt werden, aber in Testmodule geht es meistens am Besten.",
            "",
            "Beispiele können festgelegt sein, in dem man das Beispiel zwischen „@beispiel(kennzeichen)“ und „@beispielBeenden“ plaziert. Weiteres auf der selben Zeile wird nicht berücksichtigt (z. B. „//“).",
            "",
            "func umDenGlobalenAblaufZuVerlassen() {",
            "    let a = 0",
            "    let b = 0",
            "    let c = 0",
            "",
            "    // @beispiel(symmetrie)",
            "    if a == b {",
            "        assert(b == a)",
            "    }",
            "    // @beispielBeenden",
            "",
            "    // @beispiel(transitivität)",
            "    if a == b ∧ b == c {",
            "        assert(a == c)",
            "    }",
            "    // @beispielBeenden",
            "}",
            "",
            "Beispiele können in Dokumentation verwendet werden, in dem man ein oder mehrere Fälle von „#beispiel(0, kennzeichen)“ auf der vorstehende Zeile hinzufügt.",
            "",
            "// #beispiel(1, symmetrie) #beispiel(2, transitivität)",
            "/// Gibt `wahr` zurück, wenn `links` gleich `rechts` ist.",
            "///",
            "/// Gleichheit ist symmetrisch:",
            "///",
            "/// ```swift",
            "/// (Arbeistbereich füllt diese automatisch ein, wenn das Projekt aufgefrischt wird.)",
            "/// ```",
            "///",
            "/// Gleichheit ist transitiv:",
            "///",
            "/// ```swift",
            "///",
            "/// ```",
            "func == (links: Thing, rechts: Thing) \u{2D}> Bool {",
            "    return links.rawValue == rechts.rawValue",
            "}",
          ].joinedAsLines()
        }
      })

    #if !PLATFORM_NOT_SUPPORTED_BY_SWIFT_PM
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
                return "Refreshing examples..."
              case .deutschDeutschland:
                return "Beispiele werden aufgefrischt ..."
              }
            }).resolved().formattedAsSectionHeader()
          )

          try options.project.refreshExamples(output: output)
        }
      )
    #endif
  }
}
