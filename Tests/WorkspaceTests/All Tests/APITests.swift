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

import WorkspaceLibrary

class APITests : TestCase {

    func testCheckForUpdates() {
        XCTAssertErrorFree {
            try Workspace.command.execute(with: ["check‐for‐updates"])
        }
    }

    func testConfiguration() {
        XCTAssertThrowsError(containing: "Invalid") {
            let project = try MockProject()
            try project.do {
                try "Manage Continuous Integration: Maybe".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
            }
        }
        XCTAssertThrowsError(containing: "Invalid") {
            let project = try MockProject()
            try project.do {
                try "Project Type: Something\nManage Continuous Integration: True".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
            }
        }
    }

    func testContinuousIntegration() {

        // Inactive.
        XCTAssertErrorFree {
            let project = try MockProject()
            try project.do {
                let configuration = project.location.appendingPathComponent(".travis.yml")
                try "...".save(to: configuration)
                try "Manage Continuous Integration: False".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
                XCTAssertEqual(try String(from: configuration), "...")
            }
        }

        // Active.
        XCTAssertErrorFree {
            let project = try MockProject()
            try project.do {
                let configuration = project.location.appendingPathComponent(".travis.yml")
                try "...".save(to: configuration)
                try "Manage Continuous Integration: True\nGenerate Documentation: True".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
                XCTAssert(try String(from: configuration).contains("cache"))
            }
        }
        XCTAssertErrorFree {
            let project = try MockProject(type: "Application")
            try project.do {
                let configuration = project.location.appendingPathComponent(".travis.yml")
                try "...".save(to: configuration)
                try "Project Type: Application\nManage Continuous Integration: True\nGenerate Documentation: True".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
                XCTAssert(try String(from: configuration).contains("cache"))
            }
        }
        XCTAssertErrorFree {
            let project = try MockProject(type: "Executable")
            try project.do {
                let configuration = project.location.appendingPathComponent(".travis.yml")
                try "...".save(to: configuration)
                try "Project Type: Executable\nManage Continuous Integration: True\nGenerate Documentation: True".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                try Workspace.command.execute(with: ["refresh", "continuous‐integration"])
                XCTAssert(try String(from: configuration).contains("cache"))
            }
        }
    }

    func testDocumentation() {

        #if !os(Linux)
            XCTAssertErrorFree { // Failures here when inside Xcode are irrelevant. (Xcode bypasses shell login scripts necessary to find Jazzy and other Ruby gems.)
                let project = try MockProject(type: "Library")
                try project.do {
                    try "Repository URL: https://github.com/user/project\nAuthor: John Doe\nSupport macOS: False".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                    try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                    try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
                    try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
                }
            }

            XCTAssertErrorFree { // Failures here when inside Xcode are irrelevant. (Xcode bypasses shell login scripts necessary to find Jazzy and other Ruby gems.)
                let project = try MockProject(type: "Library")
                try project.do {
                    try "Documentation Copyright: ©0001 John Doe\nSupport macOS: False\nSupport iOS: False\nManage Read‐Me: True\nLocalizations: en".save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                    try [
                        "/// ...",
                        "infix operator ≠",
                        "/// ...",
                        "infix operator ¬",
                        "extension Bool {",
                        "    /// ...",
                        "    \u{70}ublic static func ≠(lhs: Bool, rhs: Bool) -> Bool {",
                        "        return true",
                        "    }",
                        "    /// ...",
                        "    \u{70}ublic static func ¬(lhs: Bool, rhs: Bool) -> Bool {",
                        "        return true",
                        "    }",
                        "    /// ...",
                        "    \u{70}ublic static func אבג() {}",
                        "}"
                        ].joined(separator: "\n").save(to: project.location.appendingPathComponent("Sources/MyProject/Unicode.swift"))
                    try Workspace.command.execute(with: ["refresh", "read‐me"])
                    try Shell.default.run(command: ["swift", "package", "generate\u{2D}xcodeproj"])
                    try Workspace.command.execute(with: ["validate", "documentation‐coverage"])
                    let page = try String(from: project.location.appendingPathComponent("docs/MyProject/Extensions/Bool.html"))
                    XCTAssert(¬page.contains("\u{22}err\u{22}"), "Failed to clean up Jazzy output.")
                    let index = try String(from: project.location.appendingPathComponent("docs/MyProject/index.html"))
                    XCTAssert(¬index.contains("Skip in Jazzy"), "Failed to remove read‐me–only content.")
                }
            }

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
    }

    func testReadMe() {
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
            let project = try MockProject()
            try project.do {

                try Resources.ReadMe.elaborateWorkspaceConfiguration.save(to: project.location.appendingPathComponent(".Workspace Configuration.txt"))
                try [
                    "// [\u{5F}Define Example: Read‐Me 🇨🇦EN_]", "doSomething()", "// [_End_]",
                    "// [\u{5F}Define Example: Read‐Me 🇩🇪DE_]", "...", "// [_End_]",
                    "// [\u{5F}Define Example: Read‐Me 🇫🇷FR_]", "...", "// [_End_]",
                    "// [\u{5F}Define Example: Read‐Me 🇬🇷ΕΛ_]", "...", "// [_End_]",
                    "// [\u{5F}Define Example: Read‐Me 🇮🇱עב_]", "...", "// [_End_]"
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
    }

    func testResources() {
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
    }

    func testScripts() {
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
    }

    func testWorkflow() {
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
    }

    static var allTests: [(String, (APITests) -> () throws -> Void)] {
        return [
            ("testCheckForUpdates", testCheckForUpdates),
            ("testConfiguration", testConfiguration),
            ("testContinuousIntegration", testContinuousIntegration),
            ("testDocumentation", testDocumentation),
            ("testReadMe", testReadMe),
            ("testResources", testResources),
            ("testScripts", testScripts),
            ("testWorkflow", testWorkflow)
        ]
    }
}
