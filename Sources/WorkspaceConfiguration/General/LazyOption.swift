/*
 LazyOption.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(Lazy<Option>)
/// Eine Einstellung, die bequem ausgewertet werden kann.
///
/// Es kann sich von anderen Optionen herleiten, die geändert werden können bevor diese Einstellung ausgewertet wird.
public typealias BequemeEinstellung = Lazy
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Lazy<Option>)
/// An option which can be resolved lazily.
///
/// It can be derived from the state of other options, which can be modified before this option’s value is resolved.
public struct Lazy<Option>: Decodable, Encodable where Option: Codable {

  // MARK: - Initialization

  // @localization(🇩🇪DE) @crossReference(Lazy<Option>.init(resolve:))
  /// Erstellt eine bequeme Einstellung mit einem Auswertungsalgorithmus.
  ///
  /// - Parameters:
  ///     - auswerten: Ein Abschluss, der die Einstellung auswertet.
  ///     - konfiguration: Die Konfiguration, aus der die Ergebnis hergeleitet werden soll.
  public init(auswerten: @escaping (_ konfiguration: ArbeitsbereichKonfiguration) -> Option) {
    self.init(resolve: auswerten)
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Lazy<Option>.init(resolve:))
  /// Creates a lazy option with a resolution algorithm.
  ///
  /// - Parameters:
  ///     - resolve: An closure which resolves the option.
  ///     - configuration: The configuration from which to derive the result.
  public init(resolve: @escaping (_ configuration: WorkspaceConfiguration) -> Option) {
    self.resolve = resolve
  }

  // MARK: - Properties

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(resolve)
  /// The algorithm for resolving the value.
  ///
  /// - Parameters:
  ///     - configuration: The configuration based on which to resolve the option.
  public var resolve: (_ configuration: WorkspaceConfiguration) -> Option
  // @localization(🇩🇪DE) @crossReference(resolve)
  /// Der Algorithmus, der den Wert auswertet.
  ///
  /// - Parameters:
  ///     - konfiguration: Die Konfiguration, aus der die Ergebnis hergeleitet werden soll.
  public var auswerten: (_ konfiguration: ArbeitsbereichKonfiguration) -> Option {
    get { return resolve }
    set { resolve = newValue }
  }

  // MARK: - Encoding

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(resolve(WorkspaceConfiguration.registered))
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let resolved = try container.decode(Option.self)
    resolve = { _ in resolved }
  }
}
