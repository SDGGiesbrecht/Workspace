

/// Options related to API documentation.
public struct APIDocumentationConfiguration : Codable {

    /// Whether or not to generate API documentation.
    ///
    /// This is off by default.
    public var generate: Bool = false

    /// Whether or not to enforce documentation coverage.
    ///
    /// This is on by default.
    public var enforceCoverage: Bool = true

    /// The year the documentation was first published.
    public var yearFirstPublished: Int?

    /// The copyright notice.
    ///
    /// By default, this is assembled from the file header copyright notice.
    ///
    /// Workspace will replace the dynamic element `[_dates_]` with the file’s copyright dates. (e.g. “©2016–2017”).
    public var copyrightNotice: Lazy<String> = Lazy<String>() { configuration in
        return configuration.fileHeaders.copyrightNotice.resolve(configuration).appending(" All rights reserved.")
    }
}
