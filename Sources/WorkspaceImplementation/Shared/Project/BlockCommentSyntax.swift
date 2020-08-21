/*
 BlockCommentSyntax.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections

internal struct BlockCommentSyntax {

  // MARK: - Initialization

  internal init(start: String, end: String) {
    self.start = start
    self.end = end
  }

  // MARK: - Properties

  private let start: String
  private let end: String

  // MARK: - Output

  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    internal func comment(contents: String) -> String {

      let withEndToken = [contents, end].joinedAsLines()

      var lines = withEndToken.lines.map({ String($0.line) })

      lines = lines.map { (line: String) -> String in

        if line.isWhitespace {
          return line
        } else {
          return " " + line
        }
      }

      lines = [start, lines.joinedAsLines()]

      return lines.joinedAsLines()
    }

    // MARK: - Parsing

    internal func startOfNonDocumentationCommentExists(
      at location: String.ScalarView.Index,
      in string: String
    ) -> Bool {

      var index = location
      if ¬string.scalars.advance(&index, over: start.scalars) {
        return false
      } else {

        // Make sure this isn’t documentation.
        if let nextCharacter = string.scalars[index...].first {

          if nextCharacter ∈ CharacterSet.whitespacesAndNewlines {
            return true
          }
        }
        return false
      }
    }
  #endif

  internal func firstComment(in range: Range<String.ScalarView.Index>, of string: String)
    -> NestingLevel<String.ScalarView>?
  {
    return string.scalars.firstNestingLevel(
      startingWith: start.scalars,
      endingWith: end.scalars
    )
  }

  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    internal func contentsOfFirstComment(
      in range: Range<String.ScalarView.Index>,
      of string: String
    ) -> String? {
      guard let range = firstComment(in: range, of: string)?.contents.range else {
        return nil
      }

      var lines = String(string[range]).lines.map({ String($0.line) })
      while let line = lines.first, line.isWhitespace {
        lines.removeFirst()
      }

      guard let first = lines.first else {
        return ""
      }
      lines.removeFirst()

      var index = first.scalars.startIndex
      first.scalars.advance(
        &index,
        over: RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces }))
      )
      let indent = first.scalars.distance(from: first.scalars.startIndex, to: index)

      var result = [first.scalars.suffix(from: index)]
      for line in lines {
        var indentIndex = line.scalars.startIndex
        line.scalars.advance(
          &indentIndex,
          over: RepetitionPattern(
            ConditionalPattern({ $0 ∈ CharacterSet.whitespaces }),
            count: 0...indent
          )
        )
        result.append(line.scalars.suffix(from: indentIndex))
      }

      var strings = result.map({ String($0) })
      while let last = strings.last, last.isWhitespace {
        strings.removeLast()
      }

      return strings.joinedAsLines()
    }

    internal func contentsOfFirstComment(in string: String) -> String? {
      return contentsOfFirstComment(
        in: string.scalars.startIndex..<string.scalars.endIndex,
        of: string
      )
    }
  #endif
}
