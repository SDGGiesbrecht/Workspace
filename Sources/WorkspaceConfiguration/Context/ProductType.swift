
extension PackageManifest.Product {

    /// A product type.
    public enum ProductType : String, Codable {

        // MARK: - Cases

        /// A library.
        case library

        /// An executable.
        case executable
    }

}
