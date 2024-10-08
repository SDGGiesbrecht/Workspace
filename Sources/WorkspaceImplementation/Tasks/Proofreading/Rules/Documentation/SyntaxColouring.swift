/*
 SyntaxColouring.swift

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
  import SDGLogic
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift
  import SDGSwiftSource

  import WorkspaceLocalizations

  internal struct SyntaxColouring: SyntaxRule {

    internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishCanada:
          return "syntaxColouring"
        case .englishUnitedStates:
          return "syntaxColoring"
        case .deutschDeutschland:
          return "syntaxhervorhebung"
        }
      })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Language specifier missing. Specify a language for syntax colouring."
      case .deutschDeutschland:
        return "Das Sprachkennzeichen fehlt. Eine Sprache für Syntaxhervorhebung angeben."
      }
    })

    internal static func check(
      _ node: SyntaxNode,
      context: ScanContext,
      file: TextFile,
      setting: Setting,
      project: PackageRepository,
      status: ProofreadingStatus,
      output: Command.Output
    ) {

      if let codeDelimiter = node as? Token,
        case .codeDelimiter = codeDelimiter.kind,
        let codeBlockRelationship = context.localAncestors.last,
        let codeBlock = codeBlockRelationship.node as? CodeBlockNode,
         codeBlockRelationship.childIndex == 0
      {

        if codeBlock.language == nil {
          reportViolation(
            in: file,
            at: context.location,
            message: message,
            status: status
          )
        }
      }
    }
  }
#endif
