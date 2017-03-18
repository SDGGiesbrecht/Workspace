/*
 ReadMe.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

struct ReadMe {

    static let readMePath = RelativePath("README.md")

    private static let managementComment: String = {
        let managementWarning = File.managmentWarning(section: false, documentation: .readMe)
        return FileType.markdown.syntax.comment(contents: managementWarning)
    }()

    static let defaultQuotationURL: String = {
        if var chapter = Configuration.quotationChapter {
            chapter = chapter.replacingOccurrences(of: " ", with: "+")
            return "https://www.biblegateway.com/passage/?search=\(chapter)&version=\(Configuration.quotationOriginalKey);\(Configuration.quotationTranslationKey)"
        } else {
            return Configuration.noValue
        }
    }()

    static let defaultReadMeTemplate: String = {
        var readMe: [String] = [
            "# [_Project_]"
        ]

        if Configuration.shortProjectDescription ≠ nil {
            readMe += [
                "",
                "[_Short Description_]"
            ]
        }

        if Configuration.quotation ≠ nil {
            readMe += [
                "",
                "[_Quotation_]"
            ]
        }

        if Configuration.featureList ≠ nil {
            readMe += [
                "",
                "# Features",
                "",
                "[_Features_]"
            ]
        }

        return join(lines: readMe)
    }()

    static let quotationMarkup: String = {
        var quotation = Configuration.requiredQuotation.replacingOccurrences(of: "\n", with: "<br>")
        if let url = Configuration.quotationURL {
            quotation = "[\(quotation)](\(url))"
        }
        if let citation = Configuration.citation {
            let indent = [String](repeating: "&nbsp;", count: 100).joined()
            quotation += "<br>" + indent + "―" + citation
        }

        return "> " + quotation
    }()

    static let featureMarkup: String = {
        var features = Configuration.requiredQuotation.replacingOccurrences(of: "\n", with: "\n\u{2D} ")
        return "\u{2D} " + features
    }()

    static func refreshReadMe() {

        func key(_ name: String) -> String {
            return "[_\(name)_]"
        }

        var body = join(lines: [
            managementComment,
            "",
            Configuration.readMe
            ])

        body = body.replacingOccurrences(of: key("Project"), with: Configuration.projectName)

        let shortDescription = key("Short Description")
        if body.contains(shortDescription) {
            body = body.replacingOccurrences(of: shortDescription, with: Configuration.requiredShortProjectDescription)
        }

        let quotation = key("Quotation")
        if body.contains(quotation) {
            body = body.replacingOccurrences(of: quotation, with: quotationMarkup)
        }

        let features = key("Features")
        if body.contains(features) {
            body = body.replacingOccurrences(of: quotation, with: featureMarkup)
        }

        var readMe = File(possiblyAt: readMePath)
        readMe.body = body
        require() { try readMe.write() }
    }

    static func relinquishControl() {

        var readMe = File(possiblyAt: readMePath)
        if let range = readMe.contents.range(of: managementComment) {
            printHeader(["Cancelling read‐me management..."])
            readMe.contents.removeSubrange(range)
            force() { try readMe.write() }
        }
    }
}
