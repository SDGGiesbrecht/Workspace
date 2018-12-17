/*
 HTML.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText

internal enum HTML {

    private static func sharedEscape<S>(_ string: S) -> S where S : StringFamily {
        return S(string.scalars
            .replacingMatches(for: "&".scalars, with: "&#x0026;".scalars))
    }

    internal static func escape<S>(_ string: S) -> S where S : StringFamily {
        return S(sharedEscape(string).scalars
            .replacingMatches(for: "<".scalars, with: "&#x003C;".scalars)
            .replacingMatches(for: "\u{2066}".scalars, with: "<bdi dir=\u{22}ltr\u{22}>".scalars)
            .replacingMatches(for: "\u{2067}".scalars, with: "<bdi dir=\u{22}rtl\u{22}>".scalars)
            .replacingMatches(for: "\u{2068}".scalars, with: "<bdi dir=\u{22}auto\u{22}>".scalars)
            .replacingMatches(for: "\u{2069}".scalars, with: "</bdi>".scalars))
    }

    internal static func escapeAttribute<S>(_ string: S) -> S where S : StringFamily {
        return S(sharedEscape(string).scalars
            .replacingMatches(for: "\u{22}".scalars, with: "&#x0022;".scalars))
    }

    internal static func percentEncode<S>(_ string: S, withAllowedCharacters allowed: CharacterSet) -> S where S : StringFamily {
        let swiftString = String(String.ScalarView(string.scalars))
        let encoded = swiftString.addingPercentEncoding(withAllowedCharacters: allowed)!
        return S(S.ScalarView(encoded.scalars))
    }
}
