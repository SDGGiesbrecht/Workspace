// Continuous Integration.swift
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

struct ContinuousIntegration {
    
    static func refreshContinuousIntegrationConfiguration() {
        
        let travisConfigurationPath = RelativePath(".travis.yml")
        
        var travisConfiguration: File
        if Repository.trackedFiles.contains(travisConfigurationPath) {
            travisConfiguration = require() { try Repository.read(file: travisConfigurationPath) }
        } else {
            travisConfiguration = File(path: travisConfigurationPath, contents: "")
        }
        
        let managementWarning = File.managmentWarning(section: false, documentation: .continuousIntegration)
        let managementComment = FileType.yaml.syntax.comment(contents: managementWarning)
        
        let updatedLines: [String] = [
            "", // Last line of header
            "", // Empty first line
            managementComment,
            "",
            "language: generic",
            "matrix:",
            "  include:",
            "    - os: osx",
            "      osx_image: xcode8.2",
            "    - os: linux",
            "      dist: trusty",
            "      env: SWIFT_VERSION=3.0.2",
            "script: \u{22}eval \u{2F}\u{22}$(curl -sL https://gist.githubusercontent.com/kylef/5c0475ff02b7c7671d2a/raw/9f442512a46d7a2af7b850d65a7e9bd31edfb09b/swiftenv-install.sh)\u{2F}\u{22}; bash ./Refresh\u{2F}\u{2F}\u{2F} Workspace\\u{2F}\u{2F}\u{2F} \u{2F}\u{2F}(macOS\u{2F}\u{2F}).command; bash ./Validate\u{2F}\u{2F}\u{2F} Changes\u{2F}\u{2F}\u{2F} \u{2F}\u{2F}(macOS\u{2F}\u{2F}).command\u{22}",
            "", // Empty last line
            ]
        
        let newBody = join(lines: updatedLines)
        if travisConfiguration.body ≠ newBody {
            travisConfiguration.body = newBody
            require() { try Repository.write(file: travisConfiguration) }
        }
    }
    
}
