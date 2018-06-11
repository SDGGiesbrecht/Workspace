/*
 LocalizationIdentifier.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Localizations

/// A localization identifier; either an IETF language tag or a language icon.
public struct LocalizationIdentifier : Codable, Hashable {
    
    // MARK: - Initialization
    
    /// Creates an identifier from a localization.
    public init<L>(_ localization: L) where L : Localization {
        code = localization.code
    }
    
    /// Creates a localization identifier from an IETF language tag or a language icon.
    public init(_ identifier: String) {
        if let fromIcon = ContentLocalization(icon: StrictString(identifier)) {
            code = fromIcon.code
        } else {
            code = identifier
        }
    }
    
    // MARK: - Properties
    
    /// The IETF language tag.
    public var code: String
}
