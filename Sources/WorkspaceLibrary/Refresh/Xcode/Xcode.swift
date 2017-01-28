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
    
    static func sdkRoot(for operatingSystem: OperatingSystem) -> String {
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
    
    static func deploymentTarget(for operatingSystem: OperatingSystem) -> String {
        switch operatingSystem {
        case .macOS:
            return "10.12"
        case .iOS:
            return "10.2"
        case .watchOS:
            return "3.1"
        case .tvOS:
            return "10.1"
        case .linux:
            fatalError(message: ["Xcode cannot handle Linux targets."])
        }
    }
    
    static func refreshXcodeProjects() {
        
        for operatingSystem in OperatingSystem.all.filter({ $0.buildsOnMacOS ∧ $0.isSupportedByProject }) {
            
            let path = RelativePath("\(Configuration.projectName) (\(operatingSystem)).xcodeproj")
            
            force() { try Repository.delete(path) }
            requireBash(["swift", "package", "generate-xcodeproj", "--output", path.string, "--enable-code-coverage", ])
            
            print("A")
            var file = require() { try File(at: path.subfolderOrFile("project.pbxproj")) }
            
            // Tailor for operating system
            
            print("B")
            let toolchainPath = "/usr/lib/swift/"
            print("C")
            file.contents = file.contents.replacingOccurrences(of: toolchainPath + sdkRoot(for: .macOS), with: toolchainPath + sdkRoot(for: operatingSystem))
            print("D")
            
            let deploymentTargetKey = "_DEPLOYMENT_TARGET"
            print("E")
            file.contents = file.contents.replacingOccurrences(of: deploymentTargetPrefix(for: .macOS) + deploymentTargetKey, with: deploymentTargetPrefix(for: operatingSystem) + deploymentTargetKey)
            print("F")
            file.contents.replaceContentsOfEveryPair(of: (deploymentTargetKey + " = ", ";"), with: deploymentTarget(for: operatingSystem))
            print("G")
            
            file.contents.replaceContentsOfEveryPair(of: ("SDKROOT = ", ";"), with: sdkRoot(for: operatingSystem))
            print("H")
            
            require() { try file.write() }
            print("I")
        }
    }
}
