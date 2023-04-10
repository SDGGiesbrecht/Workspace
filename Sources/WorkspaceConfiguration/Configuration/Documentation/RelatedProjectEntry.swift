/*
 RelatedProjectEntry.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(RelatedProjectEntry)
/// Ein Eintrag zur Liste der verwanten Projekten.
public typealias EintragZuVerwantdenProjekten = RelatedProjectEntry
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(RelatedProjectEntry)
/// An entry for the related projects list.
public enum RelatedProjectEntry: Decodable, Encodable {

  // MARK: - Cases

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(RelatedProjectEntry.project(url:))
  /// A related project with its repository URL.
  case project(url: URL)
  // @localization(🇩🇪DE) @crossReference(RelatedProjectEntry.project(url:))
  /// Ein verwandtes Projekt mit sein Lagerressourcenzeiger.
  ///
  /// - Parameters:
  ///     - ressourcenzeiger: Der Ressourcenzeiger.
  public static func projekt(
    ressourcenzeiger: EinheitlicherRessourcenzeiger
  ) -> EintragZuVerwantdenProjekten {
    return .project(url: ressourcenzeiger)
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(RelatedProjectEntry.heading(text:))
  /// A heading.
  case heading(text: [LocalizationIdentifier: StrictString])
  // @localization(🇩🇪DE) @crossReference(RelatedProjectEntry.heading(text:))
  /// Eine Überschrift.
  ///
  /// - Parameters:
  ///     - text: Der Text.
  public static func überschrift(
    text: [Lokalisationskennzeichen: StrengeZeichenkette]
  ) -> EintragZuVerwantdenProjekten {
    return .heading(text: text)
  }

  private enum RelatedProjectEntryType: String, Codable {
    case project
    case heading
  }

  // MARK: - Encoding

  private enum CodingKeys: CodingKey {
    case type
    case details
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .project(let url):
      try container.encode(RelatedProjectEntryType.project, forKey: CodingKeys.type)
      try container.encode(url, forKey: CodingKeys.details)
    case .heading(let text):
      try container.encode(RelatedProjectEntryType.heading, forKey: CodingKeys.type)
      try container.encode(text, forKey: CodingKeys.details)
    }
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let type = try container.decode(RelatedProjectEntryType.self, forKey: CodingKeys.type)
    switch type {
    case .project:
      self = .project(url: try container.decode(URL.self, forKey: CodingKeys.details))
    case .heading:
      self = .heading(
        text: try container.decode(
          [LocalizationIdentifier: StrictString].self,
          forKey: CodingKeys.details
        )
      )
    }
  }
}
