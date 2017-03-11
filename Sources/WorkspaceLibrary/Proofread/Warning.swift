/*
 Warning.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

protocol Warning : Rule {
    static var trigger: String { get }
    static func message(forDetails details: String) -> String?
    static var noticeOnly: Bool { get }
}

let manualWarnings: [Warning.Type] = [
    GenericWarning.self,
    WorkaroundReminder.self
]

extension Warning {

    static func check(file: File, status: inout Bool) {

        let marker = ("[\u{5F}\(trigger)", "_]")

        var index = file.contents.startIndex
        while let range = file.contents.range(of: marker, in: index ..< file.contents.endIndex) {
            index = range.upperBound

            guard let detailRange = file.contents.rangeOfContents(of: marker) else {
                fatalError(message: [
                    "Expected “\(marker.0)”...“\(marker.1)” in “\(file.contents.substring(with: range))”.",
                    "This may indicate a bug in Workspace."
                    ])
            }

            var details = file.contents.substring(with: detailRange)
            if details.hasPrefix(":") {
                details.unicodeScalars.removeFirst()
            }
            if details.hasPrefix(" ") {
                details.unicodeScalars.removeFirst()
            }

            if let message = message(forDetails: details) {
                errorNotice(status: &status, file: file, range: range, replacement: nil, message: message, noticeOnly: noticeOnly)
            }
        }
    }
}
