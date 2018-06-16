
import WorkspaceConfiguration

public enum Metadata {

    public static let latestStableVersion = Version(0, 7, 3)
    public static let thisVersion: Version? = nil // Set this to latestStableWorkspaceVersion for release commits, nil the rest of the time.

    public static let packageURL = URL(string: "https://github.com/SDGGiesbrecht/Workspace")!
}

public let configuration: WorkspaceConfiguration = {
    let configuration = WorkspaceConfiguration()
    configuration.applySDGDefaults()

    configuration.documentation.currentVersion = Metadata.latestStableVersion
    configuration.documentation.projectWebsite = URL(string: "https://github.com/SDGGiesbrecht/Workspace#workspace")!
    configuration.documentation.repositoryURL = Metadata.packageURL

    configuration.documentation.localizations = ["🇨🇦EN"]

    configuration.documentation.readMe.shortProjectDescription["🇨🇦EN"] = "Workspace automates management of Swift projects."

    configuration.documentation.readMe.quotation = Quotation(original: "Πᾶν ὅ τι ἐὰν ποιῆτε, ἐκ ψυχῆς ἐργάζεσθε, ὡς τῷ Κυρίῳ καὶ οὐκ ἀνθρώποις.")
    configuration.documentation.readMe.quotation?.translation["🇨🇦EN"] = "Whatever you do, work from the heart, as working for the Lord and not for men."

    configuration.documentation.readMe.quotation?.citation["🇨🇦EN"] = "שאול/Shaʼul"

    configuration.documentation.readMe.quotation?.link["🇨🇦EN"] = URL(string: "https://www.biblegateway.com/passage/?search=Colossians+3&version=SBLGNT;NIV")!

    configuration.documentation.readMe.featureList["🇨🇦EN"] = [
        "- Provides rigorous validation:",
        "  - [Test coverage](Documentation/Test%20Coverage.md)",
        "  - [Compiler warnings](Documentation/Compiler%20Warnings.md)",
        "  - [Documentation coverage](Documentation/Documentation%20Generation.md#enforcement)",
        "  - [Example validation](Documentation/Examples.md)",
        "  - [Style proofreading](Documentation/Proofreading.md) (including [SwiftLint](https://github.com/realm/SwiftLint))",
        "  - [Reminders](Documentation/Manual%20Warnings.md)",
        "  - [Continuous integration set‐up](Documentation/Continuous%20Integration.md) ([Travis CI](https://travis-ci.org) with help from [Swift Version Manager](https://github.com/kylef/swiftenv))",
        "- Generates API [documentation](Documentation/Documentation%20Generation.md) (except from Linux). (Using [Jazzy](https://github.com/realm/jazzy))",
        "- Automates code maintenance:",
        "  - [Embedded resources](Documentation/Resources.md)",
        "  - [Inherited documentation](Documentation/Documentation%20Inheritance.md)",
        "  - [Xcode project generation](Documentation/Xcode.md)",
        "- Automates open source details:",
        "  - [File headers](Documentation/File%20Headers.md)",
        "  - [Read‐me files](Documentation/Read‐Me.md)",
        "  - [Licence notices](Documentation/Licence.md)",
        "  - [Contributing instructions](Documentation/Contributing%20Instructions.md)",
        "- Designed to interoperate with the [Swift Package Manager](https://swift.org/package-manager/).",
        "- Manages projects for macOS, Linux, iOS, watchOS and tvOS.",
        "- [Configurable](Documentation/Configuring%20Workspace.md)",
        "  - Configurations can be [shared](Documentation/Configuring%20Workspace.md#sharing-configurations-between-projects) between projects."
    ].joinedAsLines()

    configuration.documentation.readMe.other["🇨🇦EN"] = [
        "## The Workspace Workflow",
        "",
        "*The Workspace project is managed by... Workspace! So let’s try it out by following along using the Workspace project itself.*",
        "",
        "### When the Repository Is Cloned",
        "",
        "Workspace hides as much as it can from Git, so when a project using Workspace is pulled, pushed, or cloned...",
        "",
        "```shell",
        "git clone https://github.com/SDGGiesbrecht/Workspace",
        "```",
        "",
        "...only one small piece of Workspace comes with it: A short script called “Refresh” that comes in two variants, one for each operating system.",
        "",
        "*Hmm... I wish I had more tools at my disposal... Hey! What if I...*",
        "",
        "### Refresh the Workspace",
        "",
        "To refresh the workspace, double‐click the `Refresh` script for the corresponding operating system. (If you are on Linux and double‐clicking fails or opens a text file, see [here](Documentation/Linux%20Notes.md#doubleclicking-scripts).)",
        "",
        "`Refresh` opens a terminal window, and in it Workspace reports its actions while it sets the project folder up for development.",
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
        "To apply Workspace to a project, run the following command in the root of the project’s repository. (This requires a full install. See [Installation](#installation).)",
        "",
        "```shell",
        "$ workspace refresh",
        "```",
        "",
        "By default, Workspace refrains from tasks which would involve modifying project files. Such tasks must be activated with a [configuration](Documentation/Configuring%20Workspace.md) file.",
        ].joinedAsLines()

    configuration.applySDGOverrides()
    configuration.validateSDGStandards()
    return configuration
}()
