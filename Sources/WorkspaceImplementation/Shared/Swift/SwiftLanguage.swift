/*
 SwiftLanguage.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGLogic
  import SDGMathematics
  import SDGCollections

  import WorkspaceConfiguration

    import SwiftSyntax
  import SDGSwiftSource
    import SwiftFormat

  internal enum SwiftLanguage {

    // MARK: - Static Properties

    private static let allowedIdentifierStarters: CharacterSet = {
      // From https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html#//apple_ref/doc/uid/TP40014097-CH30-ID412

      var result = CharacterSet(charactersIn: "A"..."Z")

      result.insert(charactersIn: "a"..."z")

      result.insert(charactersIn: "_")
      result.insert(charactersIn: "\u{A8}\u{AA}\u{AD}\u{AF}")
      result.insert(charactersIn: Unicode.Scalar(0xB2)...Unicode.Scalar(0xB5))
      result.insert(charactersIn: Unicode.Scalar(0xB7)...Unicode.Scalar(0xBA))

      result.insert(charactersIn: Unicode.Scalar(0xBC)...Unicode.Scalar(0xBE))
      result.insert(charactersIn: Unicode.Scalar(0xC0)...Unicode.Scalar(0xD6))
      result.insert(charactersIn: Unicode.Scalar(0xD8)...Unicode.Scalar(0xF6))
      result.insert(charactersIn: Unicode.Scalar(0xF8)...Unicode.Scalar(0xFF))

      result.insert(charactersIn: Unicode.Scalar(0x100)!...Unicode.Scalar(0x2FF)!)
      result.insert(charactersIn: Unicode.Scalar(0x370)!...Unicode.Scalar(0x167F)!)
      result.insert(charactersIn: Unicode.Scalar(0x1681)!...Unicode.Scalar(0x180D)!)
      result.insert(charactersIn: Unicode.Scalar(0x180F)!...Unicode.Scalar(0x1DBF)!)

      result.insert(charactersIn: Unicode.Scalar(0x1E00)!...Unicode.Scalar(0x1FFF)!)

      result.insert(charactersIn: Unicode.Scalar(0x200B)!...Unicode.Scalar(0x200D)!)
      result.insert(charactersIn: Unicode.Scalar(0x202A)!...Unicode.Scalar(0x202E)!)
      result.insert(charactersIn: Unicode.Scalar(0x203F)!...Unicode.Scalar(0x2040)!)
      result.insert(charactersIn: "\u{2054}")
      result.insert(charactersIn: Unicode.Scalar(0x2060)!...Unicode.Scalar(0x206F)!)

      result.insert(charactersIn: Unicode.Scalar(0x2070)!...Unicode.Scalar(0x20CF)!)
      result.insert(charactersIn: Unicode.Scalar(0x2100)!...Unicode.Scalar(0x218F)!)
      result.insert(charactersIn: Unicode.Scalar(0x2460)!...Unicode.Scalar(0x24FF)!)
      result.insert(charactersIn: Unicode.Scalar(0x2776)!...Unicode.Scalar(0x2793)!)

      result.insert(charactersIn: Unicode.Scalar(0x2C00)!...Unicode.Scalar(0x2DFF)!)
      result.insert(charactersIn: Unicode.Scalar(0x2E80)!...Unicode.Scalar(0x2FFF)!)

      result.insert(charactersIn: Unicode.Scalar(0x3004)!...Unicode.Scalar(0x3007)!)
      result.insert(charactersIn: Unicode.Scalar(0x3021)!...Unicode.Scalar(0x302F)!)
      result.insert(charactersIn: Unicode.Scalar(0x3031)!...Unicode.Scalar(0x303F)!)
      result.insert(charactersIn: Unicode.Scalar(0x3040)!...Unicode.Scalar(0xD7FF)!)

      result.insert(charactersIn: Unicode.Scalar(0xF900)!...Unicode.Scalar(0xFD3D)!)
      result.insert(charactersIn: Unicode.Scalar(0xFD40)!...Unicode.Scalar(0xFDCF)!)
      result.insert(charactersIn: Unicode.Scalar(0xFDF0)!...Unicode.Scalar(0xFE1F)!)
      result.insert(charactersIn: Unicode.Scalar(0xFE30)!...Unicode.Scalar(0xFE44)!)

      result.insert(charactersIn: Unicode.Scalar(0xFE47)!...Unicode.Scalar(0xFFFD)!)

      result.insert(charactersIn: Unicode.Scalar(0x10000)!...Unicode.Scalar(0x1FFFD)!)
      result.insert(charactersIn: Unicode.Scalar(0x20000)!...Unicode.Scalar(0x2FFFD)!)
      result.insert(charactersIn: Unicode.Scalar(0x30000)!...Unicode.Scalar(0x3FFFD)!)
      result.insert(charactersIn: Unicode.Scalar(0x40000)!...Unicode.Scalar(0x4FFFD)!)

      result.insert(charactersIn: Unicode.Scalar(0x50000)!...Unicode.Scalar(0x5FFFD)!)
      result.insert(charactersIn: Unicode.Scalar(0x60000)!...Unicode.Scalar(0x6FFFD)!)
      result.insert(charactersIn: Unicode.Scalar(0x70000)!...Unicode.Scalar(0x7FFFD)!)
      result.insert(charactersIn: Unicode.Scalar(0x80000)!...Unicode.Scalar(0x8FFFD)!)

      result.insert(charactersIn: Unicode.Scalar(0x90000)!...Unicode.Scalar(0x9FFFD)!)
      result.insert(charactersIn: Unicode.Scalar(0xA0000)!...Unicode.Scalar(0xAFFFD)!)
      result.insert(charactersIn: Unicode.Scalar(0xB0000)!...Unicode.Scalar(0xBFFFD)!)
      result.insert(charactersIn: Unicode.Scalar(0xC0000)!...Unicode.Scalar(0xCFFFD)!)

      result.insert(charactersIn: Unicode.Scalar(0xD0000)!...Unicode.Scalar(0xDFFFD)!)
      result.insert(charactersIn: Unicode.Scalar(0xE0000)!...Unicode.Scalar(0xEFFFD)!)

      return result
    }()

    private static let allowedIdentifierCharacters: CharacterSet = {
      // From https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html#//apple_ref/doc/uid/TP40014097-CH30-ID412

      var result = CharacterSet(charactersIn: "0"..."9")

      result.insert(charactersIn: Unicode.Scalar(0x300)!...Unicode.Scalar(0x36F)!)
      result.insert(charactersIn: Unicode.Scalar(0x1DC0)!...Unicode.Scalar(0x1DFF)!)
      result.insert(charactersIn: Unicode.Scalar(0x20D0)!...Unicode.Scalar(0x20FF)!)
      result.insert(charactersIn: Unicode.Scalar(0xFE20)!...Unicode.Scalar(0xFE2F)!)

      result.formUnion(allowedIdentifierStarters)

      return result
    }()

    private static let casedLetters =
      CharacterSet.lowercaseLetters
      ∪ CharacterSet.uppercaseLetters  // Includes titlecase.

    // MARK: - Generating

    internal static func identifier(for string: StrictString, casing: Casing) -> StrictString {
      var identifier = string

      switch casing {
      case .variable:
        // Lowercase first word/acronym.
        if let match = identifier.firstMatch(
          for: RepetitionPattern(ConditionalPattern({ $0 ∉ CharacterSet.lowercaseLetters }))
        ),
          match.range.lowerBound == identifier.startIndex
        {

          identifier.replaceSubrange(
            match.range,
            with: String(StrictString(match.contents)).lowercased().scalars
          )
        }
      case .type:
        // Uppercase first letter.
        identifier.replaceSubrange(
          identifier.startIndex...identifier.startIndex,
          with: "\(identifier[identifier.startIndex])".uppercased().scalars
        )
      }

      // Replace disallowed characters.
      identifier.replaceMatches(
        for: ConditionalPattern({ $0 ∉ SwiftLanguage.allowedIdentifierCharacters }),
        with: "_".scalars
      )

      // Replace underscores with camel case where legible.
      var scalarArray = Array(identifier.scalars)
      var index = scalarArray.startIndex
      while index < scalarArray.endIndex {
        defer { index += 1 }

        if scalarArray[index] == "_" {

          let before = index − 1
          let after = index + 1

          if before ≥ scalarArray.startIndex,
            after < scalarArray.endIndex
          {

            let scalarBefore = scalarArray[before]
            let scalarAfter = scalarArray[after]

            if (scalarBefore ∈ SwiftLanguage.casedLetters ∨ scalarBefore == "_")
              ∨ (scalarAfter ∈ SwiftLanguage.casedLetters ∨ scalarBefore == "_")
            {
              // Would otherwise need separation for legibility.

              scalarArray.replaceSubrange(
                after...after,
                with: "\(scalarAfter)".uppercased().scalars
              )
              scalarArray.remove(at: index)
              index −= 1
            }
          }
        }
      }
      identifier = StrictString(scalarArray)

      // Trim trailing underscores.
      while identifier.last == "_" ∧ identifier.scalars.count > 1 {
        identifier.removeLast()
      }

      // Push disallowed starters away from start.
      if let first = identifier.first,
        first ∈ SwiftLanguage.allowedIdentifierCharacters,
        first ∉ SwiftLanguage.allowedIdentifierStarters
      {
        identifier.prepend("_")
      }

      return identifier
    }

    internal static func format(
      generatedCode code: inout String,
      accordingTo configuration: WorkspaceConfiguration,
      for fileURL: URL
    ) throws {
        if let formatConfiguration = configuration.proofreading.swiftFormatConfiguration {
          let formatter = SwiftFormatter(configuration: formatConfiguration)
          var result: String = ""
          try formatter.format(source: code, assumingFileURL: fileURL, to: &result)
          code = result
        }
    }
  }
#endif
