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

// #workaround(SwiftPM 0.6.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  import SwiftFormat
#endif

// #workaround(Swift 5.2.4, Web lacks Foundation.)
#if !os(WASI)
  extension PackageRepository {

    public func normalize(output: Command.Output) throws {

      // #workaround(SwiftPM 0.6.0, Cannot build.)
      #if !(os(Windows) || os(WASI) || os(Android))
        var formatter: SwiftFormatter?
        if let formatConfiguration = try configuration(output: output).proofreading
          .swiftFormatConfiguration?.reducedToMachineResponsibilities()
        {
          formatter = SwiftFormatter(configuration: formatConfiguration)
        }
      #endif

      for url in try sourceFiles(output: output) {
        try purgingAutoreleased {

          if let syntax = FileType(url: url)?.syntax {
            var file = try TextFile(alreadyAt: url)

            // #workaround(SwiftPM 0.6.0, Cannot build.)
            #if !(os(Windows) || os(WASI) || os(Android))
              if let formatter = formatter,
                file.fileType == .swift ∨ file.fileType == .swiftPackageManifest
              {
                let source = file.contents
                var result: String = ""
                try formatter.format(
                  source: source,
                  assumingFileURL: file.location,
                  to: &result
                )
                file.contents = result
              }
            #endif

            let lines = file.contents.lines.map({ String($0.line) })
            let normalizedLines = lines.map { (line: String) -> String in

              var normalized = line.decomposedStringWithCanonicalMapping

              var semanticWhitespace = ""
              for whitespace in syntax.semanticLineTerminalWhitespace {
                if normalized.hasSuffix(whitespace) {
                  semanticWhitespace = whitespace
                }
              }

              while let last = normalized.unicodeScalars.last,
                last ∈ CharacterSet.whitespaces
              {
                normalized.unicodeScalars.removeLast()
              }

              return normalized + semanticWhitespace
            }

            file.contents = normalizedLines.joinedAsLines()
            try file.writeChanges(for: self, output: output)
          }
        }
      }
    }
  }
#endif
