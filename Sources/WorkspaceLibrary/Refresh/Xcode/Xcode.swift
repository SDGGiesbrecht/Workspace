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
    
    static func toolchainSubdirectory(for operatingSystem: OperatingSystem) -> String {
        switch operatingSystem {
        case .macOS:
            return "macosx"
        case .iOS:
            return "iphoneos"
        case .watchOS:
            return "watchos"
        case .tvOS:
            return "appletvos"
        case .linux:
            fatalError(message: ["Xcode cannot handle Linux targets."])
        }
    }
    
    static func deploymentTargetPrefix(for operatingSystem: OperatingSystem) -> String {
        switch operatingSystem {
        case .macOS:
            return "MACOSX"
        case .iOS:
            return "IPHONEOS"
        case .watchOS:
            return "WATCHOS"
        case .tvOS:
            return "TVOS"
        case .linux:
            fatalError(message: ["Xcode cannot handle Linux targets."])
        }
    }
    
    static func refreshXcodeProjects() {
        
        for operatingSystem in OperatingSystem.all.filter({ $0.buildsOnMacOS ∧ $0.isSupportedByProject }) {
            
            let path = RelativePath("\(Configuration.projectName) (\(operatingSystem)).xcodeproj")
            
            force() { try Repository.delete(path) }
            requireBash(["swift", "package", "generate-xcodeproj", "--output", path.string, "--enable-code-coverage", ])
            
            var file = require() { try File(at: path.subfolderOrFile("project.pbxproj")) }
            var source = file.contents
            
            // Tailor for operating system
            
            let toolchainPath = "/usr/lib/swift/"
            source = source.replacingOccurrences(of: toolchainPath + toolchainSubdirectory(for: .macOS), with: toolchainPath + toolchainSubdirectory(for: operatingSystem))
            
            let deploymentTargetKey = "_DEPLOYMENT_TARGET"
            source = source.replacingOccurrences(of: deploymentTargetPrefix(for: .macOS) + deploymentTargetKey, with: deploymentTargetPrefix(for: operatingSystem) + deploymentTargetKey)
            
            file.contents = source
            require() { try file.write() }
        }
    }
}
