/*
 ReportSection.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2017 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCornerstone

struct ReportSection {

    // MARK: - Initialization

    init(number: Int) {
        self.number = number
    }

    // MARK: - Properties

    let number: Int

    // MARK: - Usage

    var identifier: StrictString {
        return "§" + number.inDigits()
    }

    var anchor: StrictString {
        return " (" + identifier + ")"
    }

    var crossReference: UserFacingText<InterfaceLocalization, Void> {
        let identifier = self.identifier
        return UserFacingText({ (localization, _) in
            switch localization {
            case .englishCanada:
                #if os(macOS)
                    return " (See ⌘F “" + identifier + "”)"
                #elseif os(Linux)
                    return " (See Ctrl + F “" + identifier + "”)"
                #endif
            }
        })
    }
}
