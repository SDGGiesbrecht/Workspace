/*
 PatternMatch.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import SDGText
import SDGLocalization

extension PatternMatch
where Searched: SearchableBidirectionalCollection, Searched.Element == Unicode.Scalar {

  internal func declarationArgument() -> StrictString {
    guard let openingParenthesis = contents.firstMatch(for: "(".scalars),
      let closingParenthesis = contents.lastMatch(for: ")".scalars)
    else {
      unreachable()
    }

    var argument = StrictString(
      contents[openingParenthesis.range.upperBound..<closingParenthesis.range.lowerBound]
    )
    argument.trimMarginalWhitespace()

    return argument
  }

  internal func directiveArgument() -> StrictString {
    return declarationArgument()
  }
}
