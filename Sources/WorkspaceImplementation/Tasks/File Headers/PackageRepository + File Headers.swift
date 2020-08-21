/*
 PackageRepository.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

import WSProject

// #workaround(Swift 5.2.4, Web lacks Foundation.)
#if !os(WASI)
  extension PackageRepository {

    private static let skippedRelativePaths: [String] = [
      "LICENSE.md",
      ".github/ISSUE_TEMPLATE",
      ".github/PULL_REQUEST_TEMPLATE.md",
    ]

    private var skippedFiles: Set<URL> {
      return Set(
        PackageRepository.skippedRelativePaths.map({ location.appendingPathComponent($0) })
      )
    }

    internal func refreshFileHeaders(output: Command.Output) throws {

      let template = try fileHeader(output: output)

      let skippedFiles = self.skippedFiles
      for url in try sourceFiles(output: output)
      where ¬skippedFiles.contains(where: { url.is(in: $0) }) {
        try purgingAutoreleased {
          if let type = FileType(url: url),
            type.syntax.hasComments
          {

            var file = try TextFile(alreadyAt: url)
            let oldHeader = file.header
            var header = template

            header = header.replacingMatches(
              for: "#filename",
              with: StrictString(url.lastPathComponent)
            )
            header = header.replacingMatches(
              for: "#dates",
              with: copyright(fromText: oldHeader)
            )

            file.header = String(header)
            try file.writeChanges(for: self, output: output)
          }
        }
      }
    }
  }
#endif
