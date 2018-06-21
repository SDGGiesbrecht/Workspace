/*
 Product.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension PackageManifest {

    /// A product of a package.
    public struct Product : Codable {

        // MARK: - Initialization

        /// :nodoc:
        public init(name: String, type: ProductType, modules: [String]) {
            self.name = name
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
