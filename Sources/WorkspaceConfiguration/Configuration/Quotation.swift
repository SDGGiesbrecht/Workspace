/*
 Quotation.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A quotation.
public struct Quotation : Codable {

    // MARK: - Initialization

    /// Creates a quotation.
    public init(original: StrictString) {
        self.original = original
    }

    // MARK: - Properties

    /// The quotation in its original language.
    ///
    /// There is no default quotation.
    public var original: StrictString

    /// Translations of the quotation.
    ///
    /// There are no default translations.
    public var translation: [LocalizationIdentifier: StrictString] = [:]

    /// The citation.
    ///
    /// There is no default citation.
    public var citation: [LocalizationIdentifier: StrictString] = [:]

    /// A link for the quotation.
    ///
    /// There is no default link.
    public var link: [LocalizationIdentifier: URL] = [:]

    // MARK: - Source

    internal func source(for localization: LocalizationIdentifier) -> Markdown {
        var result = [original]
        if let translated = translation[localization] {
            result += [translated]
        }
        if let url = link[localization] {
            let components: [StrictString] = ["[", result.joinedAsLines(), "](", StrictString(url.absoluteString), ")"]
            result = [components.joined()]
        }
        if let cited = citation[localization] {
            let indent = StrictString([String](repeating: "&nbsp;", count: 100).joined())
            result += [indent + "―" + StrictString(cited)]
        }

        return StrictString("> ") + StrictString(result.joined(separator: "\n".scalars)).replacingMatches(for: "\n".scalars, with: "<br>".scalars)
    }
}
