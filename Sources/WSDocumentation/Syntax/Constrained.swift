/*
 Constrained.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(SDGSwift 0.4.0, This functionality should be provided by SDGSwift.)

import WSGeneralImports

import SDGSwiftSource

internal protocol Constrained : Syntax {
    func withGenericWhereClause(_ newChild: GenericWhereClauseSyntax?) -> Self
}

extension StructDeclSyntax : Constrained {}
extension ClassDeclSyntax : Constrained {}
extension EnumDeclSyntax : Constrained {}
extension TypealiasDeclSyntax : Constrained {}
extension AssociatedtypeDeclSyntax : Constrained {}

extension ProtocolDeclSyntax : Constrained {}

extension ExtensionDeclSyntax : Constrained {}

extension InitializerDeclSyntax : Constrained {}
extension SubscriptDeclSyntax : Constrained {}
extension FunctionDeclSyntax : Constrained {}
