/*
 DeprecatedResourceDirectory.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGLogic
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift

  import WorkspaceLocalizations

  internal struct DeprecatedResourceDirectory: TextRule {
    // Deprecated in 0.40.0 (????‐??‐??)
    // Remove “Resource.deprecated” property when support is dropped completely.)

    internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "deprecatedResourceDirectory"
        case .deutschDeutschland:
          return "überholteRessourcenOrdner"
        }
      })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Resources now belong inside the target directory."
      case .deutschDeutschland:
        return "Ressourcen gehören jetzt im Ordner des Ziels."
      }
    })

    internal static func check(
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {
      directories: for directory in project.deprecatedResourceDirectories() {
        if let contents = try? FileManager.default.deepFileEnumeration(in: directory) {
          files: for file in contents.sorted() where FileType(url: file) ≠ nil {
            if let text = try? TextFile(possiblyAt: file) {
              reportViolation(in: text, at: text.contents.bounds, message: message, status: status)
              break files
            }
          }
        }
      }
    }

    internal static func check(
      file: TextFile,
      in project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) throws {
      // Handled elsewhere.
    }
  }
#endif
