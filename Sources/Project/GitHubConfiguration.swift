import GeneralImports

extension GitHubConfiguration {

    internal func resolvedContributingInstructions(for package: PackageRepository) throws -> StrictString {
        return StrictString(contributingInstructions.resolve(try package.cachedConfiguration()))
    }

    internal func resolvedIssueTemplate(for package: PackageRepository) throws -> StrictString {
        return StrictString(issueTemplate.resolve(try package.cachedConfiguration()))
    }
}
