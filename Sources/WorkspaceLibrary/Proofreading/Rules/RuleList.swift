
let rules: [Rule.Type] = [
    
    // ••••••• Deprecation •••••••
    // Temporary rules which help with updating Workspace by catching deprecated usage.
    DeprecatedLinuxDocumentation.self,
    
    // ••••••• Intentional •••••••
    // Warnings that are requested manually.
    MissingImplementation.self,
    
    // ••••••• Functionality •••••••
    // Rules which ensure development tools (Workspace, Xcode, etc) work as intended.
    CompatibilityCharacters.self,
    AutoindentResilience.self,
    Mark.self,
    
    // ••••••• Documentation •••••••
    // Rules which improve documentation quality.
    DocumentationOfExtensionConstraints.self,
    DocumentationOfCompilationConditions.self,
    SyntaxColouring.self,
    
    // ••••••• Unicode •••••••
    // Rules which catch poor usage inherited from ASCII limitations.
    
    // General
    QuotationMarks.self,
    HyphenMinus.self,
    // Logic
    NotEqual.self,
    Not.self,
    Conjunction.self,
    Disjunction.self,
    // Mathematics
    LessThanOrEqual.self,
    GreaterThanOrEqual.self,
    SubtractAndSet.self,
    Multiplication.self,
    MultiplyAndSet.self,
    Division.self,
    DivideAndSet.self,
    
    // ••••••• Code Style •••••••
    // Rules which enforce consistent source code style.
    ColonSpacing.self,
    CalloutCasing.self,
    ParametersStyle.self
]
