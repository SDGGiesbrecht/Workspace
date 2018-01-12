
import SDGCommandLine

class CommandLineProofreadingReporter : ProofreadingReporter {

    // MARK: - Static Properties

    static let `default` = CommandLineProofreadingReporter()

    // MARK: - Initialization

    private init() {

    }

    // MARK: - ProofreadingReporter

    func report(violation: StyleViolation, to output: inout Command.Output) {

        // [_Warning: Needs updating and testing once build succeeds again._]
    }
}
