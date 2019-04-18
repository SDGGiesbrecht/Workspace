/*
 Workspace.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceConfiguration

public enum Metadata {

    public static let latestStableVersion = Version(0, 19, 0)
    public static let thisVersion: Version? = nil // Set this to latestStableWorkspaceVersion for release commits, nil the rest of the time.

    public static let packageURL = URL(string: "https://github.com/SDGGiesbrecht/Workspace")!
    public static let issuesURL = packageURL.appendingPathComponent("issues")
}

public let configuration: WorkspaceConfiguration = {
    let configuration = WorkspaceConfiguration()
    configuration._applySDGDefaults()

    configuration.supportedOperatingSystems.remove(.iOS)
    configuration.supportedOperatingSystems.remove(.watchOS)
    configuration.supportedOperatingSystems.remove(.tvOS)

    configuration.documentation.currentVersion = Metadata.latestStableVersion
    configuration.documentation.projectWebsite = URL(string: "https://github.com/SDGGiesbrecht/Workspace#workspace")!
    configuration.documentation.documentationURL = URL(string: "https://sdggiesbrecht.github.io/Workspace")!
    configuration.documentation.repositoryURL = Metadata.packageURL

    configuration.documentation.api.yearFirstPublished = 2017

    configuration.documentation.localizations = ["🇨🇦EN"]

    configuration.documentation.readMe.shortProjectDescription["🇨🇦EN"] = "Workspace automates management of Swift projects."

    configuration.documentation.readMe.quotation = Quotation(original: "Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.")
    configuration.documentation.readMe.quotation?.translation["🇨🇦EN"] = "Whatever you do, work from the heart, as working for the Lord and not for men."

    configuration.documentation.readMe.quotation?.citation["🇨🇦EN"] = "‎שאול/Shaʼul"

    configuration.documentation.readMe.quotation?.link["🇨🇦EN"] = URL(string: "https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIV")!

    configuration.documentation.readMe.featureList["🇨🇦EN"] = [
        "\u{2D} Provides rigorous validation:",
        "  \u{2D} [Test coverage](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/TestingConfiguration/Properties/enforceCoverage.html)",
        "  \u{2D} [Compiler warnings](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/TestingConfiguration/Properties/prohibitCompilerWarnings.html)",
        "  \u{2D} [Documentation coverage](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/APIDocumentationConfiguration/Properties/enforceCoverage.html)",
        "  \u{2D} [Example validation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/Examples.html)",
        "  \u{2D} [Style proofreading](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ProofreadingConfiguration.html)",
        "  \u{2D} [Reminders](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ProofreadingRule/Cases/manualWarnings.html)",
        "  \u{2D} [Continuous integration set‐up](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ContinuousIntegrationConfiguration/Properties/manage.html) ([Travis CI](https://travis\u{2D}ci.org) with help from [Swift Version Manager](https://github.com/kylef/swiftenv))",
        "\u{2D} Generates API [documentation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/APIDocumentationConfiguration/Properties/generate.html).",
        "\u{2D} Automates code maintenance:",
        "  \u{2D} [Embedded resources](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/PackageResources.html)",
        "  \u{2D} [Inherited documentation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/DocumentationInheritance.html)",
        "  \u{2D} [Xcode project generation](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/XcodeConfiguration/Properties/manage.html)",
        "\u{2D} Automates open source details:",
        "  \u{2D} [File headers](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/FileHeaderConfiguration.html)",
        "  \u{2D} [Read‐me files](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/ReadMeConfiguration.html)",
        "  \u{2D} [Licence notices](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/LicenceConfiguration.html)",
        "  \u{2D} [Contributing instructions](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/GitHubConfiguration.html)",
        "\u{2D} Designed to interoperate with the [Swift Package Manager](https://swift.org/package\u{2D}manager/).",
        "\u{2D} Manages projects for macOS, Linux, iOS, watchOS and tvOS.",
        "\u{2D} [Configurable](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Libraries/WorkspaceConfiguration.html)"
    ].joinedAsLines()

    configuration.documentation.readMe.other["🇨🇦EN"] = [
        "## The Workspace Workflow",
        "",
        "(The following sample package is a real repository. You can use it to follow along.)",
        "",
        "### When the Repository Is Cloned",
        "",
        "The need to hunt down workflow tools can deter contributors. On the other hand, including them in the repository causes a lot of clutter. To reduce both, when a project using Workspace is pulled, pushed, or cloned...",
        "",
        "```shell",
        "git clone https://github.com/SDGGiesbrecht/SamplePackage",
        "```",
        "",
        "...only one small piece of Workspace comes with it: A short script called “Refresh” that comes in two variants, one for each operating system.",
        "",
        "*Hmm... I wish I had more tools at my disposal... Hey! What if I...*",
        "",
        "### Refresh the Project",
        "",
        "To refresh the project, double‐click the `Refresh` script for the corresponding operating system. (If you are on Linux and double‐clicking fails or opens a text file, see [here](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Types/Linux.html).)",
        "",
        "`Refresh` opens a terminal window, and in it Workspace reports its actions while it sets the project folder up for development. (This may take a while the first time, but subsequent runs are faster.)",
        "",
        "*This looks better. Let’s get coding!*",
        "",
        "*[Add this... Remove that... Change something over here...]*",
        "",
        "*...All done. I wonder if I broke anything while I was working? Hey! It looks like I can...*",
        "",
        "### Validate Changes",
        "",
        "When the project seems ready for a push, merge, or pull request, validate the current state of the project by double‐clicking the `Validate` script.",
        "",
        "`Validate` opens a terminal window and in it Workspace runs the project through a series of checks.",
        "",
        "When it finishes, it prints a summary of which tests passed and which tests failed.",
        "",
        "*Oops! I never realized that would happen...*",
        "",
        "### Summary",
        "",
        "1. `Refresh` before working.",
        "2. `Validate` when it looks complete.",
        "",
        "*Wow! That was so much easier than doing it all manually!*",
        "",
        "## Applying Workspace to a Project",
        "",
        "To apply Workspace to a project, run the following command in the root of the project’s repository. (This requires a full install.)",
        "",
        "```shell",
        "$ workspace refresh",
        "```",
        "",
        "By default, Workspace refrains from tasks which would involve modifying project files. Such tasks must be activated with a [configuration](https://sdggiesbrecht.github.io/Workspace/🇨🇦EN/Libraries/WorkspaceConfiguration.html) file."
        ].joinedAsLines()

    configuration.repository.ignoredPaths.insert("Tests/Mock Projects")

    configuration.documentation.api.encryptedTravisCIDeploymentKey = "WfBLnstfcBi0Z8yioAfvEnoK/R59u+fLag3vBulzdePBF60jRQbT4qCr1wCuBsp1JHWJlJSM/GmVsqFEJgt1hJOL4lfx2proY6XUBNdn3BElPkDBgG2eIbPFHkdCtDLGSVqzNhUca6MKWJ4qZCujLKMSfvb+OBylzdhhVd+j5l/Icza0shRpAWDaSWiio3RkvxD08lFm9Fvlg4d09uRKzGPhlg1PjUP7bbl9xcoEqh/4ZzL2GTXGbHfJJOkQQXoPTbF0R8LiYVJVA5euFfHQw1rFepHhfSdhililvC0ld/ksSpQRLwCY93Sb9wOMRrc6HASApRALi9M3TGOQQrEI/Kjh4lJ+Okjg7wZnKixAuGPMUH0DWy57t+gSy51PyFi0bHfJzGm3Y5t8gtimsIiiWbWlNyZF3EndFmtQRfzLjfdJwHx34Zj44kX+rr7p29hkTlfv9YUuOP6CizVQnDfAoWPyv6lsD/PSYTdw97yWBoNXNVbKp8Ge4MmgtpYuWdOaZj0Lim0WZ/04A0clXW7wj/G+MJCbeRiFxKyVi6OUdhRy+BkVVqdNul892/vKyeLwJp9d6DtDkwy11TaxLeGpu0eBWUEhfQJIUG/EaE5FD1v6GsZpmy8FF+XVKeOPDI+kHuHQ6hUjXnOM8HGr0HGpbiQ9Nw0mv4ozUi+EFv7429Q="

    configuration._applySDGOverrides()
    configuration._validateSDGStandards(requireExamples: false)

    // #workaround(SwiftSyntax 0.50000.0, Compiler warnings.)
    configuration.testing.prohibitCompilerWarnings = false

    return configuration
}()
