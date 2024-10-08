/*
 ClosureSignaturePosition.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift
  import SwiftSyntax
  import SDGSwiftSource

  import WorkspaceLocalizations

  internal struct ClosureSignaturePosition: SyntaxRule {

    internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "closureSignaturePosition"
        case .deutschDeutschland:
          return "abschlusssignaturplatzierung"
        }
      })

    private static let message = UserFacing<StrictString, InterfaceLocalization>({ (localization) in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "A closure’s signature should be on the same line as its opening brace."
      case .deutschDeutschland:
        return
          "Die Signatur eines Abschluss soll an der selbe Zeile stehen als seine öffnende geschweifte Klammer."
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

      if let signature = (node as? SwiftSyntaxNode)?.swiftSyntaxNode.as(ClosureSignatureSyntax.self),
        let closure = signature.parent?.as(ClosureExprSyntax.self),
        closure.signature?.indexInParent == signature.indexInParent,
        let leadingTrivia = signature.leadingTrivia
      {  // Only nil if the signature does not really exist.

        if leadingTrivia.contains(where: { $0.isNewline }) {
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
