/*
 TupleTypeElementSyntax.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGSwiftSource
import WSGeneralImports

import SDGSwiftSource

extension TupleTypeElementSyntax : Parameter {
    var firstName: TokenSyntax? {
        if let name = self.name,
            ¬name.source().isEmpty {
            return name
        } else {
            // #workaround(SwiftSyntax 0.50000.0, Misidentified.)
            return inOut
        }
    }
    var optionalType: TypeSyntax? {
        return type
    }
}
