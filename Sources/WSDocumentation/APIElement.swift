/*
 APIElement.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import SDGSwiftSource

extension APIElement {

    internal var fileName: StrictString {
        return Page.sanitize(fileName: StrictString(name))
    }

    internal var relativePagePath: String {
        get {
            return userInformation! as! String
        }
        set {
            userInformation = newValue
        }
    }
}
