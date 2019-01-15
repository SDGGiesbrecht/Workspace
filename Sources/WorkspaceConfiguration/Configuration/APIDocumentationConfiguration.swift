/*
 APIDocumentationConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to API documentation.
public struct APIDocumentationConfiguration : Codable {

    /// Whether or not to generate API documentation.
    ///
    /// This is off by default.
    ///
    /// ```shell
    /// $ workspace document
    /// ```
    ///
    /// Workspace will generate API documentation.
    ///
    /// By default, the generated documentation will be placed in a `docs` folder at the project root. [These GitHub settings](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/#publishing-your-github-pages-site-from-a-docs-folder-on-your-master-branch) can be adjusted to automatically host the documentation directly from the repository. (If you wish to avoid checking generated files into `master`, see `encryptedTravisCIDeploymentKey` for a more advanced method.)
    public var generate: Bool = false

    /// Whether or not to enforce documentation coverage.
    ///
    /// This is on by default.
    ///
    /// ```shell
    /// $ workspace validate documentation‐coverage
    /// ```
    public var enforceCoverage: Bool = true

    /// The year the documentation was first published.
    ///
    /// This will be used as the lower bound when generating copyright dates. (The upper bound will always be the present.)
    public var yearFirstPublished: GregorianYear?

    /// The copyright notice.
    ///
    /// By default, this is assembled from the file header copyright notice.
    ///
    /// Workspace will replace the dynamic element `#dates` with the computed copyright dates. (e.g. “©2016–2017”).
    public var copyrightNotice: Lazy<StrictString> = Lazy<StrictString>(resolve: { configuration in
        // #workaround(Should be localized.)
        return configuration.fileHeaders.copyrightNotice.resolve(configuration) + " All rights reserved."
    })

    /// An encrypted Travis CI deployment key.
    ///
    /// By specifying this, projects with continuous integration management active can avoid checking generated files into the main branch.
    ///
    /// With the following set‐up, Workspace will only generate documentation in continuous integration and stop generating it locally. (If needed for coverage checks, Workspace may still do so in a temporary directory.) The generated documentation will be automatically published to GitHub Pages via the gh&#x2D;pages branch, making the `docs` directory unnecessary.
    ///
    /// Requirements:
    ///
    /// 1. A GitHub [access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).
    /// 2. The Travis gem. `$ gem install travis`
    ///
    /// Set‐Up:
    ///
    /// 1. Navigate to a local clone of the repository. `$ cd some/path`.
    /// 2. Encrypt the access token: `$ travis encrypt "GITHUB_TOKEN=some‐token"`
    /// 3. Specify the encrypted access token for this option.
    /// 5. Set GitHub Pages to [serve from the gh&#x2D;pages branch](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/#enabling-github-pages-to-publish-your-site-from-master-or-gh-pages).
    ///
    /// - Important: Workspace does not understand Travis’ encryption, and does not attempt to read or use the key. All this option does is tell Workspace to (a) include the encrypted key when configuring Travis CI, and (b) keep generated documentation out of the repository.
    public var encryptedTravisCIDeploymentKey: String?
}
