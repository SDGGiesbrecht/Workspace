// XCode.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

import SDGLogic

struct Xcode {
    
    static func refreshXcodeProjects() {
        
        let path = RelativePath("\(Configuration.projectName).xcodeproj")
        force() { try Repository.delete(path) }
        requireBash(["swift", "package", "generate-xcodeproj", "--output", path.string, "--enable-code-coverage"])
        
        var file = require() { try File(at: path.subfolderOrFile("project.pbxproj")) }
        file.contents.replaceContentsOfEveryPair(of: ("LD_RUNPATH_SEARCH_PATHS = (", ");"), with: join(lines: [
            "",
            "$(inherited)",
            "@executable_path/Frameworks",
            "@loader_path/Frameworks",
            "@executable_path/../Frameworks",
            "@loader_path/../Frameworks",
            ].map({ "\u{22}\($0)\u{22}," })))
        
        require() { try file.write() }
    }
}
