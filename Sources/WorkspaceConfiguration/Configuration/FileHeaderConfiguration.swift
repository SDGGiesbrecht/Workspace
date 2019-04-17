/*
 FileHeaderConfiguration.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018–2019 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Options related to file headers.
///
/// ```shell
/// $ workspace refresh file‐headers
/// ```
///
/// A file header is a commented section at the top of each file in a project. Typical uses for file headers include:
///
/// - Identifing which project the file belongs to.
/// - Indicating copyright.
/// - Providing licence reminders.
///
/// ### Precise Definition of a File Header
///
/// Because Workspace overwrites existing file headers, it is important to know how Workspace identifies them.
///
/// Workspace considers any comment that starts a file to be a file header, with the following constraints:
///
/// A file header may be a single block comment:
///
/// ```swift
/// /*
///  This is a header.
///  This is more of the same header.
///  */
/// /* This is not part of the header. */
/// ```
///
/// Alternatively, a file header may be a continous sequence of line comments:
///
/// ```swift
/// // This is a header.
/// // This is more of the same header.
///
/// // This is not part of the header.
/// ```
///
/// Documentation comments are never headers.
///
/// ```swift
/// /**
///  This is not a header.
///  */
/// ```
///
/// In shell scripts, the shebang line precedes the header and is not part of it.
///
/// ```shell
/// #!/bin/bash ← This is not part of the header.
///
/// # This is a header
/// ```
public struct FileHeaderConfiguration : Codable {

    /// Whether or not to manage the project file headers.
    ///
    /// This is off by default.
    public var manage: Bool = false

    /// The copyright notice.
    ///
    /// By default, this is assembled from the other documentation and licence options.
    ///
    /// Workspace will replace the dynamic element `#dates` with the file’s copyright dates. (e.g. “©2016–2017”).
    ///
    /// ### Determination of the Dates
    ///
    /// Workspace uses any pre‐existing start date if it can detect one already in the file header. Workspace searches for `©`, `(C)`, or `(c)` followed by an optional space and four digits. If none is found, Workspace will use the current date as the start date.
    ///
    /// Workspace always uses the current date as the end date.
    public var copyrightNotice: Lazy<[LocalizationIdentifier: StrictString]> = Lazy<[LocalizationIdentifier: StrictString]>(resolve: { configuration in
        let project = StrictString(WorkspaceContext.current.manifest.packageName)
        return configuration.localizationDictionary { localization in
            if let author = configuration.documentation.primaryAuthor {
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Copyright #dates \(author) and the \(project) project contributors."
                }
            } else {
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Copyright #dates the \(project) project contributors."
                }
            }
        }
    })

    /// The entire contents of the file header.
    ///
    /// By default, this is assembled from the other documentation and licence options.
    ///
    /// Workspace will replace the dynamic element `#filename` with the name of the particular file.
    public var contents: Lazy<StrictString> = Lazy<StrictString>(resolve: { configuration in

        let localizations = configuration.documentation.localizations
        let packageName = StrictString(WorkspaceContext.current.manifest.packageName)

        var header: [StrictString] = [
            "#filename",
            ""
        ]

        header.append(contentsOf: configuration.sequentialLocalizations({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "This source file is part of the " + packageName + " open source project."
            }
        }))
        if let site = configuration.documentation.projectWebsite {
            header.append(StrictString(site.absoluteString))
        }

        header.append("")

        header.append(configuration.fileHeaders.copyrightNotice.resolve(configuration))

        if configuration._isSDG {
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
    })
}
