/*
 APITests.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation
import XCTest

import SDGCornerstone
import SDGCommandLine

import WorkspaceLibrary

class APITests : TestCase {

    func testCheckForUpdates() {
        XCTAssertErrorFree {
            try Workspace.command.execute(with: ["check‐for‐updates"])
        }
    }

    func testConfiguration() {
        /* [_Warning: Restore._]
         XCTAssertThrowsError(containing: "Invalid") {
         let project = try MockProject()
         try project.do {
         try "Project Type: Something\nManage Continuous Integration: True".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
         }
         }*/
    }

    func testDocumentation() {
        /* [_Warning: Restore._]

         XCTAssertThrowsError(containing: "not defined") {
         let project = try MockProject(type: "Library")
         try project.do {
         try "Documentation Copyright: [_Author_]".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
         try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
         }
         }

         XCTAssertErrorFree { // Failures here when inside Xcode are irrelevant. (Xcode bypasses shell login scripts necessary to find Jazzy and other Ruby gems.)
         let project = try MockProject(type: "Library")
         try project.do {
         try "Support macOS: False\nSupport iOS: False\nSupport watchOS: False".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
         try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
         }
         }

         XCTAssertThrowsError(containing: "fails validation") { // Failures here when inside Xcode are irrelevant. (Xcode bypasses shell login scripts necessary to find Jazzy and other Ruby gems.)
         let project = try MockProject(type: "Library")
         try project.do {
         try "\u{70}ublic func undocumentedFunction() {}".save(to: project.location.appendingPathComponent("Sources/MyProject/Undocumented.swift"))
         try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
         try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
         }
         }
         #endif

         */
    }

    func testReadMe() {

        /* [_Warning: Restore._]
         XCTAssertErrorFree {
         // Skeleton
         let project = try MockProject()
         try project.do {

         try Resources.ReadMe.skeletonWorkspaceConfiguration.save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         defer {
         XCTAssertEqual(try String(from: project.location.appendingPathComponent("README.md")), "\n" + String(LineView<String>(Resources.ReadMe.skeletonReadMe.lines.dropFirst(13))))
         }

         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }

         XCTAssertErrorFree {
         // Partial
         let project = try MockProject()
         try project.do {

         try Resources.ReadMe.partialWorkspaceConfiguration.save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         defer {
         XCTAssertEqual(try String(from: project.location.appendingPathComponent("README.md")), "\n" + String(LineView<String>(Resources.ReadMe.partialReadMe.lines.dropFirst(13))))
         }

         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }

         XCTAssertErrorFree {
         // Elaborate
         let project = try MockProject(type: "Executable")
         try project.do {

         try Resources.ReadMe.elaborateWorkspaceConfiguration.save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try [
         "// [\u{5F}Define Example: Read‐Me 🇨🇦EN_]", "doSomething()", "// [_End_]",
         "// [\u{5F}Define Example: Read‐Me 🇩🇪DE_]", "...", "// [_End_]",
         "// [\u{5F}Define Example: Read‐Me 🇫🇷FR_]", "...", "// [_End_]",
         "// [\u{5F}Define Example: Read‐Me 🇬🇷ΕΛ_]", "...", "// [_End_]",
         "// [\u{5F}Define Example: Read‐Me 🇮🇱עב_]", "...", "// [_End_]",
         ""
         ].joined(separator: "\n").save(to: project.location.appendingPathComponent("Sources/MyProject/Example.swift"))
         defer {
         XCTAssertEqual(try String(from: project.location.appendingPathComponent("README.md")), "\n" + String(LineView<String>(Resources.ReadMe.elaborateReadMe.lines.dropFirst(13))))
         XCTAssertEqual(try String(from: project.location.appendingPathComponent("Documentation/🇬🇷ΕΛ Με διαβάστε.md")), "\n" + String(LineView<String>(Resources.ReadMe.elaborateΜεΔιαβάστε.lines.dropFirst(13))))
         }

         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }

         XCTAssertErrorFree {
         // Custom Installation
         let project = try MockProject()
         try project.do {

         try Resources.ReadMe.customWorkspaceConfiguration.save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         defer {
         XCTAssertEqual(try String(from: project.location.appendingPathComponent("README.md")), "\n" + String(LineView<String>(Resources.ReadMe.customReadMe.lines.dropFirst(13))))
         }

         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }

         // No localizations configured.
         XCTAssertThrowsError(containing: "Localization") {
         let project = try MockProject()
         try project.do {

         try "Manage Read‐Me: True".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }

         // Dynamic elements that do not exist.
         XCTAssertThrowsError(containing: "Documentation URL") {
         let project = try MockProject()
         try project.do {
         try "Manage Read‐Me: True\nLocalizations: en\n[_Begin Read‐Me_]\n[_en_]\n[_API Links_]\n[_End_]".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }
         XCTAssertThrowsError(containing: "Current Version") {
         let project = try MockProject()
         try project.do {
         try "Manage Read‐Me: True\nLocalizations: en\n[_Begin Read‐Me_]\n[_en_]\n[_Current Version_]\n[_End_]".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }
         XCTAssertThrowsError(containing: "Repository URL") {
         let project = try MockProject()
         try project.do {
         try "Manage Read‐Me: True\nLocalizations: en\n[_Begin Read‐Me_]\n[_en_]\n[_Repository URL_]\n[_End_]".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }
         XCTAssertThrowsError(containing: "Short Project Description") {
         let project = try MockProject()
         try project.do {
         try "Manage Read‐Me: True\nLocalizations: en\n[_Begin Read‐Me_]\n[_en_]\n[_Short Description_]\n[_End_]".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }
         XCTAssertThrowsError(containing: "Quotation") {
         let project = try MockProject()
         try project.do {
         try "Manage Read‐Me: True\nLocalizations: en\n[_Begin Read‐Me_]\n[_en_]\n [_Quotation_]\n[_End_]".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }
         XCTAssertThrowsError(containing: "Quotation Testament") {
         let project = try MockProject()
         try project.do {
         try "Manage Read‐Me: True\nLocalizations: en\n[_Begin Read‐Me_]\n[_en_]\n [_Quotation_]\n[_End_]\nQuotation: ...\nQuotation Chapter: Genesis 1".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }
         XCTAssertThrowsError(containing: "Quotation Testament") {
         let project = try MockProject()
         try project.do {
         try "Manage Read‐Me: True\nLocalizations: en\n[_Begin Read‐Me_]\n[_en_]\n [_Quotation_]\n[_End_]\nQuotation: ...\nQuotation Chapter: Genesis 1\nQuotation Testament: ...".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }
         XCTAssertThrowsError(containing: "Feature List") {
         let project = try MockProject()
         try project.do {
         try "Manage Read‐Me: True\nLocalizations: en\n[_Begin Read‐Me_]\n[_en_]\n [_Features_]\n[_End_]".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }
         XCTAssertThrowsError(containing: "Example Usage") {
         let project = try MockProject()
         try project.do {
         try "Manage Read‐Me: True\nLocalizations: en\n[_Begin Read‐Me_]\n[_en_]\n[\u{5F}Example Usage_]\n[_End_]".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }
         XCTAssertThrowsError(containing: "Other Read‐Me Content") {
         let project = try MockProject()
         try project.do {
         try "Manage Read‐Me: True\nLocalizations: en\n[_Begin Read‐Me_]\n[_en_]\n [_Other_]\n[_End_]".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }
         XCTAssertThrowsError(containing: "About") {
         let project = try MockProject()
         try project.do {
         try "Manage Read‐Me: True\nLocalizations: en\n[_Begin Read‐Me_]\n[_en_]\n [_About_]\n[_End_]".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }

         // Invalid related project.
         XCTAssertThrowsError(containing: "URL") {
         let project = try MockProject()
         try project.do {
         try "Manage Read‐Me: True\nLocalizations: en\n[_Begin Related Projects_]\n\n[_End_]".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }

         XCTAssertErrorFree {
         try FileManager.default.do(in: repositoryRoot) {
         // Validate self‐specific details.
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         }
         }
         */
    }

    func testResources() {

        /* [_Warning: Restore._]
         XCTAssertErrorFree {
         let project = try MockProject()
         try project.do {
         try "Text File".save(to: project.location.appendingPathComponent("Resources/MyProject/Text Resource.txt"))
         defer {
         XCTAssert(try String(from: project.location.appendingPathComponent("Sources/MyProject/Resources.swift")).contains("let textResource ="), "Failed to generate code to access resources.")
         }

         try "Data File".save(to: project.location.appendingPathComponent("Resources/MyProject/Miscellaneous/1‐2‐3!.undefined"))
         defer {
         XCTAssert(try String(from: project.location.appendingPathComponent("Sources/MyProject/Resources.swift")).contains("enum Miscellaneous {"), "Failed to generate resource namespace.")
         XCTAssert(try String(from: project.location.appendingPathComponent("Sources/MyProject/Resources.swift")).contains("let _1_2_3 ="), "Failed to generate code to access nested resources.")
         }

         // [_Workaround: This should eventually just run “validate” to make sure it passes other validation too._]]
         try Workspace.command.execute(with: ["refresh", "resources"])
         try Shell.default.run(command: ["swift", "build"]) // Generated code must have valid syntax.
         }
         }

         XCTAssertThrowsError(containing: "Text Resource.txt") {
         let project = try MockProject()
         try project.do {
         try "Text File".save(to: project.location.appendingPathComponent("Resources/Text Resource.txt"))
         try Workspace.command.execute(with: ["refresh", "resources"])
         }
         }

         XCTAssertThrowsError(containing: "InvalidTarget") {
         let project = try MockProject()
         try project.do {
         try "Text File".save(to: project.location.appendingPathComponent("Resources/InvalidTarget/Text Resource.txt"))
         try Workspace.command.execute(with: ["refresh", "resources"])
         }
         }
         */
    }

    func testScripts() {

        /* [_Warning: Restore._]
         XCTAssertErrorFree {
         let project = try MockProject()
         try project.do {
         // Validate that generated scripts work.
         try "Deprecated".save(to: project.location.appendingPathComponent("Refresh Workspace (macOS).command"))
         try Workspace.command.execute(with: ["refresh", "scripts"])
         XCTAssert(FileManager.default.isExecutableFile(atPath: "Refresh (macOS).command"), "Generated macOS refresh script is not executable.")
         XCTAssert(FileManager.default.isExecutableFile(atPath: "Refresh (Linux).sh"), "Generated Linux refresh script is not executable.")
         XCTAssert(FileManager.default.isExecutableFile(atPath: "Validate (macOS).command"), "Generated macOS validate script is not executable.")
         #if os(Linux)
         XCTAssert(FileManager.default.isExecutableFile(atPath: "Validate (Linux).sh"), "Generated Linux validate script is not executable.")
         #endif
         }
         }

         XCTAssertErrorFree {
         try FileManager.default.do(in: repositoryRoot) {
         // Validate generation of self‐specific scripts.
         try Workspace.command.execute(with: ["refresh", "scripts"])
         }
         }
         */
    }

    func testWorkflow() {
        // Get version checks over with, so that they are not in the output.
        triggerVersionChecks()

        // Make a depencency available.
        let developer = URL(fileURLWithPath: "/tmp/Developer")
        try? FileManager.default.removeItem(at: developer)
        defer { try? FileManager.default.removeItem(at: developer) }
        let dependency = developer.appendingPathComponent("Dependency")
        XCTAssertErrorFree {
            try FileManager.default.do(in: dependency) {
                try Shell.default.run(command: ["swift", "package", "init"])
                try Shell.default.run(command: ["git", "init"])
                try Shell.default.run(command: ["git", "add", "."])
                try Shell.default.run(command: ["git", "commit", "\u{2D}m", "Initialized."])
                try Shell.default.run(command: ["git", "tag", "1.0.0"])
            }
        }

        // Test on mock projects.
        let mockProjectsDirectory = repositoryRoot.appendingPathComponent("Tests/Mock Projects")
        let beforeDirectory = mockProjectsDirectory.appendingPathComponent("Before")
        XCTAssertErrorFree {
            for project in try FileManager.default.contentsOfDirectory(at: beforeDirectory, includingPropertiesForKeys: nil, options: [])
                where project.lastPathComponent ≠ ".DS_Store" {
                    print("\n\nTesting on “\(project.lastPathComponent)”...\n\n".formattedAsSectionHeader())

                    let expectedToFail = (try? project.appendingPathComponent("✗").checkResourceIsReachable()) == true

                    let resultLocation = mockProjectsDirectory.appendingPathComponent("After/" + project.lastPathComponent)
                    let outputLocation = mockProjectsDirectory.appendingPathComponent("Output/" + project.lastPathComponent + ".txt")

                    // Ensure proper starting state.
                    func revertToStartingState() {
                        try? FileManager.default.removeItem(at: project)
                        XCTAssertErrorFree {
                            try FileManager.default.do(in: repositoryRoot) {
                                try Shell.default.run(command: [
                                    "git", "checkout", Shell.quote(project.path)
                                    ])
                            }
                        }
                    }
                    revertToStartingState()
                    defer { revertToStartingState() }

                    try FileManager.default.do(in: project) {
                        LocalizationSetting(orderOfPrecedence: ["en\u{2D}CA"]).do {

                            // [_Workaround: This should eventually just do “workspace validate”._]
                            var output: StrictString = ""

                            if expectedToFail {
                                do {
                                    output += "\n$ workspace refresh scripts\n"
                                    output += try Workspace.command.execute(with: ["refresh", "scripts", "•no‐colour"])

                                    if project.lastPathComponent ∉ Set(["InvalidConfigurationEnumerationValue"]) {
                                        output += "\n$ workspace refresh read‐me\n"
                                        output += try Workspace.command.execute(with: ["refresh", "read‐me", "•no‐colour"])
                                    }

                                    if project.lastPathComponent ∉ Set(["InvalidConfigurationEnumerationValue", "UndefinedConfigurationValue"]) {
                                        output += "\n$ workspace refresh continuous‐integration\n"
                                        output += try Workspace.command.execute(with: ["refresh", "continuous‐integration", "•no‐colour"])
                                    }

                                    output += "\n$ workspace refresh resources\n"
                                    output += try Workspace.command.execute(with: ["refresh", "resources", "•no‐colour"])

                                    #if !os(Linux)
                                        try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])

                                        output += "\n$ workspace validate documentation‐coverage\n"
                                        output += try Workspace.command.execute(with: ["validate", "documentation‐coverage", "•no‐colour"])
                                    #endif
                                } catch let error as Command.Error {
                                    output += "\n" + error.describe()
                                } catch let error {
                                    XCTFail("Unexpected error: \(error)")
                                }
                            } else {
                                XCTAssertErrorFree {
                                    output += "\n$ workspace refresh scripts\n"
                                    output += try Workspace.command.execute(with: ["refresh", "scripts", "•no‐colour"])
                                }

                                if project.lastPathComponent ∉ Set(["Default", "NoMacOS", "UnicodeSource"]) {
                                    XCTAssertErrorFree {
                                        output += "\n$ workspace refresh read‐me\n"
                                        output += try Workspace.command.execute(with: ["refresh", "read‐me", "•no‐colour"])
                                    }
                                }

                                if project.lastPathComponent ∉ Set(["Default", "NoMacOS", "UnicodeSource"]) {
                                    XCTAssertErrorFree {
                                        output += "\n$ workspace refresh continuous‐integration\n"
                                        output += try Workspace.command.execute(with: ["refresh", "continuous‐integration", "•no‐colour"])
                                    }
                                }

                                XCTAssertErrorFree {
                                    output += "\n$ workspace refresh resources\n"
                                    output += try Workspace.command.execute(with: ["refresh", "resources", "•no‐colour"])
                                }

                                #if !os(Linux)
                                    XCTAssertErrorFree {
                                        try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                                    }
                                #endif

                                if project.lastPathComponent ∉ Set(["Default"]) {
                                    XCTAssertErrorFree {
                                        output += "\n$ workspace validate documentation‐coverage\n"
                                        output += try Workspace.command.execute(with: ["validate", "documentation‐coverage", "•no‐colour"])

                                        if project.lastPathComponent ∉ Set(["Default", "SDG"]) {
                                            let index = try String(from: project.appendingPathComponent("docs/\(project.lastPathComponent)/index.html"))
                                            XCTAssert(¬index.contains("Skip in Jazzy"), "Failed to remove read‐me–only content.")

                                            if project.lastPathComponent == "UnicodeSource" {
                                                let page = try String(from: project.appendingPathComponent("docs/UnicodeSource/Extensions/Bool.html"))
                                                XCTAssert(¬page.contains("\u{22}err\u{22}"), "Failed to clean up Jazzy output.")
                                            }
                                        }
                                    }
                                }




                                XCTAssertErrorFree {
                                    try? FileManager.default.removeItem(at: resultLocation)
                                    try FileManager.default.copy(project, to: resultLocation)
                                    // Remove variable files.
                                    try? FileManager.default.removeItem(at: resultLocation.appendingPathComponent("Package.resolved"))
                                    try? FileManager.default.removeItem(at: resultLocation.appendingPathComponent("docs/\(project.lastPathComponent)/docsets"))
                                }
                                checkForDifferences(in: "repository", at: resultLocation, for: project)
                            }

                            let replacement = "[...]".scalars
                            // Remove varying repository location.
                            output.replaceMatches(for: repositoryRoot.path.scalars, with: replacement)
                            // Remove varying temporary directory.
                            output.replaceMatches(for: FileManager.default.url(in: .temporary, at: "Temporary").deletingLastPathComponent().path.scalars, with: replacement)
                            output.replaceMatches(for: "`..".scalars, with: "`".scalars)
                            output.replaceMatches(for: "/..".scalars, with: [])

                            XCTAssertErrorFree { try output.save(to: outputLocation) }
                            checkForDifferences(in: "output", at: outputLocation, for: project)
                        }
                    }
            }
        }

        /* [_Warning: Restore._]
         XCTAssertErrorFree { // Failures here when inside Xcode are irrelevant. (Xcode bypasses shell login scripts necessary to find Jazzy and other Ruby gems.)
         try MockProject().do {

         // [_Workaround: This should eventually just do “validate”._]
         try Workspace.command.execute(with: ["refresh", "scripts"])
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
         try Workspace.command.execute(with: ["refresh", "resources"])
         #if !os(Linux)
         try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
         try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
         #endif
         }
         }

         XCTAssertErrorFree { // Failures here when inside Xcode are irrelevant. (Xcode bypasses shell login scripts necessary to find Jazzy and other Ruby gems.)
         try MockProject(type: "Library").do {

         // [_Workaround: This should eventually just do “validate”._]
         try Workspace.command.execute(with: ["refresh", "scripts"])
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
         try Workspace.command.execute(with: ["refresh", "resources"])
         #if !os(Linux)
         try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
         try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
         #endif
         }
         }

         XCTAssertErrorFree { // Failures here when inside Xcode are irrelevant. (Xcode bypasses shell login scripts necessary to find Jazzy and other Ruby gems.)
         try MockProject(type: "Application").do {

         // [_Workaround: This should eventually just do “validate”._]
         try Workspace.command.execute(with: ["refresh", "scripts"])
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
         try Workspace.command.execute(with: ["refresh", "resources"])
         #if !os(Linux)
         try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
         try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
         #endif
         }
         }

         XCTAssertErrorFree { // Failures here when inside Xcode are irrelevant. (Xcode bypasses shell login scripts necessary to find Jazzy and other Ruby gems.)
         try MockProject(type: "Executable").do {

         // [_Workaround: This should eventually just do “validate”._]
         try Workspace.command.execute(with: ["refresh", "scripts"])
         try Workspace.command.execute(with: ["refresh", "read‐me"])
         try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
         try Workspace.command.execute(with: ["refresh", "resources"])
         #if !os(Linux)
         try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
         try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
         #endif
         }
         }
         */
    }

    static var allTests: [(String, (APITests) -> () throws -> Void)] {
        return [
            ("testCheckForUpdates", testCheckForUpdates),
            ("testConfiguration", testConfiguration),
            ("testDocumentation", testDocumentation),
            ("testReadMe", testReadMe),
            ("testResources", testResources),
            ("testScripts", testScripts),
            ("testWorkflow", testWorkflow)
        ]
    }
}
