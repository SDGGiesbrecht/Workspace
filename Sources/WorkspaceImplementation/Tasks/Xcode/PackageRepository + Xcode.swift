/*
 PackageRepository + Xcode.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGXcode

import WorkspaceProjectConfiguration

// #workaround(Swift 5.2.4, Web lacks Foundation.)
#if !os(WASI)
  extension PackageRepository {

    #if !os(Linux)

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

      private static let proofreadTargetIdentifier = "WORKSPACE_PROOFREAD_TARGET"
      private static let proofreadScriptIdentifier = "WORKSPACE_PROOFREAD_SCRIPT"

      private var aggregateTarget: String {
        return [
          "        \(PackageRepository.proofreadTargetIdentifier) = {",
          "            isa = PBXAggregateTarget;",
          "            buildPhases = (",
          "                \(PackageRepository.proofreadScriptIdentifier),",
          "            );",
          "            name = \u{22}\(PackageRepository.proofreadTargetName.resolved())\u{22};",
          "            productName = \u{22}\(PackageRepository.proofreadTargetName.resolved())\u{22};",
          "        };",
        ].joinedAsLines()
      }

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

      private func scriptObject() throws -> String {
        return [
          "        \(PackageRepository.proofreadScriptIdentifier) = {",
          "            isa = PBXShellScriptBuildPhase;",
          "            shellPath = /bin/sh;",
          "            shellScript = \u{22}\(try script())\u{22};",
          "        };",
        ].joinedAsLines()
      }

      internal func refreshXcodeProject(output: Command.Output) throws {
        _ = try generateXcodeProject(reportProgress: { output.print($0) }).get()
        resetFileCache(debugReason: "generate\u{2D}xcodeproj")
        output.print("")

        if let projectBundle = try xcodeProject() {
          var project = try TextFile(
            alreadyAt: projectBundle.appendingPathComponent("project.pbxproj")
          )

          let objectsLine = "objects = {"
          if let range = project.contents.scalars.firstMatch(for: objectsLine.scalars)?.range {
            project.contents.scalars.replaceSubrange(
              range,
              with: [
                objectsLine,
                aggregateTarget,
                try scriptObject(),
              ].joinedAsLines().scalars
            )
          }

          let targetsLine = "targets = ("
          if let range = project.contents.scalars.firstMatch(for: targetsLine.scalars)?.range {
            project.contents.scalars.replaceSubrange(
              range,
              with: [
                targetsLine,
                PackageRepository.proofreadTargetIdentifier + ",",
              ].joinedAsLines().scalars
            )
          }

          try project.writeChanges(for: self, output: output)

          var scheme = try TextFile(
            possiblyAt: projectBundle.appendingPathComponent(
              "/xcshareddata/xcschemes/Proofread.xcscheme"
            )
          )
          var schemeDefinition = Resources.Xcode.proofreadScheme
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
  }
#endif
