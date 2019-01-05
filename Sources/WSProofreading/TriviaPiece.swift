/*
 TriviaPiece.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(SDGSwift 0.4.0, These belong in SDGSwiftSource.)

import SDGSwiftSource

internal enum TriviaPosition {
    case leading
    case trailing
}

extension TriviaPiece {

    // MARK: - Indices

    internal func lowerBound(in string: String, token: TokenSyntax, triviaPosition: TriviaPosition, index: Trivia.Index) -> String.ScalarView.Index {
        var result: String.ScalarView.Index
        let trivia: Trivia
        switch triviaPosition {
        case .leading:
            result = token.lowerTriviaBound(in: string)
            trivia = token.leadingTrivia
        case .trailing:
            result = token.upperTokenBound(in: string)
            trivia = token.trailingTrivia
        }
        for pieceIndex in trivia.indices where pieceIndex < index {
            let piece = trivia[pieceIndex]
            result = string.scalars.index(result, offsetBy: piece.text.scalars.count)
        }
        return result
    }

    private func upperBound(in string: String, lowerBound: String.ScalarView.Index) -> String.ScalarView.Index {
        return string.scalars.index(lowerBound, offsetBy: text.scalars.count)
    }
    internal func upperBound(in string: String, token: TokenSyntax, triviaPosition: TriviaPosition, index: Trivia.Index) -> String.ScalarView.Index { // @exempt(from: tests)
        let lowerBound = self.lowerBound(in: string, token: token, triviaPosition: triviaPosition, index: index)
        return upperBound(in: string, lowerBound: lowerBound)
    }

    internal func range(in string: String, token: TokenSyntax, triviaPosition: TriviaPosition, index: Trivia.Index) -> Range<String.ScalarView.Index> {
        let lowerBound = self.lowerBound(in: string, token: token, triviaPosition: triviaPosition, index: index)
        let upperBound = self.upperBound(in: string, lowerBound: lowerBound)
        return lowerBound ..< upperBound
    }
}
