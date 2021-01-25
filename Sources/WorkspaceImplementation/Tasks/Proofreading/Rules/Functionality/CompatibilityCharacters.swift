/*
 CompatibilityCharacters.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift

import WorkspaceLocalizations

internal struct CompatibilityCharacters: TextRule {

  internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "compatibilityCharacters"
      case .deutschDeutschland:
        return "verträglichkeitsschriftzeichen"
      }
    })

    internal static func check(
      file: TextFile,
      in project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {
      for index in file.contents.scalars.indices {
        let scalar = file.contents.scalars[index]
        let character = String(scalar)
        let normalized = character.decomposedStringWithCompatibilityMapping
        if character ≠ normalized {
          reportViolation(
            in: file,
            at: index..<file.contents.scalars.index(after: index),
            replacementSuggestion: StrictString(normalized),
            message: UserFacing<StrictString, InterfaceLocalization>({ (localization) in
              switch localization {
              case .englishUnitedKingdom:
                return
                  "U+\(scalar.hexadecimalCode) may be lost in normalisation; use ‘\(normalized)’ instead."
              case .englishUnitedStates, .englishCanada:
                return
                  "U+\(scalar.hexadecimalCode) may be lost in normalization; use “\(normalized)” instead."
              case .deutschDeutschland:
                return
                  "U+\(scalar.hexadecimalCode) geht bei Normalisierung vielleicht verloren; stattdessen „\(normalized)“ verwenden."
              }
            }),
            status: status
          )
        }
      }
    }
}
