//
//  File.swift
//  Workspace
//
//  Created by Jeremy David Giesbrecht on 2017‐03‐09.
//
//

struct ManualWarning : Rule {

    static let name = "Manual Warning"

    static func check(file: File, status: inout Bool) {

        var index = file.contents.startIndex
        while let range = file.contents.rangeOfContents(of: ("[_Warning: ", "_]"), in: index ..< file.contents.endIndex) {
            index = range.upperBound

            errorNotice(status: &status, file: file, range: range, replacement: nil, message: file.contents.substring(with: range))
        }
    }
}
