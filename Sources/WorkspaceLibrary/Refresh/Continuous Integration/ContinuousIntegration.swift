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
            travisConfiguration = require() { try File(at: travisConfigurationPath) }
        } else {
            travisConfiguration = File(newAt: travisConfigurationPath)
        }
        
        let managementWarning = File.managmentWarning(section: false, documentation: .continuousIntegration)
        let managementComment = FileType.yaml.syntax.comment(contents: managementWarning)
        
        let updatedLines: [String] = [
            managementComment,
            "",
            "language: generic",
            "matrix:",
            "  include:",
            "    - os: osx",
            "      osx_image: xcode8.2",
            "      script: bash ./Refresh\u{5C}\u{5C}\u{5C} Workspace\u{5C}\u{5C}\u{5C} \u{5C}\u{5C}(macOS\u{5C}\u{5C}).command; bash ./Validate\u{5C}\u{5C}\u{5C} Changes\u{5C}\u{5C}\u{5C} \u{5C}\u{5C}(macOS\u{5C}\u{5C}).command",
            "    - os: linux",
            "      dist: trusty",
            "      env: SWIFT_VERSION=3.0.2",
            "      script: \u{22}eval \u{5C}\u{22}$(curl -sL https://gist.githubusercontent.com/kylef/5c0475ff02b7c7671d2a/raw/9f442512a46d7a2af7b850d65a7e9bd31edfb09b/swiftenv-install.sh)\u{5C}\u{22}; bash ./Refresh\u{5C}\u{5C}\u{5C} Workspace\u{5C}\u{5C}\u{5C} \u{5C}\u{5C}(macOS\u{5C}\u{5C}).command; bash ./Validate\u{5C}\u{5C}\u{5C} Changes\u{5C}\u{5C}\u{5C} \u{5C}\u{5C}(macOS\u{5C}\u{5C}).command\u{22}",
            "    - os: osx",
            "      language: objective-c",
            "      before_script: bash ./Refresh\u{5C}\u{5C}\u{5C} Workspace\u{5C}\u{5C}\u{5C} \u{5C}\u{5C}(macOS\u{5C}\u{5C}).command",
            "      xcode_project: \(Configuration.projectName).xcodeproj",
            "      xcode_scheme: \(Configuration.projectName)",
            "      xcode_sdk: iphonesimulator10.2",
            ]
        
        let newBody = join(lines: updatedLines)
        travisConfiguration.body = newBody
        require() { try travisConfiguration.write() }
    }
    
}
