import GeneralImports

extension GitHubConfiguration {

    internal func resolvedContributingInstructions(for package: PackageRepository) throws -> StrictString {
        return StrictString(contributingInstructions.resolve(try package.configuration()))
    }

    internal func resolvedIssueTemplate(for package: PackageRepository) throws -> StrictString {
        return StrictString(issueTemplate.resolve(try package.configuration()))
    }
}
