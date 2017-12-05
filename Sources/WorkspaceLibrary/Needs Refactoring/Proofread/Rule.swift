/*
 Rule.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstone
import SDGCommandLine

protocol Rule {
    static var name: String { get }
    static func check(file: File, status: inout Bool, output: inout Command.Output) throws
}

let rules: [Rule.Type] = [

    // Deprecated Symbols
    DeprecatedLinuxDocumentation.self,

    // Intentional
    MissingImplementation.self,

    // Functionality
    CompatibilityCharacters.self,
    AutoindentResilience.self,
    Mark.self,
    WorkspaceUnicodeSyntax.self,

    // Documentation
    DocumentationOfExtensionConstraints.self,
    DocumentationOfCompilationConditions.self,
    SyntaxColouring.self,

    // Style
    ColonSpacing.self,
    CalloutCasing.self,
    ParametersStyle.self
]

let sdgRules: [Rule.Type] = rules + [

    // General
    QuotationMarks.self,
    HyphenMinus.self,

    // Logic
    NotEqual.self,
    Not.self,
    Conjunction.self,
    Disjunction.self,

    // Mathematics
    LessThanOrEqual.self,
    GreaterThanOrEqual.self,
    SubtractAndSet.self,
    Multiplication.self,
    MultiplyAndSet.self,
    Division.self,
    DivideAndSet.self
]

extension Rule {

    static func errorNotice(status: inout Bool, file: File, range scalarRange: Range<String.UnicodeScalarView.Index>, replacement scalarReplacement: String?, message: String, noticeOnly: Bool = false) {

        // Scalars vs Clusters
        let clusterRange = scalarRange.clusters(in: file.contents.clusters)

        var clusterReplacement: String?
        if let replacement = scalarReplacement {
            let modifiedScalarRange = clusterRange.lowerBound.samePosition(in: file.contents.unicodeScalars) ..< clusterRange.upperBound.samePosition(in: file.contents.unicodeScalars)

            clusterReplacement = String(file.contents.unicodeScalars[modifiedScalarRange.lowerBound ..< scalarRange.lowerBound]) + replacement + String(file.contents.unicodeScalars[scalarRange.upperBound ..< modifiedScalarRange.upperBound])
        }

        // Output

        let path = file.path
        let lineNumber = file.contents.lineNumber(for: clusterRange.lowerBound)
        let column = file.contents.columnNumber(for: clusterRange.lowerBound)

        let lineRange = file.contents.lineRange(for: clusterRange)
        var line = String(file.contents[lineRange])
        if line.hasSuffix(String.crLF) {
            line.unicodeScalars.removeLast()
        }
        line.unicodeScalars.removeLast()

        let previousDistance = file.contents.distance(from: lineRange.lowerBound, to: clusterRange.lowerBound)
        let previous = String(repeating: " ", count: previousDistance)

        let markedDistance = file.contents.distance(from: clusterRange.lowerBound, to: clusterRange.upperBound)
        let marked = "^" + String(repeating: "~", count: markedDistance − 1)

        var output = [
            "\(path):\(lineNumber):\(column): warning: \(message) (\(name))",
            line,
            previous + marked
        ]
        if let replacement = clusterReplacement {
            output += [previous + replacement]
        }
        output += [""] // Final line break

        if ¬noticeOnly {
            status = false
        }
        if CommandLine.arguments[1] ≠ "proofread" {
            let colour: OutputColour
            if noticeOnly {
                colour = .yellow
            } else {
                colour = .red
            }
            print(output, in: colour, spaced: true)
        } else {
            let standardError = FileHandle.standardError
            standardError.write(output.joinAsLines().data(using: String.Encoding.utf8)!)
        }
    }

    static func isInAliasDefinition(for alias: String, at location: Range<String.Index>, in file: File) -> Bool {

        let lineRange = file.contents.lineRange(for: location)

        if lineRange.lowerBound ≠ file.contents.startIndex,
            file.contents[file.contents.lineRange(for: file.contents.index(before: lineRange.lowerBound) ..< lineRange.lowerBound)].contains("func " + alias) {
            return true
        } else if file.contents[lineRange].contains("RecommendedOver") {
            return true
        } else {
            return false
        }
    }

    static func isInConditionalCompilationStatement(at location: Range<String.Index>, in file: File) -> Bool {
        let lineRange = file.contents.lineRange(for: location)
        let line = String(file.contents[lineRange])
        return line.contains("\u{23}if") ∨ line.contains("\u{23}elseif")
    }
}
