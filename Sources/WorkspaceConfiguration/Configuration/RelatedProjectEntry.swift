/*
 RelatedProjectEntry.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// An entry for the related projects list.
public enum RelatedProjectEntry : Codable {

    // MARK: - Cases

    /// A related project with its repository URL.
    case project(url: URL)

    /// A heading.
    case heading(text: [LocalizationIdentifier: StrictString])

    private enum RelatedProjectEntryType : String, Codable {
        case project
        case heading
    }

    // MARK: - Encoding

    private enum CodingKeys : CodingKey {
        case type
        case details
    }

    // @workaround(Until automatic inheritance can bridge module boundaries.)
    /// Encodes the entry.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .project(url: let url):
            try container.encode(RelatedProjectEntryType.project, forKey: CodingKeys.type)
            try container.encode(url, forKey: CodingKeys.details)
        case .heading(text: let text):
            try container.encode(RelatedProjectEntryType.heading, forKey: CodingKeys.type)
            try container.encode(text, forKey: CodingKeys.details)
        }
    }

    // @workaround(Until automatic inheritance can bridge module boundaries.)
    /// Decodes an entry.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(RelatedProjectEntryType.self, forKey: CodingKeys.type)
        switch type {
        case .project:
            self = .project(url: try container.decode(URL.self, forKey: CodingKeys.details))
        case .heading:
            self = .heading(text: try container.decode([LocalizationIdentifier: StrictString].self, forKey: CodingKeys.details))
        }
    }
}
