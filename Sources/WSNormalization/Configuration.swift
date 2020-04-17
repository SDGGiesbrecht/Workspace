/*
 Configuration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(swift-format 0.50200.0, Cannot build.)
#if !os(WASI)
import Foundation

import SwiftFormatConfiguration

extension Configuration {

  internal func reducedToMachineResponsibilities() -> Configuration {
    /*
     Machines should be responsible for:
     • Text wrapping, because it is a matter of display and should not be hard‐coded in the first place.
     • Indentation, for the same reason, and also because various tools tear it back and forth.

     For other rules, while it is helpful to have a safety net to catch oversights, human beings deserve the opportunity to learn from their mistakes. Automatically cleaning up after them is an insult to humanity and encourages laziness. Writing something right the first time is faster than writing it wrong and then tasking a machine to fix it.
     */
    var copy = self
    copy.rules = [:]
    return copy
  }
}
#endif
