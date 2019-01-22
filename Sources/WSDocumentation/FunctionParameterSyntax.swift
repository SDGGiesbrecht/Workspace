/*
 FunctionParameterSyntax.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

import SDGSwiftSource

extension FunctionParameterSyntax {

    internal var parameterName: String {
        if let result = secondName?.text,
            ¬result.isEmpty {
            return result
        } else if let result = firstName?.text,
            ¬result.isEmpty {
            return result
        } else { // @exempt(from: tests) One of the two should exist.
            return "" // @exempt(from: tests)
        }
    }
}
