/*
 ElementSyntax.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2024 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2018–2024 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGLogic
  import SDGText

  import SDGHTML

  extension ElementSyntax {

    internal init(
      _ element: StrictString,
      attributes: [StrictString: StrictString] = [:],
      contents: StrictString
    ) {

      var constructedAttributes: [AttributeSyntax] = []
      for key in attributes.keys.sorted() {
        let name = String(key)
        let value = HTML.escapeTextForAttribute(attributes[key]!)
        constructedAttributes.append(
          AttributeSyntax(
            name: TokenSyntax(kind: .attributeName(name)),
            value: AttributeValueSyntax(
              value: TokenSyntax(kind: .attributeText(String(value)))
            )
          )
        )
      }

      let constructedContents = contents

      let name = TokenSyntax(kind: .elementName(String(element)))
      self = ElementSyntax(
        openingTag: OpeningTagSyntax(
          name: name,
          attributes: AttributesSyntax(
            attributes: ListSyntax(entries: constructedAttributes)
          )
        ),
        continuation: ElementContinuationSyntax(
          content: ListSyntax(entries: [
            ContentSyntax(
              kind: .text(
                TextSyntax(
                  text: TokenSyntax(kind: .text(String(constructedContents)))
                )
              )
            )
          ]),
          closingTag: ClosingTagSyntax(name: name)
        )
      )
    }

    internal func normalizedSource() -> StrictString {
      return StrictString(source())
    }
  }
#endif
