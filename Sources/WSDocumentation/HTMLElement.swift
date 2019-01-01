/*
 HTMLElement.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

internal struct HTMLElement {

    // MARK: - Initialization

    internal init(_ element: StrictString, attributes: [StrictString: StrictString] = [:], contents: StrictString, inline: Bool) {
        self.element = element
        self.inline = inline
        self.attributes = attributes
        self.contents = contents
    }

    // MARK: - Properties

    private var element: StrictString
    private var inline: Bool
    private var attributes: [StrictString: StrictString]
    private var contents: StrictString

    // MARK: - Source

    internal var source: StrictString {

        var result: StrictString = "<"
        result.append(contentsOf: element)
        for attribute in attributes.keys.sorted() {
            result.append(" ")
            result.append(contentsOf: attribute)
            result.append(contentsOf: "=\u{22}".scalars)
            result.append(contentsOf: HTML.escapeAttribute(attributes[attribute]!))
            result.append("\u{22}")
        }
        result.append(">")

        if ¬inline {
            result.append("\n")
        }
        result.append(contentsOf: contents)
        if ¬inline {
            result.append("\n")
        }

        result.append(contentsOf: "</".scalars)
        result.append(contentsOf: element)
        result.append(">")

        return result
    }
}
