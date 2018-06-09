/*
 FileHeaderConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to file headers.
public struct FileHeaderConfiguration: Codable {

    /// Whether or not to manage the project file headers.
    ///
    /// This is off by default.
    public var manage: Bool = false

    /// The copyright notice.
    ///
    /// By default, this is assembled from the other documentation and licence options.
    ///
    /// Workspace will replace the dynamic element `[_dates_]` with the file’s copyright dates. (e.g. “©2016–2017”).
    public var copyrightNotice: Lazy<String> = Lazy<String>() { configuration in
        let project = WorkspaceContext.current.manifest.packageName
        if let author = configuration.documentation.primaryAuthor {
            return "Copyright [_dates_] \(author) and the \(project) project contributors."
        } else {
            return "Copyright [_dates_] the \(project) project contributors."
        }
    }

    /// The entire contents of the file header.
    ///
    /// By default, this is assembled from the other documentation and licence options.
    ///
    /// Workspace will replace the dynamic element `[_filename_]` with the name of the particular file.
    public var contents: Lazy<String> = Lazy<String>() { configuration in

        var header: [String] = [
            "[_filename_]",
            "",
            "This source file is part of the \(WorkspaceContext.current.manifest.packageName) open source project."
        ]
        if let site = configuration.documentation.projectWebsite {
            header.append(site.absoluteString)
        }

        header.append(contentsOf: [
            ""
            ])

        header.append(configuration.fileHeaders.copyrightNotice.resolve(configuration))

        if configuration.sdg {
            header.append(contentsOf: [
                "",
                "Soli Deo gloria."
                ])
        }

        if let licence = configuration.licence.licence {
            header.append(contentsOf: [
                "",
                licence.notice
                ])
        }

        return header.joined(separator: "\n")
    }
}
