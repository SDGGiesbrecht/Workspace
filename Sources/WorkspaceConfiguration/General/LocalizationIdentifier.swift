/*
 LocalizationIdentifier.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow
import WSLocalizations

/// A localization identifier; either an IETF language tag or a language icon.
public struct LocalizationIdentifier : Codable, ExpressibleByStringLiteral, Hashable, TransparentWrapper {

    // MARK: - Initialization

    /// Creates an identifier from a localization.
    ///
    /// - Parameters:
    ///     - localization: The localization.
    public init<L>(_ localization: L) where L : Localization {
        code = localization.code
    }

    /// Creates a localization identifier from an IETF language tag or a language icon.
    ///
    /// - Parameters:
    ///     - identifier: The IETF language tag or language icon.
    public init(_ identifier: String) {
        if let icon = ContentLocalization.icon(for: identifier),
            let fromIcon = ContentLocalization.code(for: icon) {
            code = fromIcon
        } else if let fromIcon = ContentLocalization.code(for: StrictString(identifier)) {
            code = fromIcon
        } else {
            code = identifier
        }
    }

    // MARK: - Properties

    /// The IETF language tag.
    public var code: String

    /// The language icon.
    public var icon: StrictString? {
        return ContentLocalization.icon(for: code)
    }

    public var _iconOrCode: StrictString {
        return icon ?? StrictString(code)
    }
    public var _directoryName: StrictString {
        return _iconOrCode
    }

    // MARK: - Conversion

    public var _reasonableMatch: ContentLocalization? {
        return ContentLocalization(reasonableMatchFor: code)
    }
    public var _bestMatch: ContentLocalization {
        return _reasonableMatch ?? ContentLocalization.fallbackLocalization
    }

    // MARK: - ExpressibleByStringLiteral

    public init(stringLiteral: String) {
        self.init(stringLiteral)
    }

    // MARK: - TransparentWrapper

    public var wrappedInstance: Any {
        if let content = _reasonableMatch {
            return content
        } else if let icon = ContentLocalization.icon(for: code) {
            return icon
        } else {
            return code
        }
    }
}
