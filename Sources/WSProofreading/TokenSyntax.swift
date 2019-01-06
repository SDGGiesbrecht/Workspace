/*
 TokenSyntax.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGMathematics

// #workaround(SDGSwift 0.4.0, These belong in SDGSwiftSource.)

import SDGSwiftSource

extension TokenSyntax {

    // MARK: - Indices

    private func index(in string: String, for position: AbsolutePosition) -> String.ScalarView.Index {
        let utf8 = string.utf8
        return utf8.index(utf8.startIndex, offsetBy: position.utf8Offset)
    }

    internal func lowerTokenBound(in string: String) -> String.ScalarView.Index {
        return index(in: string, for: positionAfterSkippingLeadingTrivia)
    }

    internal func upperTokenBound(in string: String) -> String.ScalarView.Index {
        return index(in: string, for: endPosition)
    }

    internal func tokenRange(in string: String) -> Range<String.ScalarView.Index> {
        return lowerTokenBound(in: string) ..< upperTokenBound(in: string)
    }

    internal func lowerTriviaBound(in string: String) -> String.ScalarView.Index {
        return index(in: string, for: position)
    }
}
