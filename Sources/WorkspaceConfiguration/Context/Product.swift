/*
 Product.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension PackageManifest {

    /// A product of a package.
    public struct Product : Codable {

        // MARK: - Initialization

        public init(_name: String, type: ProductType, modules: [String]) {
            self.name = _name
            self.type = type
            self.modules = modules
        }

        // MARK: - Properties

        /// The name of the product.
        public let name: String

        /// The type of product.
        public let type: ProductType

        /// The modules the product provides.
        public let modules: [String]
    }
}
