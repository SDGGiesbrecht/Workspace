/*
 SyntaxScanner.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGSwiftSource

internal class SyntaxScanner : SDGSwiftSource.SyntaxScanner {

    // MARK: - Initialization

    init(
        checkSyntax: @escaping (Syntax) -> Void = { _ in },
        checkExtendedSyntax: @escaping (ExtendedSyntax) -> Void = { _ in },
        checkTrivia: @escaping (Trivia) -> Void = { _ in },
        checkTriviaPiece: @escaping (TriviaPiece) -> Void = { _ in }) {

        self.checkSyntax = checkSyntax
        self.checkExtendedSyntax = checkExtendedSyntax
        self.checkTrivia = checkTrivia
        self.checkTriviaPiece = checkTriviaPiece
    }

    // MARK: - Properties

    private let checkSyntax: (Syntax) -> Void
    private let checkExtendedSyntax: (ExtendedSyntax) -> Void
    private let checkTrivia: (Trivia) -> Void
    private let checkTriviaPiece: (TriviaPiece) -> Void

    // MARK: - SyntaxScanner

    internal override func visit(_ node: Syntax) -> Bool {
        checkSyntax(node)
        return true
    }

    override func visit(_ node: ExtendedSyntax) -> Bool {
        checkExtendedSyntax(node)

        // #workaround(SDGSwift 0.4.0, Block comments broken into fragments can cause invalid index use.)
        if node is FragmentSyntax {
            return false
        }

        return true
    }

    override func visit(_ node: Trivia) -> Bool {
        checkTrivia(node)
        return true
    }

    override func visit(_ node: TriviaPiece) -> Bool {
        checkTriviaPiece(node)
        return true
    }
}
