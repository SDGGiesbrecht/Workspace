/*
 LocalizationIdentifier.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WSGeneralImports

import WSProject

extension LocalizationIdentifier {

    internal var textDirection: TextDirection? {
        guard let supported = ContentLocalization(reasonableMatchFor: code) else {
            return nil
        }
        return supported.textDirection
    }
}
