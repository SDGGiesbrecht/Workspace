import GeneralImports

extension GitHubConfiguration {

    internal func resolvedContributingInstructions(for package: PackageRepository) throws -> StrictString {
        return StrictString(contributingInstructions.resolve(try package.cachedConfiguration()))
    }
}
