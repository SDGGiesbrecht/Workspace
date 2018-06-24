/*
 Copyright.swift

 This source file is part of the Workspace open source project.
 https://github.com/SDGGiesbrecht/Workspace#workspace

 Copyright ©2018 Jeremy David Giesbrecht and the Workspace project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import WSGeneralImports

public func copyright(fromText text: String) -> StrictString {

    var oldStartDate: String?
    for symbol in ["©", "(C)", "(c)"] {
        for space in ["", " "] {
            if let range = text.scalars.firstMatch(for: (symbol + space).scalars)?.range {
                var numberEnd = range.upperBound
                text.scalars.advance(&numberEnd, over: RepetitionPattern(ConditionalPattern({ $0 ∈ CharacterSet.decimalDigits })))
                let number = text.scalars[range.upperBound ..< numberEnd]
                if number.count == 4 {
                    oldStartDate = String(number)
                    break
                }
            }
        }
    }
    let currentDate = Date()
    let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
    let currentYear = "\(calendar.component(.year, from: currentDate))"
    let copyrightStart = oldStartDate ?? currentYear

    var copyright = "©"
    if currentYear == copyrightStart {
        copyright.append(currentYear)
    } else {
        copyright.append(copyrightStart + "–" + currentYear)
    }

    return StrictString(copyright)
}
