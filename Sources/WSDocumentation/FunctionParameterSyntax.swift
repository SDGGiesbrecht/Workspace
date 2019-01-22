
import SDGSwiftSource

extension FunctionParameterSyntax {

    internal var parameterName: String {
        return secondName?.text ?? firstName?.text ?? "" // @exempt(from: tests) One of the two should exist.
    }
}
