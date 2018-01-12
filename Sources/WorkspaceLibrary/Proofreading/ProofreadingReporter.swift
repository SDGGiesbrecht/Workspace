
import SDGCommandLine

protocol ProofreadingReporter {

    func report(violation: StyleViolation, to output: inout Command.Output)
}
