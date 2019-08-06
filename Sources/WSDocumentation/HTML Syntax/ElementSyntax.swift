/*
 ElementSyntax.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import WSGeneralImports

import SDGHTML

extension ElementSyntax {

    internal init(
        _ element: StrictString,
        attributes: [StrictString: StrictString] = [:],
        contents: StrictString,
        inline: Bool
        ) {

        var constructedAttributes: [AttributeSyntax] = []
        for key in attributes.keys.sorted() {
            let name = String(key)
            let value = HTML.escapeTextForAttribute(attributes[key]!)
            constructedAttributes.append(AttributeSyntax(
                name: TokenSyntax(kind: .attributeName(name)),
                value: AttributeValueSyntax(value: TokenSyntax(kind: .attributeText(String(value))))))
        }

        let constructedContents = inline ? contents : "\n" + contents + "\n"

        let name = TokenSyntax(kind: .elementName(String(element)))
        self = ElementSyntax(
            openingTag: OpeningTagSyntax(
                name: name,
                attributes: AttributesSyntax(attributes: ListSyntax(entries: constructedAttributes))),
            continuation: ElementContinuationSyntax(
                content: ContentSyntax(elements: ListSyntax(entries: [
                    ContentElementSyntax(
                        kind: .text(TextSyntax(text: TokenSyntax(kind: .text(String(constructedContents))))))
                    ])),
                closingTag: ClosingTagSyntax(name: name)))
    }

    func normalizedSource() -> StrictString {
        return StrictString(source())
    }
}
