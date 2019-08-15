/*
 SDGWebExtensions.swift

 This source file is part of the Workspace open source project.
 Diese Quelldatei ist Teil des qeulloffenen Workspace‐Projekt.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2019 Jeremy David Giesbrecht and the Workspace project contributors.
 Urheberrecht ©2019 Jeremy David Giesbrecht und die Mitwirkenden des Workspace‐Projekts.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(SDGWeb 1.0.2, Until available in SDGWeb.)
import WSGeneralTestImports

import SDGWeb

class PageProcessor : SDGWeb.PageProcessor {
    func process(
        pageTemplate: inout StrictString,
        title: StrictString,
        content: StrictString,
        siteRoot: StrictString,
        localizationRoot: StrictString,
        relativePath: StrictString) {}
}

extension Site {

    static func validate(site: URL) -> [URL: [SiteValidationError]] {
        let mockStructure = RepositoryStructure(root: site, result: site)
        let mockString = UserFacing<StrictString, InterfaceLocalization>({ _ in "" })
        let mockSite = Site<InterfaceLocalization>(
            repositoryStructure: mockStructure,
            domain: mockString,
            localizationDirectories: mockString,
            pageProcessor: PageProcessor(),
            reportProgress: { _ in })
        return mockSite.validate()
    }
}
