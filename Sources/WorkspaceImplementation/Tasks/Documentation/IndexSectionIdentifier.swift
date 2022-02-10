/*
 IndexSectionIdentifier.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019–2022 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019–2022 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !PLATFORM_NOT_SUPPORTED_BY_WORKSPACE_WORKSPACE
  import SDGText

  internal enum IndexSectionIdentifier {

    // MARK: - Cases

    case package
    case tools
    case libraries
    case modules
    case types
    case extensions
    case protocols
    case functions
    case variables
    case operators
    case precedenceGroups

    // MARK: - Use

    private var htmlIdentifierPrefix: StrictString {
      switch self {
      case .package:
        return "Package"
      case .tools:
        return "executable"
      case .libraries:
        return "library"
      case .modules:
        return "target"
      case .types:
        return "struct"
      case .extensions:
        return "extension"
      case .protocols:
        return "protocol"
      case .functions:
        return "func"
      case .variables:
        return "var"
      case .operators:
        return "operator"
      case .precedenceGroups:
        return "precedencegroup"
      }
    }

    internal var htmlIdentifier: StrictString {
      return htmlIdentifierPrefix + "‐index"
    }
  }
#endif
