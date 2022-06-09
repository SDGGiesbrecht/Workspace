/*
 Resource.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
import SDGText

internal struct Resource {

  // MARK: - Properties

  internal let origin: URL
  internal let namespace: [StrictString]
  internal let deprecated: Bool
  internal let bundledName: StrictString?
  internal let bundledExtension: StrictString?

  internal var constructor: Constructor {
    switch origin.pathExtension {
    case "command", "css", "html", "js", "md", "sh", "txt", "xcscheme", "yml":
      return Constructor(
        type: "String",
        initializationFromData: { data in
          return "String(data: \(data), encoding: String.Encoding.utf8)!"
        }
      )
    default:
      return Constructor(
        type: "Data",
        initializationFromData: { data in
          return data
        }
      )
    }
  }
}
