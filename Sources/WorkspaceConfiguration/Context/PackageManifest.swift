/*
 PackageManifest.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections

// @localization(🇩🇪DE) @crossReference(PackageManifest)
/// Informationen aus der Paketenladeliste.
public typealias Paketenladeliste = PackageManifest
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(PackageManifest)
/// Information from the package manifest.
public struct PackageManifest: Codable {

  // MARK: - Initialization

  public init(_packageName: String, products: [Product]) {
    self.packageName = _packageName
    self.products = products
  }

  // MARK: - Properties

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(PackageManifest.packageName)
  /// The name of the package.
  public let packageName: String
  // @localization(🇩🇪DE) @crossReference(PackageManifest.packageName)
  /// Der Name des Pakets.
  public var paketenName: Zeichenkette {
    return packageName
  }

  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(PackageManifest.products)
  /// The products the package provides.
  public let products: [Product]
  // @localization(🇩🇪DE) @crossReference(PackageManifest.products)
  /// Die Produkte, die das Paket bereitstellt.
  public var produkte: [Produkt] {
    return products
  }

  // @localization(🇩🇪DE) @crossReference(PackageManifest.productModules)
  /// Die Liste von öffentliche Module.
  public var produktmodule: [Zeichenkette] {
    return productModules
  }
  // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(PackageManifest.productModules)
  /// The list of the publically accessible modules.
  public var productModules: [String] {
    var accountedFor: Set<String> = []
    var result: [String] = []
    for product in products {
      for module in product.modules where module ∉ accountedFor {
        accountedFor.insert(module)
        result.append(module)
      }
    }
    return result
  }
}
