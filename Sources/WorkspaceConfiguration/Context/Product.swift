/*
 Product.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2023 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2023 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension PackageManifest {

  // @localization(🇩🇪DE) @crossReference(Product)
  /// Ein Produkt eines Pakets.
  public typealias Produkt = Product
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Product)
  /// A product of a package.
  public struct Product: Codable {

    // MARK: - Initialization

    public init(_name: String, type: ProductType, modules: [String]) {
      self.name = _name
      self.type = type
      self.modules = modules
    }

    // MARK: - Properties

    // @localization(🇩🇪DE)
    /// Der Name des Produkts.
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    /// The name of the product.
    public let name: String

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Product.type)
    /// The type of product.
    public let type: ProductType
    // @localization(🇩🇪DE) @crossReference(Product.type)
    /// Die Art des Produkts.
    public var art: Produktart {
      return type
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(Product.modules)
    /// The modules the product provides.
    public let modules: [String]
    // @localization(🇩🇪DE) @crossReference(Product.modules)
    /// Die Module, die das Produkt bereitstellt.
    public var module: [Zeichenkette] {
      return modules
    }
  }
}
