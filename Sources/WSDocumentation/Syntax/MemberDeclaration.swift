/*
 MemberDeclaration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(SDGSwift 0.4.0, This belongs in SDGSwiftSource.)

import SDGLogic
import WSGeneralImports

import SDGSwiftSource

internal protocol MemberDeclaration : Syntax {
    var modifiers: ModifierListSyntax? { get }
}

extension MemberDeclaration {

    internal func isTypeMember() -> Bool {
        return modifiers?.contains(where: { $0.name.tokenKind == .staticKeyword ∨ $0.name.tokenKind == .classKeyword }) == true
    }
}
