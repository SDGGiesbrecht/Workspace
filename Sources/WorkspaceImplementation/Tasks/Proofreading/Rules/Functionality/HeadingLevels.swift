#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE

import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift
import SDGSwiftSource

import WorkspaceLocalizations

internal struct HeadingLevels: SyntaxRule {

  internal static let identifier = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "headingLevels"
      case .deutschDeutschland:
        return "überschriftsebenen"
      }
    })

  private static let message = UserFacing<StrictString, InterfaceLocalization>(
    { localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "Heading’s must be level three or higher; levels one and two are reserved by DocC."
      case .deutschDeutschland:
        return
          "Überschrifte müssen auf mindestens die dritte Ebene stehen; die erste und zweite Ebenen sind von DocC reserviert."
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
    if let token = node as? Token,
      case .headingDelimiter = token.kind,
      let heading = context.localAncestors.lazy.compactMap({ $0.node as? MarkdownHeading }).last,
      heading.level < 3 {
      reportViolation(
        in: file,
        at: context.location,
        message: message,
        status: status
      )
    }
  }
}

#endif
