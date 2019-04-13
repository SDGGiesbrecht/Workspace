/*
 UnicodeRuleScope.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A scope of application for the `unicode` rule.
public enum UnicodeRuleScope : String, CaseIterable, Decodable, Encodable {

    /// Scopes which are usually human language, such as documentation and comments.
    case humanLanguage

    /// Scopes which are usually machine identifiers, such as variable and function names.
    case machineIdentifiers

    /// Scopes commonly used for both human language and machine identifiers, such as string literals.
    case ambiguous
}
