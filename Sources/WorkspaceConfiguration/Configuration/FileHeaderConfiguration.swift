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
    /// Workspace will replace the dynamic element `#dates` with the file’s copyright dates. (e.g. “©2016–2017”).
    public var copyrightNotice: Lazy<StrictString> = Lazy<StrictString>() { configuration in
        let project = StrictString(WorkspaceContext.current.manifest.packageName)
        if let author = configuration.documentation.primaryAuthor {
            let components: [StrictString] = ["Copyright #dates ", author, " and the ", project, " project contributors."]
            return components.joined()
        } else {
            return "Copyright #dates the " + project + " project contributors."
        }
    }

    /// The entire contents of the file header.
    ///
    /// By default, this is assembled from the other documentation and licence options.
    ///
    /// Workspace will replace the dynamic element `#filename` with the name of the particular file.
    public var contents: Lazy<StrictString> = Lazy<StrictString>() { configuration in

        let packageName = StrictString(WorkspaceContext.current.manifest.packageName)

        var header: [StrictString] = [
            "#filename",
            "",
            "This source file is part of the " + packageName + " open source project."
        ]
        if let site = configuration.documentation.projectWebsite {
            header.append(StrictString(site.absoluteString))
        }

        header.append("")

        header.append(configuration.fileHeaders.copyrightNotice.resolve(configuration))

        if configuration.isSDG {
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

        return header.joinedAsLines()
    }
}
