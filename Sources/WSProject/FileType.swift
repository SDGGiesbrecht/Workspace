/*
 FileType.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import WSGeneralImports
import WorkspaceProjectConfiguration

public enum FileType {

  // MARK: - Static Properties

  private static var unsupportedFileTypesEncountered: [String: URL] = [:]
  public static func resetUnsupportedFileTypes() {
    unsupportedFileTypesEncountered = [:]
  }
  public static func unsupportedTypesWarning(
    for project: PackageRepository,
    output: Command.Output
  ) throws -> StrictString? {

    let expected = try project.configuration(output: output).repository.ignoredFileTypes
    let unexpectedTypes = unsupportedFileTypesEncountered.filter { key, _ in
      return key ∉ expected
    }

    if unexpectedTypes.isEmpty {
      return nil
    } else {
      defer { unsupportedFileTypesEncountered = [:] }  // Reset between tests.

      var warning: [StrictString] = [
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "Workspace encountered unsupported file types:"
          case .deutschDeutschland:
            return "Arbeitsbereich traf auf unbekannten Dateiformate:"
          }
        }).resolved()
      ]

      warning.append("")

      let types = unexpectedTypes.keys.sorted().map { key in
        return "\(key) (\(unexpectedTypes[key]!.path(relativeTo: project.location)))"
          as StrictString
      }
      warning.append(contentsOf: types)

      warning.append("")

      warning.append(
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return [
              "All such files were skipped.",
              "If these are standard file types, please report them at",
              StrictString(
                Metadata.issuesURL.absoluteString.in(Underline.underlined)
              ),
              "To silence this warning for non‐standard file types, configure “repository.ignoredFileTypes”."
            ].joinedAsLines()
          case .deutschDeutschland:
            return [
              "Solche Dateien wurden übersprungen.",
              "Falls sie Standarddateiformate sind, bitte melden Sie sie hier:",
              StrictString(
                Metadata.issuesURL.absoluteString.in(Underline.underlined)
              ),
              "Um diese Warnung für ungenormten Dateiformate abzudämpfen, „lager.ausgelasseneDateiformate“ konfigurieren."
            ].joinedAsLines()
          }
        }).resolved()
      )

      return warning.joinedAsLines()
    }
  }

  // MARK: - Initialization

  public init?(url: URL) {

    if let special = FileType.specialNames[url.lastPathComponent] {
      self = special
      return
    }

    var pathExtension = url.pathExtension
    if pathExtension.isEmpty {
      let components = url.lastPathComponent.components(separatedBy: ".") as [String]
      if components.count > 1 {
        pathExtension = components.last!
      } else {
        return nil  // File with no extension information.
      }
    }

    if let supported = FileType.fileExtensions[pathExtension] {
      self = supported
      return
    }

    if FileType.unsupportedFileTypesEncountered[pathExtension] == nil {
      FileType.unsupportedFileTypesEncountered[pathExtension] = url
    }
    return nil
  }

  // MARK: - Cases

  case c
  case cMake
  case cPlusPlus
  case css
  case gitIgnore
  case html
  case javaScript
  case json
  case lisp
  case markdown
  case objectiveC
  case objectiveCPlusPlus
  case python
  case shell
  case strings
  case swift
  case swiftPackageManifest
  case xcodeProject
  case xml
  case yaml

  private static let specialNames: [String: FileType] = [
    "CMakeLists.txt": .cMake,
    "Package.swift": .swiftPackageManifest
  ]

  private static let fileExtensions: [String: FileType] = [
    "c": .c,
    "cc": .cPlusPlus,
    "clang\u{2D}format": .yaml,
    "cmake": .cMake,
    "cpp": .cPlusPlus,
    "command": .shell,
    "css": .css,
    "el": .lisp,
    "gitattributes": .gitIgnore,
    "gitignore": .gitIgnore,
    "h": .objectiveC,
    "htm": html,
    "html": .html,
    "js": .javaScript,
    "json": .json,
    "m": .objectiveC,
    "mailmap": .gitIgnore,
    "md": .markdown,
    "mm": .objectiveCPlusPlus,
    "pbxproj": .xcodeProject,
    "py": .python,
    "sh": .shell,
    "swift": .swift,
    "strings": .strings,
    "xcscheme": .xml,
    "xml": .xml,
    "yaml": .yaml,
    "yml": .yaml
  ]

  // MARK: - Syntax

  private static let htmlBlockComment = BlockCommentSyntax(
    start: "<\u{21}\u{2D}\u{2D}",
    end: "\u{2D}\u{2D}>"
  )

  private static let swiftBlockCommentSyntax = BlockCommentSyntax(start: "/*", end: "*/")
  private static let swiftLineCommentSyntax = LineCommentSyntax(start: "//")
  public static let swiftDocumentationSyntax = FileSyntax(
    blockCommentSyntax: BlockCommentSyntax(start: "/*" + "*", end: "*/"),
    lineCommentSyntax: LineCommentSyntax(start: "///")
  )

  public var syntax: FileSyntax {
    switch self {

    case .swift, .c, .cPlusPlus, .css, .javaScript, .objectiveC, .objectiveCPlusPlus, .strings:
      return FileSyntax(
        blockCommentSyntax: FileType.swiftBlockCommentSyntax,
        lineCommentSyntax: FileType.swiftLineCommentSyntax
      )
    case .swiftPackageManifest:
      return FileSyntax(
        blockCommentSyntax: FileType.swiftBlockCommentSyntax,
        lineCommentSyntax: FileType.swiftLineCommentSyntax,
        requiredFirstLineToken: "/\u{2F} swift\u{2D}tools\u{2D}version:"
      )
    case .xcodeProject:
      return FileSyntax(
        blockCommentSyntax: FileType.swiftBlockCommentSyntax,
        lineCommentSyntax: FileType.swiftLineCommentSyntax,
        requiredFirstLineToken: "// !$*"
      )

    case .shell:
      return FileSyntax(
        blockCommentSyntax: nil,
        lineCommentSyntax: LineCommentSyntax(start: "#"),
        requiredFirstLineToken: "#!"
      )
    case .cMake, .gitIgnore, .yaml:
      return FileSyntax(
        blockCommentSyntax: nil,
        lineCommentSyntax: LineCommentSyntax(start: "#")
      )

    case .html, .xml:
      return FileSyntax(
        blockCommentSyntax: FileType.htmlBlockComment,
        lineCommentSyntax: nil,
        requiredFirstLineToken: "<\u{21}DOCTYPE"
      )
    case .markdown:
      return FileSyntax(
        blockCommentSyntax: FileType.htmlBlockComment,
        lineCommentSyntax: nil,
        semanticLineTerminalWhitespace: ["  "]
      )

    case .lisp:
      return FileSyntax(
        blockCommentSyntax: BlockCommentSyntax(start: "#|", end: "|#"),
        lineCommentSyntax: LineCommentSyntax(start: ";")
      )
    case .python:
      return FileSyntax(
        blockCommentSyntax: nil,
        lineCommentSyntax: LineCommentSyntax(start: "#"),
        requiredFirstLineToken: "#!"
      )

    case .json:
      return FileSyntax(blockCommentSyntax: nil, lineCommentSyntax: nil)
    }
  }
}
