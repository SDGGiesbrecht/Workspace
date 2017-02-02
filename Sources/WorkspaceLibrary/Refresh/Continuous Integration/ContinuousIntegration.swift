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
    
    static let continuousIntegrationJobKey = "JOB"
    static let continuousIntegrationIOSJob = "iOS"
    static let continuousIntegrationWatchOSJob = "watchOS"
    static let continuousIntegrationTVOSJob = "tvOS"
    
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
        
        var updatedLines: [String] = [
            managementComment,
            "",
            "language: generic",
            "matrix:",
            "  include:",
            ]
        
        func runCommand(_ command: String) -> String {
            var escapedCommand = command.replacingOccurrences(of: "\u{5C}", with: "\u{5C}\u{5C}")
            escapedCommand = escapedCommand.replacingOccurrences(of: "\u{22}", with: "\u{5C}\u{22}")
            return "        - \u{22}\(escapedCommand)\u{22}"
        }
        
        func runWorkspaceScript(_ name: String) -> String {
            var file = "./\(name) (macOS).command"
            file = file.replacingOccurrences(of: " ", with: "\u{5C} ")
            file = file.replacingOccurrences(of: "(", with: "\u{5C}(")
            file = file.replacingOccurrences(of: ")", with: "\u{5C})")
            
            return runCommand("bash \(file)")
        }
        let runRefreshWorkspace = runWorkspaceScript("Refresh Workspace")
        let runValidateChanges = runWorkspaceScript("Validate Changes")
        
        if Configuration.supportMacOS ∨ Configuration.supportIOS ∨ Configuration.supportWatchOS ∨ Configuration.supportTVOS {
            
            updatedLines.append(contentsOf: [
                "    - os: osx",
                "      env:",
                "        - \(continuousIntegrationJobKey)=\u{22}macOS & Misc.\u{22}",
                "      osx_image: xcode8.2",
                "      script:",
                runRefreshWorkspace,
                runValidateChanges,
                ])
        }
        
        if Configuration.supportLinux {
            
            updatedLines.append(contentsOf: [
            "    - os: linux",
            "      dist: trusty",
            "      env:",
            "        - \(continuousIntegrationJobKey)=\u{22}Linux & Misc.\u{22}",
            "        - SWIFT_VERSION=3.0.2",
            "      script:",
            runCommand("eval \u{22}$(curl -sL https://gist.githubusercontent.com/kylef/5c0475ff02b7c7671d2a/raw/9f442512a46d7a2af7b850d65a7e9bd31edfb09b/swiftenv-install.sh)\u{22}"),
            runRefreshWorkspace,
            runValidateChanges,
            ])
        }
        
        func addPortableOSJob(name: String, sdk: String) {
            updatedLines.append(contentsOf: [
                "    - os: osx",
                "      env:",
                "        - \(continuousIntegrationJobKey)=\u{22}\(name)\u{22}",
                "      osx_image: xcode8.2",
                "      language: objective-c",
                "      xcode_sdk: \(sdk)",
                "      script:",
                runRefreshWorkspace,
                runValidateChanges,
                ])
        }
        
        if Configuration.supportIOS {
            
            addPortableOSJob(name: continuousIntegrationIOSJob, sdk: "iphonesimulator")
        }
        
        if Configuration.supportWatchOS {
            
            addPortableOSJob(name: continuousIntegrationWatchOSJob, sdk: "watchsimulator")
        }
        
        if Configuration.supportTVOS {
            
            addPortableOSJob(name: continuousIntegrationTVOSJob, sdk: "appletvsimulator")
        }
        
        let newBody = join(lines: updatedLines)
        travisConfiguration.body = newBody
        require() { try travisConfiguration.write() }
    }
    
}
