/*
 PackageRepository + Examples.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow
import SDGLogic
import SDGCollections
import SDGText
import SDGLocalization

import SDGCommandLine

import SDGSwift

import WorkspaceLocalizations

// #workaround(SDGCornerstone 6.1.0, Web API incomplete.)
#if !os(WASI)
  extension PackageRepository {

    private static var exampleDeclarationPattern:
      ConcatenatedPatterns<
        ConcatenatedPatterns<
          InterfaceLocalization.DirectivePatternWithArguments,
          RepetitionPattern<ConditionalPattern<Unicode.Scalar>>
        >,
        InterfaceLocalization.DirectivePattern
      >
    {

      return InterfaceLocalization.exampleDeclaration
        + RepetitionPattern(ConditionalPattern({ _ in true }), consumption: .lazy)
        + InterfaceLocalization.endExampleDeclaration
    }

    internal func examples(output: Command.Output) throws -> [StrictString: StrictString] {
      return try _withExampleCache {
        var list: [StrictString: StrictString] = [:]

        for url in try sourceFiles(output: output) {
          purgingAutoreleased {

            if FileType(url: url) ≠ nil,
              let file = try? TextFile(alreadyAt: url)
            {

              for match in file.contents.scalars.matches(
                for: PackageRepository.exampleDeclarationPattern
              ) {
                guard
                  let openingParenthesis = match.contents.firstMatch(
                    for: "(".scalars
                  ),
                  let closingParenthesis = match.contents.firstMatch(
                    for: ")".scalars
                  ),
                  let at = match.contents.lastMatch(for: "@".scalars)
                else {
                  unreachable()
                }

                var identifier = StrictString(
                  file.contents.scalars[
                    openingParenthesis.range.upperBound..<closingParenthesis.range.lowerBound
                  ]
                )
                identifier.trimMarginalWhitespace()

                var example = StrictString(
                  file.contents.scalars[
                    closingParenthesis.range.upperBound..<at.range.lowerBound
                  ]
                )
                // Remove token lines.
                example.lines.removeFirst()
                example.lines.removeLast()
                // Remove final newline.
                if let lastLine = example.lines.dropLast().last {
                  example.lines.removeLast(2)
                  example.lines.append(
                    Line(line: StrictString(lastLine.line), newline: "")
                  )
                }
                example = example.strippingCommonIndentation()

                list[identifier] = example
              }
            }
          }
        }

        return list
      }
    }

    internal func refreshExamples(output: Command.Output) throws {

      files: for url in try sourceFiles(output: output)
      where ¬url.path.hasSuffix("Sources/WorkspaceConfiguration/Documentation/Examples.swift") {

        try purgingAutoreleased {

          if let type = FileType(url: url),
            type ∈ Set([.swift, .swiftPackageManifest])
          {
            let documentationSyntax = FileType.swiftDocumentationSyntax
            let lineDocumentationSyntax = documentationSyntax.lineCommentSyntax!

            var file = try TextFile(alreadyAt: url)

            var searchIndex = file.contents.scalars.startIndex
            while let match = file.contents.scalars[
              min(searchIndex, file.contents.scalars.endIndex)..<file.contents.scalars.endIndex
            ]
            .firstMatch(for: InterfaceLocalization.exampleDirective) {
              searchIndex = match.range.upperBound

              let arguments = match.directiveArgument()
              guard let comma = arguments.firstMatch(for: ",".scalars) else {
                throw Command.Error(
                  description:
                    UserFacing<StrictString, InterfaceLocalization>({ localization in
                      switch localization {
                      case .englishUnitedKingdom, .englishUnitedStates,
                        .englishCanada:
                        return
                          "An example directive has too few arguments:\n\(match.contents)"
                      case .deutschDeutschland:
                        return
                          "Eine Beispielsanweisung hat zu wenig Argumente:\n\(match.contents)"
                      }
                    })
                )
              }

              var indexString = StrictString(arguments[..<comma.range.lowerBound])
              indexString.trimMarginalWhitespace()

              var identifier = StrictString(arguments[comma.range.upperBound...])
              identifier.trimMarginalWhitespace()

              let index = try Int.parse(possibleDecimal: indexString).get()
              guard let example = try examples(output: output)[identifier] else {
                throw Command.Error(
                  description:
                    UserFacing<StrictString, InterfaceLocalization>({ localization in
                      switch localization {
                      case .englishUnitedKingdom:
                        return "There is no example named ‘" + identifier + "’."
                      case .englishUnitedStates, .englishCanada:
                        return "There is no example named “" + identifier + "”."
                      case .deutschDeutschland:
                        return "Es gibt kein Beispiel Namens „" + identifier + "“."
                      }
                    })
                )
              }

              let nextLineStart = match.range.lines(in: file.contents.lines).upperBound
                .samePosition(in: file.contents.scalars)
              if let commentRange = documentationSyntax.rangeOfFirstComment(
                in: nextLineStart..<file.contents.scalars.endIndex,
                of: file
              ) {
                let commentIndent = String(
                  file.contents.scalars[nextLineStart..<commentRange.lowerBound]
                )

                if var commentValue = documentationSyntax.contentsOfFirstComment(
                  in: commentRange,
                  of: file
                ) {

                  var countingExampleIndex = 0
                  var searchIndex = commentValue.scalars.startIndex
                  exampleSearch: while let startRange = commentValue.scalars[
                    searchIndex..<commentValue.scalars.endIndex
                  ].firstMatch(
                    for: "```".scalars
                  )?.range,
                    let endRange = commentValue.scalars[
                      startRange.upperBound..<commentValue.scalars.endIndex
                    ]
                    .firstMatch(for: "```".scalars)?.range
                  {

                    let exampleRange = startRange.lowerBound..<endRange.upperBound

                    searchIndex = exampleRange.upperBound
                    countingExampleIndex.increment()
                    if countingExampleIndex < index {
                      continue exampleSearch
                    } else if countingExampleIndex == index {

                      let lineStart = exampleRange.lowerBound.line(
                        in: commentValue.lines
                      ).samePosition(
                        in: commentValue.scalars
                      )
                      let indentCount = commentValue.scalars.distance(
                        from: lineStart,
                        to: exampleRange.lowerBound
                      )
                      let exampleIndent = StrictString(
                        Array(repeating: " ", count: indentCount)
                      )

                      var exampleLines = [
                        "```swift",
                        example,
                        "```",
                      ].joinedAsLines().lines.map({ StrictString($0.line) })

                      for index in exampleLines.startIndex..<exampleLines.endIndex
                      where index ≠ exampleLines.startIndex {
                        exampleLines[index] =
                          exampleIndent
                          + exampleLines[index]
                      }

                      commentValue.scalars.replaceSubrange(
                        exampleRange,
                        with: exampleLines.joinedAsLines()
                      )

                      let replacementComment = lineDocumentationSyntax.comment(
                        contents: commentValue,
                        indent: commentIndent
                      )
                      file.contents.scalars.replaceSubrange(
                        commentRange,
                        with: replacementComment.scalars
                      )

                      break exampleSearch
                    }
                  }
                }
              }
            }

            try file.writeChanges(for: self, output: output)
          }
        }
      }
    }
  }
#endif
