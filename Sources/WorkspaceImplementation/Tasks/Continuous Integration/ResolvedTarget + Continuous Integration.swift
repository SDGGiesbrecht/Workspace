/*
 ResolvedTarget + Continuous Integration.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des quelloffenen Arbeitsbereich‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2020–2021 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2020–2021 Jeremy David Giesbrecht und die Mitwirkenden des Arbeitsbereich‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

  import Foundation

import SDGLogic

// #workaround(SwiftPM 0.7.0, Cannot build.)
#if !(os(Windows) || os(WASI) || os(Android))
  import PackageModel
  import SwiftSyntax

  extension ResolvedTarget {

    internal func testClasses() throws -> [(name: String, methods: [String])] {
      var found: [(name: String, methods: [String])] = []
      for file in sources.paths.sorted() {
        let syntax = try SyntaxParser.parse(file.asURL)
        for statement in syntax.statements {
          if let classDeclaration = statement.item.as(ClassDeclSyntax.self) {
            let name = classDeclaration.identifier.text
            var methods: [String] = []
            if name.hasSuffix("Tests") {
              for member in classDeclaration.members.members {
                if let method = member.decl.as(FunctionDeclSyntax.self) {
                  let methodName = method.identifier.text
                  if methodName.hasPrefix("test") {
                    methods.append(methodName)
                  }
                }
              }
            }
            if ¬methods.isEmpty {
              found.append((name: "\(self.name).\(name)", methods: methods))
            }
          }
        }
      }
      return found
    }
  }
#endif
