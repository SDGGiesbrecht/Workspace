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

import SDGLogic
import SDGMathematics

protocol Rule {
    static var name: String { get }
    static func check(file: File, status: inout Bool)
}

let rules: [Rule.Type] = [

    // Functionality
    CompatibilityCharacters.self,
    AutoindentResilience.self,
    Mark.self,
    WorkspaceUnicodeSyntax.self,

    // Documentation
    DocumentationOfExtensionContstraints.self,
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

    static func errorNotice(status: inout Bool, file: File, range: Range<String.Index>, replacement: String?, message: String, noticeOnly: Bool = false) {
        errorNotice(status: &status, file: file, range: range.lowerBound.samePosition(in: file.contents.unicodeScalars) ..< range.upperBound.samePosition(in: file.contents.unicodeScalars), replacement: replacement, message: message, noticeOnly: noticeOnly)
    }

    static func errorNotice(status: inout Bool, file: File, range scalarRange: Range<String.UnicodeScalarView.Index>, replacement scalarReplacement: String?, message: String, noticeOnly: Bool = false) {

        // Scalars vs Clusters
        let clusterStart = scalarRange.lowerBound.positionOfExtendedGraphemeCluster(in: file.contents)
        var clusterEnd = scalarRange.upperBound.positionOfExtendedGraphemeCluster(in: file.contents)
        if clusterEnd.samePosition(in: file.contents.unicodeScalars) ≠ scalarRange.upperBound {
            clusterEnd = file.contents.index(after: clusterEnd) // Round ahead intead of back.
        }
        let clusterRange = clusterStart ..< clusterEnd

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
        var line = file.contents[lineRange]
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
        if Command.current ≠ Command.proofread {
            let colour: OutputColour
            if noticeOnly {
                colour = .yellow
            } else {
                colour = .red
            }
            print(output, in: colour, spaced: true)
        } else {
            let standardError = FileHandle.standardError
            standardError.write(join(lines: output).data(using: String.Encoding.utf8)!)
        }
    }

    static func isInAliasDefinition(for alias: String, at location: Range<String.Index>, in file: File) -> Bool {

        let lineRange = file.contents.lineRange(for: location)

        if lineRange.lowerBound ≠ file.contents.startIndex,
            file.contents.substring(with: file.contents.lineRange(for: file.contents.index(before: lineRange.lowerBound) ..< lineRange.lowerBound)).contains("func " + alias) {
            return true
        } else if file.contents.substring(with: lineRange).contains("RecommendedOver") {
            return true
        } else {
            return false
        }
    }

    static func isInConditionalCompilationStatement(at location: Range<String.Index>, in file: File) -> Bool {
        let lineRange = file.contents.lineRange(for: location)
        let line = file.contents.substring(with: lineRange)
        return line.contains("#if") ∨ line.contains("#elseif")
    }
}
