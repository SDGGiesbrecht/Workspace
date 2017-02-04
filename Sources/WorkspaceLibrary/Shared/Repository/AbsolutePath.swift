/*
 AbsolutePath.swift

 This source file is part of the Workspace open source project.

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

struct AbsolutePath: ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByStringLiteral, ExpressibleByUnicodeScalarLiteral, Path {
    
    // MARK: - Initialization
    
    init(_ string: String) {
        self.string = string
    }
    
    // MARK: - Properties
    
    var string: String
    
    // MARK: - ExpressibleByExtendedGraphemeClusterLiteral
    
    init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterType) {
        self.init(value)
    }
    
    // MARK: - ExpressibleByStringLiteral
    
    init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    // MARK: - ExpressibleByUnicodeScalarLiteral
    
    init(unicodeScalarLiteral value: UnicodeScalarType) {
        self.init(value)
    }
}
