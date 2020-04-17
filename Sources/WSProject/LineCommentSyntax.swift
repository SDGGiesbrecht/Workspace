/*
 LineCommentSyntax.swift

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
import WSGeneralImports

public struct LineCommentSyntax {

  // MARK: - Initialization

  internal init(start: String) {
    self.start = start
  }

  // MARK: - Properties

  private let start: String

  // MARK: - Output

  public func comment(contents: String, indent: String = "") -> String {

    var first = true
    var result: [String] = []
    for line in contents.lines.map({ String($0.line) }) {
      var modified = start
      if ¬line.isWhitespace {
        modified += " " + line
      }

      if first {
        first = false
        result.append(modified)
      } else {
        result.append(indent + modified)
      }
    }

    return result.joinedAsLines()
  }

  // MARK: - Parsing

  // #workaround(Swift 5.2.2, Web lacks Foundation.)
  #if !os(WASI)
    internal func nonDocumentationCommentExists(
      at location: String.ScalarView.Index,
      in string: String
    ) -> Bool {

      var index = location
      if ¬string.clusters.advance(&index, over: start.clusters) {
        return false
      } else {
        // Comment

        // Make sure this isn’t documentation.
        if let nextCharacter = string[index...].unicodeScalars.first {

          if nextCharacter ∈ CharacterSet.whitespacesAndNewlines {
            return true
          }
        }
        return false
      }
    }

    private func restOfLine(
      at index: String.ScalarView.Index,
      in range: Range<String.ScalarView.Index>,
      of string: String
    ) -> Range<String.ScalarView.Index> {

      if let newline = string.scalars[(index..<range.upperBound).scalars(in: string.scalars)]
        .firstMatch(for: ConditionalPattern({ $0 ∈ CharacterSet.newlines }))?.range
      {

        return index..<newline.lowerBound
      } else {
        return index..<range.upperBound
      }
    }

    internal func rangeOfFirstComment(
      in range: Range<String.ScalarView.Index>,
      of string: String
    ) -> Range<String.ScalarView.Index>? {

      guard let startRange = string.scalars[range].firstMatch(for: start.scalars)?.range else {
        return nil
      }

      var resultEnd = restOfLine(at: startRange.lowerBound, in: range, of: string).upperBound
      var testIndex: String.ScalarView.Index = resultEnd
      string.scalars.advance(
        &testIndex,
        over: RepetitionPattern(CharacterSet.newlinePattern, count: 0...1)
      )

      string.scalars.advance(
        &testIndex,
        over: RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces }))
      )

      while string.scalars.suffix(from: testIndex).hasPrefix(start.scalars) {
        resultEnd = restOfLine(at: testIndex, in: range, of: string).upperBound
        testIndex = resultEnd
        string.scalars.advance(
          &testIndex,
          over: RepetitionPattern(CharacterSet.newlinePattern, count: 0...1)
        )

        string.scalars.advance(
          &testIndex,
          over: RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces }))
        )
      }

      return startRange.lowerBound..<resultEnd
    }

    internal func contentsOfFirstComment(
      in range: Range<String.ScalarView.Index>,
      of string: String
    ) -> String? {
      guard let range = rangeOfFirstComment(in: range, of: string) else {
        return nil  // @exempt(from: tests) Unreachable.
      }

      let comment = String(string[range])
      let lines = comment.lines.map({ String($0.line) }).map { (line: String) -> String in

        var index = line.scalars.startIndex

        line.scalars.advance(
          &index,
          over: RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.whitespaces }))
        )
        line.scalars.advance(&index, over: start.scalars)

        line.scalars.advance(
          &index,
          over: RepetitionPattern(
            ConditionalPattern({ $0 ∈ CharacterSet.whitespaces }),
            count: 0...1
          )
        )

        return String(line.scalars.suffix(from: index))
      }
      return lines.joinedAsLines()
    }

    internal func contentsOfFirstComment(in string: String) -> String? {
      return contentsOfFirstComment(in: string.startIndex..<string.endIndex, of: string)
    }
  #endif
}
