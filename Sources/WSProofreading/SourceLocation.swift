/*
 SourceLocation.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2020 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2020 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !(os(Windows) || os(Android))  // #workaround(SwiftSyntax 0.50100.0, Cannot build.)
  import SwiftSyntax

  extension SourceLocation {

    internal func utf8(in source: String) -> String.UTF8View.Index {
      return source.utf8.index(source.utf8.startIndex, offsetBy: offset)
    }
    internal func scalar(in source: String) -> String.ScalarView.Index {
      return utf8(in: source).scalar(in: source.scalars)
    }
  }
#endif
