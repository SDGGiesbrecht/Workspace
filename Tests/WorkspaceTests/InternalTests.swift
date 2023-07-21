/*
 InternalTests.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2016–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2016–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift
import SDGSwiftDocumentation
import SymbolKit

import WorkspaceLocalizations
import WorkspaceConfiguration
@testable import WorkspaceImplementation

import XCTest

import SDGXCTestUtilities

class InternalTests: TestCase {

  #if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
    func testArticleTitles() {
      for localization in ContentLocalization.allCases {
        _ = PackageDocumentationBundle.about(localization: LocalizationIdentifier(localization))
      }
      _ = PackageDocumentationBundle.placeholderSymbolGraphFileName(packageName: "Package")
      _ = PackageDocumentationBundle.placeholderSymbolGraphData(packageName: "Package")
    }

    func testGitIgnoreCoverage() throws {
      let expectedPrefixes = [

        // Swift Package Manager
        "Package.swift",
        "Sources",
        "Tests",
        "Plugins",
        "Package.resolved",

        // Workspace
        "Workspace.swift",
        String(Script.refreshMacOS.fileName(localization: .englishCanada)),
        String(Script.refreshLinux.fileName(localization: .englishCanada)),
        "Resources",

        // Git
        ".gitignore",

        // GitHub
        "README.md",
        "LICENSE.md",
        ".github",
      ]

      _ = try Command(
        name: UserFacing<StrictString, InterfaceLocalization>({ _ in "" }),
        description: UserFacing<StrictString, InterfaceLocalization>({ _ in "" }),
        directArguments: [],
        options: [],
        execution: { (_, _, output: Command.Output) in

          let tracked = try PackageRepository(at: repositoryRoot).trackedFiles(output: output)
          let relative = tracked.map { $0.path(relativeTo: repositoryRoot) }
          let unexpected = relative.filter { path in

            for prefix in expectedPrefixes {
              if path.hasPrefix(prefix) {
                return false
              }
            }

            return true
          }

          XCTAssert(
            unexpected.isEmpty,
            [
              "Unexpected files are being tracked by Git:",
              unexpected.joinedAsLines(),
            ].joinedAsLines()
          )
        }
      ).execute(with: []).get()
    }

    func testPlatform() {
      for platform in Platform.allCases {
        for localization in ContentLocalization.allCases {
          _ = platform._isolatedName(for: localization)
        }
      }
    }

    func testLocalizationParsing() {
      let parsed = [
        SymbolDocumentation(
          developerComments: SymbolGraph.LineList([
            SymbolGraph.LineList.Line(text: "@crossReference(something) @notLocalized(🇬🇷ΕΛ)", range: nil)
          ]),
          documentationComment: SymbolGraph.LineList([]))
      ].resolved(localizations: [LocalizationIdentifier("🇮🇱עב")])
      XCTAssertEqual(parsed.crossReference, "something")
      XCTAssertEqual(parsed.skipped, [LocalizationIdentifier("🇬🇷ΕΛ")])
    }
  #endif

  func testResources() {
    _ = WorkspaceImplementation.Resources.apache2_0
    _ = WorkspaceImplementation.Resources.copyright
    _ = WorkspaceImplementation.Resources.gnuGeneralPublic3_0
    _ = WorkspaceImplementation.Resources.mit
    _ = WorkspaceImplementation.Resources.unlicense

    _ = WorkspaceImplementation.Resources.proofreadScheme
    _ = WorkspaceImplementation.Resources.proofreadProject
  }

  #if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
    func testXcodeProjectFormat() {
      // .gitignore interferes with testing this reliably in a mock project.
      _ = FileType.xcodeProject.syntax
    }

    func testWatermark() {
      for localization in ContentLocalization.allCases {
        _ = DocumentationBundle.watermark(localization: LocalizationIdentifier(localization))
      }
    }
  #endif
}
