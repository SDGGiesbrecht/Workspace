import GeneralImports

extension FileHeaderConfiguration {

    internal func resolvedCopyrightNotice(for package: PackageRepository) throws -> StrictString {
        return StrictString(copyrightNotice.resolve(try package.configuration()))
    }
}
