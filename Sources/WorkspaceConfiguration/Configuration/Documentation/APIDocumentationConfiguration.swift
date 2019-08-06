/*
 APIDocumentationConfiguration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections

/// Options related to API documentation.
public struct APIDocumentationConfiguration : Codable {

    /// Whether or not to generate API documentation.
    ///
    /// This is off by default.
    ///
    /// ```shell
    /// $ workspace document
    /// ```
    public var generate: Bool = false

    /// Whether or not to enforce documentation coverage.
    ///
    /// This is on by default.
    ///
    /// ```shell
    /// $ workspace validate documentation‐coverage
    /// ```
    public var enforceCoverage: Bool = true

    #warning("jahrErsterVeröffentlichung")
    /// The year the documentation was first published.
    ///
    /// This will be used as the lower bound when generating copyright dates. (The upper bound will always be the present.)
    public var yearFirstPublished: GregorianYear?

    /// The copyright notice.
    ///
    /// By default, this is assembled from the file header copyright notice.
    ///
    /// Workspace will replace the dynamic element `#dates` with the computed copyright dates. (e.g. “©2016–2017”).
    public var copyrightNotice: Lazy<[LocalizationIdentifier: StrictString]> = Lazy<[LocalizationIdentifier: StrictString]>(resolve: { configuration in
        return configuration.fileHeaders.copyrightNotice.resolve(configuration).mapKeyValuePairs { localization, notice in
            if let provided = localization._reasonableMatch {
                switch provided {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return (localization, notice + " All rights reserved.")
                case .deutschDeutschland:
                    return (localization, notice + " Alle rechte vorbehalten.")
                }
            } else {
                return (localization, notice)
            }
        }
    })

    #warning("verschlüsselterTravisCIVerteilungsSchlüssel")
    /// An encrypted Travis CI deployment key.
    ///
    /// By specifying this, projects with continuous integration management active can avoid checking generated files into the main branch.
    ///
    /// With the following set‐up, Workspace will only generate documentation in continuous integration and stop generating it locally. (If needed for coverage checks, Workspace may still do so in a temporary directory.) The generated documentation will be automatically published to GitHub Pages via the “gh&#x2D;pages” branch, making the `docs` directory unnecessary.
    ///
    /// Requirements:
    ///
    /// 1. A GitHub [access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).
    /// 2. The Travis gem. `$ gem install travis`
    ///
    /// Set‐Up:
    ///
    /// 1. Navigate to a local clone of the repository:
    ///     ```shell
    ///     $ cd some/path
    ///     ```
    /// 2. Encrypt the access token:
    ///     ```shell
    ///     $ travis encrypt "GITHUB_TOKEN=some‐token"
    ///     ```
    /// 3. Specify the encrypted access token for this option.
    /// 5. Set GitHub Pages to [serve from the “gh&#x2D;pages” branch](https://help.github.com/articles/configuring-a-publishing-source-for-github-pages/#enabling-github-pages-to-publish-your-site-from-master-or-gh-pages).
    ///
    /// - Workspace does not understand Travis’ encryption, and does not attempt to read or use the key. All this option does is tell Workspace to (a) include the encrypted key when configuring Travis CI, and (b) keep generated documentation out of the repository.
    public var encryptedTravisCIDeploymentKey: String?

    /// Dependency module names known to be irrelevant to documentation.
    ///
    /// Parsing can be sped up by specifing dependencies to skip, but if a dependency is skipped, its API will not be available to participate in inheritance resolution.
    public var ignoredDependencies: Set<String> = []
}
