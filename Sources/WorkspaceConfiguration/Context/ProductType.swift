/*
 ProductType.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension PackageManifest.Product {

  // @localization(🇩🇪DE) @crossReference(ProductType)
  /// Eine Produktart.
  public typealias Produktart = ProductType
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(ProductType)
  /// A product type.
  public enum ProductType: String, Codable {

    // MARK: - Cases

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(ProductType.library)
    /// A library.
    case library
    // @localization(🇩🇪DE) @crossReference(ProductType.library)
    /// Eine Bibliotek.
    public static var bibliotek: Produktart {
      return .library
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(ProductType.executable)
    /// An executable.
    case executable
    // @localization(🇩🇪DE) @crossReference(ProductType.executable)
    /// Ein ausführbare Datei.
    public static var ausführbareDatei: Produktart {
      return .executable
    }
  }
}
