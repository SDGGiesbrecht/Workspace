import GeneralImports

extension APIDocumentationConfiguration {

    internal func resolvedCopyrightNotice(for package: PackageRepository) throws -> StrictString {
        return StrictString(copyrightNotice.resolve(try package.cachedConfiguration()))
    }
}
