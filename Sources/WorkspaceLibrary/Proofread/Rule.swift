/*
 Rule.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

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
    CompatibilityCharacters.self,

    ColonSpacing.self
]

extension Rule {

    static func errorNotice(status: inout Bool, file: File, range: Range<String.Index>, replacement: String?, message: String) {
        errorNotice(status: &status, file: file, range: range.lowerBound.samePosition(in: file.contents.unicodeScalars) ..< range.upperBound.samePosition(in: file.contents.unicodeScalars), replacement: replacement, message: message)
    }

    static func errorNotice(status: inout Bool, file: File, range scalarRange: Range<String.UnicodeScalarView.Index>, replacement scalarReplacement: String?, message: String) {

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
        if line.hasSuffix(String.CR_LF) {
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

        status = false
        if Command.current ≠ Command.proofread {
            print(output, in: OutputColour.red, spaced: true)
        } else {
            let standardError = FileHandle.standardError
            standardError.write(join(lines: output).data(using: String.Encoding.utf8)!)
        }
    }
}
