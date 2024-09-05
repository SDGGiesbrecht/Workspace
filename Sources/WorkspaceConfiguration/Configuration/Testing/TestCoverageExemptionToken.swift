/*
 TestCoverageExemptionToken.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(TestCoverageExemptionToken)
/// Ein Testabdeckungsausnahmszeichen.
public typealias Testabdeckungsausnahmszeichen = TestCoverageExemptionToken
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(TestCoverageExemptionToken)
/// A test coverage exemption token.
public struct TestCoverageExemptionToken: Codable, Hashable {

  // MARK: - Initialization

  // @localization(🇩🇪DE) @crossReference(TestCoverageExemptionToken.init(_:scope:))
  /// Erstellt ein Testabdeckungsausnahmszeichen.
  ///
  /// - Parameters:
  ///     - zeichen: Die Zeichenkette des Zeichens.
  ///     - geltungsbereich: Der Geltungsbereich.
  public init(_ zeichen: StrengeZeichenkette, geltungsbereich: Geltungsbereich) {
    self.init(zeichen, scope: geltungsbereich)
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(TestCoverageExemptionToken.init(_:scope:))
  /// Creates a test coverage exemption token.
  ///
  /// - Parameters:
  ///     - token: The text of the token.
  ///     - scope: The scope of the token’s effect.
  public init(_ token: StrictString, scope: Scope) {
    self.token = token
    self.scope = scope
  }

  // MARK: - Properties

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(TestCoverageExemptionToken.token)
  /// The text of the token.
  public var token: StrictString
  // @localization(🇩🇪DE) @crossReference(TestCoverageExemptionToken.token)
  /// Die Zeichenkette des Zeichens.
  public var zeichen: StrengeZeichenkette {
    get { return token }
    set { token = newValue }
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
  // @crossReference(TestCoverageExemptionToken.scope)
  /// The scope.
  public var scope: Scope
  // @localization(🇩🇪DE) @crossReference(TestCoverageExemptionToken.scope)
  /// Der Geltungsbereich.
  public var geltungsbereich: Geltungsbereich {
    get { return scope }
    set { scope = newValue }
  }
}
