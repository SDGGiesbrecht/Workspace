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

import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift
import SDGXcode

import WorkspaceLocalizations
import WorkspaceProjectConfiguration

// #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
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

      #warning("Extract to resource.")
      private func xcodeProjectSource() throws -> StrictString {
        return [
          "// !$*UTF8*$!",
          "{",
          "  archiveVersion = \u{22}1\u{22};",
          "  objectVersion = \u{22}46\u{22};",
          "  objects = {",
          "    \u{22}project\u{22} = {",
          "      isa = \u{22}PBXProject\u{22};",
          "      buildConfigurationList = \u{22}build configuration list\u{22};",
          "      compatibilityVersion = \u{22}Xcode 3.2\u{22};",
          "      mainGroup = \u{22}main group\u{22};",
          "      projectDirPath = \u{22}.\u{22};",
          "      targets = (",
          "        \u{22}proofread target\u{22}",
          "      );",
          "    };",
          "    \u{22}build configuration list\u{22} = {",
          "      isa = \u{22}XCConfigurationList\u{22};",
          "      buildConfigurations = (",
          "        \u{22}release\u{22}",
          "      );",
          "    };",
          "    \u{22}main group\u{22} = {",
          "      isa = \u{22}PBXGroup\u{22};",
          "      children = ();",
          "    };",
          "    \u{22}proofread target\u{22} = {",
          "      isa = PBXAggregateTarget;",
          "      buildPhases = (",
          "        \u{22}proofread script\u{22},",
          "      );",
          "      name = \u{22}\(PackageRepository.proofreadTargetName.resolved())\u{22};",
          "      productName = \u{22}\(PackageRepository.proofreadTargetName.resolved())\u{22};",
          "    };",
          "    \u{22}proofread script\u{22} = {",
          "      isa = PBXShellScriptBuildPhase;",
          "      shellPath = /bin/sh;",
          "      shellScript = \u{22}\(try script())\u{22};",
          "    };",
          "    \u{22}release\u{22} = {",
          "      isa = \u{22}XCBuildConfiguration\u{22};",
          "      buildSettings = {};",
          "      name = \u{22}Release\u{22};",
          "    };",
          "  };",
          "  rootObject = \u{22}project\u{22};",
          "}",
        ].joinedAsLines()
      }

      internal func refreshXcodeProject(output: Command.Output) throws {
        let projectBundle = location.appendingPathComponent(
          "\(PackageRepository.proofreadTargetName.resolved()).xcodeproj"
        )
        var project = try TextFile(
          possiblyAt: projectBundle.appendingPathComponent("project.pbxproj")
        )
        project.contents = String(try xcodeProjectSource())
        try project.writeChanges(for: self, output: output)

        var scheme = try TextFile(
          possiblyAt: projectBundle.appendingPathComponent(
            "/xcshareddata/xcschemes/Scheme.xcscheme"
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

    #endif
  }
#endif
