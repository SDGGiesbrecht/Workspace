/*
 FileSyntax.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2017–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import Foundation

  import SDGLogic
  import SDGCollections
  import SDGLocalization

  internal struct FileSyntax {

    // MARK: - Initialization

    internal init(
      blockCommentSyntax: BlockCommentSyntax? = nil,
      lineCommentSyntax: LineCommentSyntax? = nil,
      requiredFirstLineToken: String? = nil,
      semanticLineTerminalWhitespace: [String] = []
    ) {
      self.blockCommentSyntax = blockCommentSyntax
      self.lineCommentSyntax = lineCommentSyntax
      self.requiredFirstLineToken = requiredFirstLineToken
      self.semanticLineTerminalWhitespace = semanticLineTerminalWhitespace
    }

    // MARK: - Properties

    private let requiredFirstLineToken: String?

    private let blockCommentSyntax: BlockCommentSyntax?
    internal let lineCommentSyntax: LineCommentSyntax?
    internal var hasComments: Bool {
      return blockCommentSyntax ≠ nil ∨ lineCommentSyntax ≠ nil
    }

    internal let semanticLineTerminalWhitespace: [String]

    // MARK: - Output

    private func comment(contents: String) -> String? {
      if let blockSyntax = blockCommentSyntax {
        return blockSyntax.comment(contents: contents)
      } else if let lineSyntax = lineCommentSyntax {
        return lineSyntax.comment(contents: contents)
      } else {  // @exempt(from: tests) Not currently reachable.
        return nil  // @exempt(from: tests)
      }
    }

    private func generateHeader(contents: String) -> String? {
      return comment(contents: contents)
    }

    internal func insert(header: String, into file: inout TextFile) {
      if let generated = generateHeader(contents: header) {

        var first = String(file.contents[..<file.headerStart])
        if ¬first.isEmpty {
          var firstLines = first.lines.map({ String($0.line) })
          while let last = firstLines.last, last.isWhitespace {
            firstLines.removeLast()
          }
          firstLines.append("")
          firstLines.append("")  // Header starts in this line.
          first = firstLines.joinedAsLines()
        }

        var body = String(file.contents.scalars[file.headerEnd...])
        while let firstCharacter = body.scalars.first,
          firstCharacter ∈ CharacterSet.whitespacesAndNewlines
        {
          body.scalars.removeFirst()
        }
        body =
          [
            "",  // Line at end of header
            "",
            "",  // Body starts in this line
          ].joinedAsLines() + body

        let contents = first + generated + body

        file.contents = contents
      }
    }

    // MARK: - Parsing

    internal func rangeOfFirstComment(
      in range: Range<String.ScalarView.Index>,
      of file: TextFile
    ) -> Range<String.ScalarView.Index>? {
      let possibleBlock = blockCommentSyntax?.firstComment(in: range, of: file.contents)?
        .contents.bounds
      let possibleLine = lineCommentSyntax?.rangeOfFirstComment(in: range, of: file.contents)

      if let block = possibleBlock {
        if let line = possibleLine {
          if block.lowerBound < line.lowerBound {
            return block
          } else {
            return line
          }
        } else {
          return block
        }
      } else {
        if let line = possibleLine {
          return line
        } else {
          return nil
        }
      }
    }

    internal func contentsOfFirstComment(
      in range: Range<String.ScalarView.Index>,
      of file: TextFile
    ) -> String? {
      if let block = blockCommentSyntax?.contentsOfFirstComment(in: range, of: file.contents) {
        return block
      } else if let line = lineCommentSyntax?.contentsOfFirstComment(in: range, of: file.contents) {
        return line
      }
      return nil  // @exempt(from: tests) Unreachable.
    }

    private static func advance(
      _ index: inout String.ScalarView.Index,
      pastLayoutSpacingIn string: String
    ) {
      string.scalars.advance(
        &index,
        over: RepetitionPattern(
          CharacterSet.newlinePattern(for: String.ScalarView.self),
          count: 0...1
        )
      )
      string.scalars.advance(
        &index,
        over: RepetitionPattern(
          ConditionalPattern<String.ScalarView>({ $0 ∈ CharacterSet.whitespaces })
        )
      )
      string.scalars.advance(
        &index,
        over: RepetitionPattern(
          CharacterSet.newlinePattern(for: String.ScalarView.self),
          count: 0...1
        )
      )
    }

    internal func headerStart(file: TextFile) -> String.ScalarView.Index {

      var index = file.contents.scalars.startIndex

      if let required = requiredFirstLineToken {

        if file.contents.scalars.hasPrefix(required.scalars),
          let endOfLine = file.contents.scalars.firstMatch(
            for: CharacterSet.newlinePattern(for: String.ScalarView.self)
          )?
          .range
        {
          index = endOfLine.lowerBound
        }
        FileSyntax.advance(&index, pastLayoutSpacingIn: file.contents)
      }
      return index
    }

    private func headerEndWithoutSpacing(file: TextFile) -> String.ScalarView.Index {

      let start = file.headerStart

      if let blockSyntax = blockCommentSyntax,
        blockSyntax.startOfNonDocumentationCommentExists(at: start, in: file.contents),
        let block = blockSyntax.firstComment(
          in: start..<file.contents.scalars.endIndex,
          of: file.contents
        )?.contents.bounds
          .upperBound
      {
        return block
      }

      if let lineSyntax = lineCommentSyntax,
        lineSyntax.nonDocumentationCommentExists(at: start, in: file.contents),
        let line = lineSyntax.rangeOfFirstComment(
          in: start..<file.contents.endIndex,
          of: file.contents
        )?.upperBound
      {
        return line
      }

      return start
    }

    internal func headerEnd(file: TextFile) -> String.ScalarView.Index {
      var result = headerEndWithoutSpacing(file: file)
      FileSyntax.advance(&result, pastLayoutSpacingIn: file.contents)
      return result
    }

    internal func header(file: TextFile) -> String {
      let markup = String(file.contents[file.headerStart..<file.headerEnd])

      if markup.lines.map({ String($0.line) }).filter({ ¬$0.isWhitespace }).isEmpty {
        return markup
      }

      if let blockSyntax = blockCommentSyntax {
        if let result = blockSyntax.contentsOfFirstComment(in: markup) {
          return result
        }
      }
      if let lineSyntax = lineCommentSyntax {
        if let result = lineSyntax.contentsOfFirstComment(in: markup) {
          return result
        }
      }
      unreachable()
    }
  }
#endif
