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
    
    case testOption = "Test Option"
    case testLongOption = "Test Long Option"
    
    // MARK: - Properties
    
    var key: String {
        return rawValue
    }
    
    var defaultValue: String {
        switch self {
        case .automaticallyTakeOnNewResponsibilites:
            return Configuration.falseOptionValue
        case .testOption:
            return "Default Value"
        case .testLongOption:
            return "Default\nValue"
        }
    }
    
    static let automaticResponsibilityDocumentationPage = DocumentationLink.responsibilities
    static let automaticRepsonsibilities: [Option: (automaticValue: String, documentationPage: DocumentationLink)] = [
        //.testOption: (automaticValue: "Test Value", documentationPage: DocumentationLink.setUp),
        //.testOption: (automaticValue: "Test\nLong\nValue", documentationPage: DocumentationLink.setUp),
    ]
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        return key
    }
}
