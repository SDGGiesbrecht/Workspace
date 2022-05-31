/*
 PackageRepository + Xcode.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGText
  import SDGLocalization

  import SDGCommandLine

  import SDGSwift
  import SDGXcode

  import WorkspaceLocalizations
  import WorkspaceProjectConfiguration

  extension PackageRepository {

    private static let proofreadTargetName = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Proofread"
        case .deutschDeutschland:
          return "Korrektur lesen"
        }
      })

    private static let instructions = UserFacing<StrictString, InterfaceLocalization>(
      { localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return [
            "Install Workspace if you wish to receive in‐code reports of style errors for this project.",
            "See " + StrictString(Metadata.packageURL.absoluteString),
          ].joinedAsLines()
        case .deutschDeutschland:
          return [
            "Installieren Sie Arbeitsbereich, wenn Sie Gestalltungsfehlermeldungen im Quelltext dieses Projekts sehen wollen.",
            "Siehe " + StrictString(Metadata.packageURL.absoluteString),
          ].joinedAsLines()
        }
      })

    private func script() throws -> String {
      if try isWorkspaceProject() {
        return "swift run workspace proofread •xcode"  // @exempt(from: tests)
      } else {
        return
          "export PATH=\u{5C}\u{22}$HOME/.SDG/Registry:$PATH\u{5C}\u{22} ; if which workspace > /dev/null ; then workspace proofread •xcode •use‐version "
          + Metadata.latestStableVersion.string()
          + " ; else echo \u{5C}\u{22}warning: \(PackageRepository.instructions.resolved())\u{5C}\u{22} ; fi"
      }
    }

    internal func refreshProofreadingXcodeProject(output: Command.Output) throws {
      let projectBundle = location.appendingPathComponent(
        "\(PackageRepository.proofreadTargetName.resolved()).xcodeproj"
      )
      var project = try TextFile(
        possiblyAt: projectBundle.appendingPathComponent("project.pbxproj")
      )
      var projectDefinition = try! String(file: Resources.proofreadProject, origin: nil)
      let encoding: String = String(projectDefinition.prefix(through: "\n")!.contents)
      projectDefinition.drop(through: "*/\n\n")
      projectDefinition.prepend(contentsOf: encoding)
      projectDefinition.replaceMatches(
        for: "[*target*]",
        with: String(PackageRepository.proofreadTargetName.resolved())
      )
      projectDefinition.replaceMatches(for: "[*script*]", with: try script())
      project.contents = projectDefinition
      try project.writeChanges(for: self, output: output)

      var scheme = try TextFile(
        possiblyAt: projectBundle.appendingPathComponent(
          "xcshareddata/xcschemes/\(PackageRepository.proofreadTargetName.resolved()).xcscheme"
        )
      )
      var schemeDefinition = Resources.proofreadScheme
      schemeDefinition.drop(through: "\u{2D}\u{2D}>\n\n")
      schemeDefinition.replaceMatches(
        for: "[*project*]",
        with: projectBundle.lastPathComponent
      )
      scheme.contents = schemeDefinition
      try scheme.writeChanges(for: self, output: output)
    }
  }
#endif
