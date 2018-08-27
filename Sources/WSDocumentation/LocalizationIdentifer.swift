
import WSProject

extension LocalizationIdentifier {

    internal var directoryName: StrictString {
        return icon ?? StrictString(code)
    }
}
