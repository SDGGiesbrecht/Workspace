/*
 String.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017–2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import WSGeneralImports

extension String {

    public var isWhitespace: Bool {
        return ¬scalars.contains(where: { $0 ∉ CharacterSet.whitespaces })
    }

    // MARK: - Line and Column numbers

    private func lineNumber(for index: String.ScalarView.Index) -> Int {
        return lines.distance(from: lines.startIndex, to: index.line(in: lines)) + 1
    }

    private func columnNumber(for index: String.ScalarView.Index) -> Int {
        let location = index.cluster(in: clusters)
        let line = lineRange(for: location ..< location)
        return distance(from: line.lowerBound, to: location) + 1
    }
}
