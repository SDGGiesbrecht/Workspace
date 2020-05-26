/*
 String.swift

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

extension StringFamily {

  // #workaround(Swift 5.2.4, Web lacks Foundation.)
  #if !os(WASI)
    public var isWhitespace: Bool {
      return ¬scalars.contains(where: { $0 ∉ CharacterSet.whitespaces })
    }
  #endif

  public mutating func trimMarginalWhitespace() {
    while scalars.first == " " {
      scalars.removeFirst()
    }
    while scalars.last == " " {
      scalars.removeLast()
    }
  }

  public func strippingCommonIndentation() -> Self {
    var smallestIndent = Int.max
    let lines = self.lines.map { $0.line }
    for line in lines {
      if let firstCharacter = line.firstMatch(for: ConditionalPattern({ $0 ≠ " " }))?.range
        .lowerBound
      {
        smallestIndent.decrease(
          to: line.distance(from: line.startIndex, to: firstCharacter)
        )
      }
    }
    let stripped: [Self] = lines.map { line in
      if line.count < smallestIndent {
        // Empty line.
        return ""
      } else {
        return Self(Self.ScalarView(line.dropFirst(smallestIndent)))
      }
    }
    return stripped.joinedAsLines()
  }
}
