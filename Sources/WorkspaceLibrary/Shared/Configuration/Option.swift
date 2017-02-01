// Option.swift
//
// This source file is part of the Workspace open source project.
//
// Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.
//
// Soli Deo gloria
//
// Licensed under the Apache License, Version 2.0
// See http://www.apache.org/licenses/LICENSE-2.0 for licence information.

enum Option: String, CustomStringConvertible {
    
    // MARK: - Initialization
    
    init?(key: String) {
        self.init(rawValue: key)
    }
    
    // MARK: - Cases
    
    case automaticallyTakeOnNewResponsibilites = "Automatically Take On New Responsibilities"
    
    case supportMacOS = "Support macOS"
    case supportLinux = "Support Linux"
    case supportIOS = "Support iOS"
    case supportWatchOS = "Support watchOS"
    case supportTVOS = "Support tvOS"
    
    case manageContinuousIntegration = "Manage Continuous Integration"
    
    case manageFileHeaders = "Manage File Headers"
    case fileHeader = "File Header"
    case author = "Author"
    
    case manageXcode = "Manage Xcode"
    
    case ignoreFileTypes = "Ignore File Types"
    
    // Testing Workspace
    case nestedTest = "Nested Test"
    case testOption = "Test Option"
    case testLongOption = "Test Long Option"
    
    static let allPublic: [Option] = [
        .automaticallyTakeOnNewResponsibilites,

        .ignoreFileTypes,
        
        .supportMacOS,
        .supportLinux,
        .supportIOS,
        .supportWatchOS,
        .supportTVOS,
        
        .manageContinuousIntegration,
        
        .manageFileHeaders,
        .fileHeader,
        .author,
        
        .manageXcode,
        
        .ignoreFileTypes,
    ]
    
    // MARK: - Properties
    
    var key: String {
        return rawValue
    }
    
    var defaultValue: String {
        switch self {
        case .automaticallyTakeOnNewResponsibilites:
            return Configuration.falseOptionValue
            
        case .supportMacOS:
            return Configuration.trueOptionValue
        case .supportLinux:
            return Configuration.trueOptionValue
        case .supportIOS:
            return Configuration.trueOptionValue
        case .supportWatchOS:
            return Configuration.trueOptionValue
        case .supportTVOS:
            return Configuration.trueOptionValue
            
        case .manageContinuousIntegration:
            return Configuration.falseOptionValue
            
        case .manageFileHeaders:
            return Configuration.falseOptionValue
        case .fileHeader:
            var defaultHeader: [String] = [
                "[_Filename_]",
                "",
                "This source file is part of the [_Project_] open source project.",
                "",
                ]
            if Configuration.optionIsDefined(.author) {
                defaultHeader.append("Copyright [_Copyright_] [_Author_] and the [_Project_] project contributors.")
            } else {
                defaultHeader.append("Copyright [_Copyright_] the [_Project_] project contributors.")
            }
            defaultHeader.append(contentsOf: [
                "",
                "[_Licence Information_]",
                ])
            return join(lines: defaultHeader)
        case .author:
            return "John Doe"
            
        case .manageXcode:
            return Configuration.falseOptionValue
            
        case .ignoreFileTypes:
            return ""
            
            // Tests
        case .nestedTest:
            return "False"
        case .testOption:
            return "Default Value"
        case .testLongOption:
            return "Default\nValue"
        }
    }
    
    static let automaticResponsibilityDocumentationPage = DocumentationLink.responsibilities
    static let automaticRepsonsibilities: [(option: Option, automaticValue: String, documentationPage: DocumentationLink)] = [
        (.manageContinuousIntegration, automaticValue: Configuration.trueOptionValue, DocumentationLink.continuousIntegration),
        (.manageFileHeaders, automaticValue: Configuration.trueOptionValue, DocumentationLink.fileHeaders),
        (.manageXcode, automaticValue: Configuration.trueOptionValue, DocumentationLink.xcode),
    ]
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return key
    }
}
