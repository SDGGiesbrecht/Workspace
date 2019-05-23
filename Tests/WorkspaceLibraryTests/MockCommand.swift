
import WSGeneralTestImports

import SDGCommandLine

let mockCommand = Command(
    name: UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "do‐something"
        }
    }),
    description: UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishCanada:
            return "does something."
        }
    }),
    directArguments: [],
    options: [],
    execution: { _, _, _ in })
