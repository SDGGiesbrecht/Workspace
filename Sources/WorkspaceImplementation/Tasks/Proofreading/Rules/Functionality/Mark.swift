/*
 Mark.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(Swift 5.2.4, Web lacks Foundation.)
#if !os(WASI)
  import Foundation
#endif

import SDGLogic
import SDGCollections
import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift

import WorkspaceLocalizations

internal struct Marks: TextRule {

  internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "marks"
      case .deutschDeutschland:
        return "überschrifte"
      }
    })

  internal static let expectedSyntax: StrictString = "/\u{2F} MAR\u{4B}: \u{2D} "

  private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
    switch localization {
    case .englishUnitedKingdom:
      return "Incomplete heading syntax. Use ‘\(expectedSyntax)’."
    case .englishUnitedStates, .englishCanada:
      return "Incomplete heading syntax. Use “\(expectedSyntax)”."
    case .deutschDeutschland:
      return "Unvollständige Überschriftssyntax. „\(expectedSyntax)“ verwenden."
    }
  })

  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    internal static func check(
      file: TextFile,
      in project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {
      for match in file.contents.scalars.matches(for: "MAR\u{4B}".scalars) {

        var errorExists = false
        var errorStart = match.range.lowerBound
        var errorEnd = match.range.upperBound

        let line = file.contents.lineRange(for: match.range)
        if file.contents.scalars[line].hasPrefix(
          RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces }))
            + "//".scalars
        ) {

          if ¬file.contents.scalars[..<match.range.lowerBound].hasSuffix(
            ¬"/".scalars + "/\u{2F} ".scalars
          ) {
            errorExists = true

            var possibleStart = match.range.lowerBound
            while possibleStart ≠ file.contents.scalars.startIndex {
              let previous = file.contents.scalars.index(before: possibleStart)
              if file.contents.scalars[previous] ∈ CharacterSet.whitespaces ∪ ["/"] {
                possibleStart = previous
              } else {
                break
              }
            }
            errorStart = possibleStart
          }

          if ¬file.contents.scalars[match.range.upperBound...]
            .hasPrefix(
              ": \u{2D} ".scalars + ¬ConditionalPattern({ $0 ∈ CharacterSet.whitespaces })
            )
          {
            errorExists = true

            file.contents.scalars.advance(
              &errorEnd,
              over: RepetitionPattern(":".scalars, count: 0...1)
                + RepetitionPattern(
                  ConditionalPattern({ $0 ∈ CharacterSet.whitespaces })
                )
                + RepetitionPattern("\u{2D}".scalars, count: 0...1)
                + RepetitionPattern(
                  ConditionalPattern({ $0 ∈ CharacterSet.whitespaces })
                )
            )
          }

          if errorExists {
            reportViolation(
              in: file,
              at: errorStart..<errorEnd,
              replacementSuggestion: expectedSyntax,
              message: message,
              status: status
            )
          }
        }
      }
    }
  #endif
}
