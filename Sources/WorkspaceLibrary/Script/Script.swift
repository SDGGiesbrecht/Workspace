/*
 Script.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone
import SDGCommandLine

enum Script : Int, IterableEnumeration {

    // MARK: - Cases

    case refreshMacOS
    case refreshLinux
    case validateMacOS
    case validateLinux

    // MARK: - Properties

    private var template: StrictString {
        let result: String
        switch self {
        case .refreshMacOS:
            result = Resources.Scripts.refreshMacOS
        case .refreshLinux:
            result = Resources.Scripts.refreshLinux
        case .validateMacOS:
            result = Resources.Scripts.validateMacOS
        case .validateLinux:
            result = Resources.Scripts.validateLinux
        }
        return StrictString(result)
    }
    
    private var fileName: StrictString {
        switch self {
        case .refreshMacOS:
            return "Refresh (macOS).command"
        case .refreshLinux:
            return "Refresh (Linux).sh"
        case .validateMacOS:
            return "Validate (macOS).command"
        case .validateLinux:
            return "Validate (Linux).sh"
        }
    }
    
    private var isRelevantOnCurrentDevice: Bool {
        switch self {
        case .refreshMacOS, .validateMacOS:
            #if os(macOS)
                return true
            #elseif os(Linux)
                return true // Linux scripts use the macOS ones internally.
            #endif
        case .refreshLinux, .validateLinux:
            #if os(macOS)
                return false
            #elseif os(Linux)
                return true
            #endif
        }
    }
    
    private var isCheckedIn: Bool {
        switch self {
        case .refreshMacOS, .refreshLinux:
            return true
        case .validateMacOS, .validateLinux:
            return false
        }
    }
    
    // MARK: - Refreshing
    
    static func refreshRelevantScripts(for project: PackageRepository, output: inout Command.Output) throws {
        
        for script in cases where script.isRelevantOnCurrentDevice ∨ script.isCheckedIn {
            var source = StrictString(script.template)
            
            
            var file = try PackageRepository.TextFile(possiblyAt: project.location.appendingPathComponent(String(script.fileName)), executable: true)
            file.contents = String(source)
            try file.writeChanges(for: project, output: &output)
        }
    }
}
