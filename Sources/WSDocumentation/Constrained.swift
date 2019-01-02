
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
