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

/// A GitHub issue template.
public struct IssueTemplate : Decodable, Encodable {

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

    /// The name.
    public var name: StrictString

    /// A description.
    public var description: StrictString

    /// A default title.
    public var title: StrictString?

    /// Content.
    public var content: Markdown

    /// Default labels.
    public var labels: [StrictString]

    /// Default assignees.
    public var assignees: [StrictString]
}
