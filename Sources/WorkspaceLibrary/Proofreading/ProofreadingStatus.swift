
import SDGCommandLine

class ProofreadingStatus {
    
    // MARK: - Initialization
    
    init(reporter: ProofreadingReporter) {
        self.reporter = reporter
    }
    
    // MARK: - Properties
    
    private let reporter: ProofreadingReporter
    private var passing: Bool = true
    
    // MARK: - Usage
    
    func report(violation: StyleViolation, to output: inout Command.Output) {
        passing = false
        reporter.report(violation: violation, to: &output)
    }
}
