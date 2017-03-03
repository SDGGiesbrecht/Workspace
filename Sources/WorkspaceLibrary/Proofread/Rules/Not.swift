/*
 Not.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic

struct Not : Rule {

    static let name = "Not"

    static func check(file: File, status: inout Bool) {

        if let fileType = file.fileType {

            var message = "Use “¬” instead."
            if fileType == .swift {
                message += " (Import SDGLogic.)"
            }

            var index = file.contents.startIndex
            while let range = file.contents.range(of: "!", in: index ..< file.contents.endIndex) {
                index = range.upperBound

                func throwError() {
                    errorNotice(status: &status, file: file, range: range, replacement: "¬", message: message)
                }

                if let next = file.contents.substring(from: range.upperBound).unicodeScalars.first {
                    if ¬CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: "\u{22}!")).contains(next) {

                        switch fileType {
                        case .workspaceConfiguration, .yaml, .gitignore:
                            throwError()

                        case .swift:
                            if ¬isInAliasDefinition(for: "¬", at: range, in: file) {
                                throwError()
                            }
                            
                        case .markdown:
                            if next ≠ "-" {
                                throwError()
                            }

                        case .shell:
                            if next ≠ "/" {
                                throwError()
                            }
                        }
                    }
                }
            }
        }
    }
}
