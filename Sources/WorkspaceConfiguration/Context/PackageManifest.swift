/*
 PackageManifest.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections

/// Information from the package manifest.
public struct PackageManifest : Codable {

    // MARK: - Initialization

    public init(_packageName: String, products: [Product]) {
        self.packageName = _packageName
        self.products = products
    }

    // MARK: - Properties

    /// The name of the package.
    public let packageName: String

    /// The products the package provides.
    public let products: [Product]

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
