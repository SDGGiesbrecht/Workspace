/*
 Quotation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A quotation.
public struct Quotation : Codable {

    // MARK: - Initialization

    /// Creates a quotation.
    public init(original: String) {
        self.original = original
    }

    // MARK: - Properties

    /// The quotation in its original language.
    ///
    /// There is no default quotation.
    public var original: String

    /// Translations of the quotation.
    ///
    /// There are no default translations.
    public var translations: [LocalizationIdentifier: String] = [:]

    /// A link for the quotation.
    ///
    /// There is no default link.
    public var links: [LocalizationIdentifier: URL] = [:]

    /// The citation.
    ///
    /// There is no default citation.
    public var citations: [LocalizationIdentifier: String] = [:]
}
