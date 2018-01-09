
import SDGCommandLine

class CommandLineProofreadingReporter {
    
    // MARK: - Static Properties
    
    static let `default` = CommandLineProofreadingReporter()
    
    // MARK: - Initialization
    
    init() {
        
    }
    
    // MARK: - ProofreadingReporter
    
    func report(violation: StyleViolation, to output: inout Command.Output) {
        
        // [_Warning: Needs updating and testing once build succeeds again._]
    }
}
