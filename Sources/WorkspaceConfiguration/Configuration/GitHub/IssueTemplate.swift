/*
 IssueTemplate.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// @localization(🇩🇪DE) @crossReference(IssueTemplate)
/// Eine Themavorlage für GitHub.
public typealias Themavorlage = IssueTemplate
// @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(IssueTemplate)
/// A GitHub issue template.
public struct IssueTemplate : Decodable, Encodable {

    // @localization(🇩🇪DE) @crossReference(IssueTemplate.init(name:description:title:content:labels:assignees))
    /// Erstellt eine Themavorlage.
    ///
    /// - Parameters:
    ///     - name: Der name.
    ///     - beschreibung: Eine Beschreibung.
    ///     - titel: Ein vorgeschlagener Titel.
    ///     - inhalt: Inhalt.
    ///     - etiketten: Vorgeschlagene Etiketten.
    ///     - beauftragte: Vorgeschlagene Beauftragte.
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @localization(🇩🇪DE)
    public init(
        name: StrengerZeichenkette,
        beschreibung: StrengerZeichenkette,
        titel: StrengerZeichenkette? = nil,
        inhalt: Markdown,
        etiketten: [StrengerZeichenkette],
        beauftragte: [StrengerZeichenkette] = []) {
        self.init(
            name: name,
            description: beschreibung,
            title: titel,
            content: inhalt,
            labels: etiketten,
            assignees: beauftragte)
    }
    /// Creates an issue template.
    ///
    /// - Parameters:
    ///     - name: The name.
    ///     - description: A description.
    ///     - title: A default title.
    ///     - content: Content.
    ///     - labels: Default labels.
    ///     - assignees: Default assignees.
    public init(
        name: StrictString,
        description: StrictString,
        title: StrictString? = nil,
        content: Markdown,
        labels: [StrictString],
        assignees: [StrictString] = []) {
        self.name = name
        self.description = description
        self.title = title
        self.content = content
        self.labels = labels
        self.assignees = assignees
    }

    // MARK: - Properties

    // @localization(🇩🇪DE)
    /// Der Name.
    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN)
    /// The name.
    public var name: StrictString

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(IssueTemplate.description)
    /// A description.
    public var description: StrictString
    // @localization(🇩🇪DE) @crossReference(IssueTemplate.description)
    /// Eine Beschreibung.
    public var beschreibung: StrengerZeichenkette {
        get { return description }
        set { description = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(IssueTemplate.title)
    /// A default title.
    public var title: StrictString?
    // @localization(🇩🇪DE) @crossReference(IssueTemplate.title)
    /// Ein vorgeschlagener Titel.
    public var titel: StrengerZeichenkette? {
        get { return title }
        set { title = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(IssueTemplate.content)
    /// Content.
    public var content: Markdown
    // @localization(🇩🇪DE) @crossReference(IssueTemplate.content)
    /// Inhalt.
    public var inhalt: Markdown {
        get { return content }
        set { content = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(IssueTemplate.labels)
    /// Default labels.
    public var labels: [StrictString]
    // @localization(🇩🇪DE) @crossReference(IssueTemplate.labels)
    /// Vorgeschlagene Etiketten.
    public var etiketten: [StrengerZeichenkette] {
        get { return labels }
        set { labels = newValue }
    }

    // @localization(🇬🇧EN) @localization(🇺🇸EN) @localization(🇨🇦EN) @crossReference(IssueTemplate.assignees)
    /// Default assignees.
    public var assignees: [StrictString]
    // @localization(🇩🇪DE) @crossReference(IssueTemplate.assignees)
    /// Vorgeschlagene Beauftragte.
    public var beauftragte: [StrengerZeichenkette] {
        get { return assignees }
        set { assignees = newValue }
    }
}
