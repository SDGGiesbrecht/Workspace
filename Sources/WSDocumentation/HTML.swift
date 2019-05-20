/*
 HTML.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import SDGText

internal enum WSHTML {

    private static func sharedEscape<S>(_ string: S) -> S where S : StringFamily {
        return S(string.scalars
            .replacingMatches(for: "&".scalars, with: "&#x0026;".scalars))
    }

    internal static func escapeAttribute<S>(_ string: S) -> S where S : StringFamily {
        return S(sharedEscape(string).scalars
            .replacingMatches(for: "\u{22}".scalars, with: "&#x0022;".scalars))
    }

    internal static func percentEncodeURLPath<S>(_ string: S) -> S where S : StringFamily {
        var result = string
        result.scalars.mutateMatches(
            for: ConditionalPattern({ $0.value < 0x80 ∧ $0 ∉ CharacterSet.urlPathAllowed }),
            mutation: { return ("%" + String($0.contents.first!.value, radix: 16)).scalars })
        return result
    }
}
