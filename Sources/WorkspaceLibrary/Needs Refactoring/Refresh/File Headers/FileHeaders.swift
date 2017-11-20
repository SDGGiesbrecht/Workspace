/*
 FileHeaders.swift

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

struct FileHeaders {

    static func defaultCopyright(configuration: Configuration) throws -> Template {
        if try configuration.optionIsDefined(.author) {
            return Template(source: "Copyright [_Copyright_] [_Author_] and the [_Project_] project contributors.")
        } else {
            return Template(source: "Copyright [_Copyright_] the [_Project_] project contributors.")
        }
    }

    static let defaultFileHeader: String = {
        var defaultHeader: [String] = [
            "[_Filename_]",
            "",
            "This source file is part of the [_Project_] open source project."
            ]
        if Configuration.optionIsDefined(.projectWebsite) {
            defaultHeader.append("[_Website_]")
        }
        defaultHeader.append(contentsOf: [
            ""
            ])
        defaultHeader.append(String((try? defaultCopyright(configuration: Repository.packageRepository.configuration))!.text))
        if Configuration.sdg {
            defaultHeader.append(contentsOf: [
                "",
                "Soli Deo gloria."
                ])
        }
        if Configuration.optionIsDefined(.licence) {
            defaultHeader.append(contentsOf: [
                "",
                "[_Licence_]"
                ])
        }
        return join(lines: defaultHeader)
    }()

    static func copyright(fromText text: String) -> String {

        var oldStartDate: String?
        for symbol in ["©", "(C)", "(c)"] {
            for space in ["", " "] {
                if let range = text.scalars.firstMatch(for: (symbol + space).scalars)?.range {
                    var numberEnd = range.upperBound
                    text.scalars.advance(&numberEnd, over: RepetitionPattern(ConditionalPattern(condition: { $0 ∈ CharacterSet.decimalDigits })))
                    let number = text.scalars[range.upperBound ..< numberEnd]
                    if number.count == 4 {
                        oldStartDate = String(number)
                        break
                    }
                }
            }
        }
        let currentDate = Date()
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        let currentYear = "\(calendar.component(.year, from: currentDate))"
        let copyrightStart = oldStartDate ?? currentYear

        var copyright = "©"
        if currentYear == copyrightStart {
            copyright.append(currentYear)
        } else {
            copyright.append(copyrightStart + "–" + currentYear)
        }

        return copyright
    }

    static func refreshFileHeaders(output: inout Command.Output) throws {

        func key(_ name: String) -> String {
            return "[_\(name)_]"
        }

        let template = Configuration.fileHeader

        var possibleWebsite: String?
        if template.contains(key("Website")) {
            possibleWebsite = Configuration.requiredProjectWebsite
        }

        var possibleAuthor: String?
        if template.contains(key("Author")) {
            possibleAuthor = Configuration.requiredAuthor
        }

        var possibleLicence: String?
        if template.contains(key("Licence")) {
            possibleLicence = Configuration.requiredLicence.notice
        }

        var skippedFiles: Set<String> = []
        skippedFiles.insert("LICENSE.md")
        skippedFiles.insert(".github/ISSUE_TEMPLATE.md")
        skippedFiles.insert(".github/PULL_REQUEST_TEMPLATE.md")

        func shouldManageHeader(path: RelativePath) -> Bool {
            if path.string ∈ skippedFiles {
                return false
            }

            return true
        }

        for path in Repository.sourceFiles.filter({ shouldManageHeader(path: $0) }) {

            if FileType(filePath: path)?.syntax ≠ nil {

                var file = require() { try File(at: path) }
                let oldHeader = file.header
                var header = template

                header = header.replacingOccurrences(of: key("Filename"), with: path.filename)
                header = header.replacingOccurrences(of: key("Project"), with: String(try Repository.packageRepository.projectName(output:
                    &output)))
                if let website = possibleWebsite {
                    header = header.replacingOccurrences(of: key("Website"), with: website)
                }
                header = header.replacingOccurrences(of: key("Copyright"), with: FileHeaders.copyright(fromText: oldHeader))
                if let author = possibleAuthor {
                    header = header.replacingOccurrences(of: key("Author"), with: author)
                }
                if let licence = possibleLicence {
                    header = header.replacingOccurrences(of: key("Licence"), with: licence)
                }

                file.header = header
                require() { try file.write(output: &output) }
            }
        }
    }
}
