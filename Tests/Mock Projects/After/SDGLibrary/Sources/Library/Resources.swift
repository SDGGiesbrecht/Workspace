// Header

import Foundation

internal enum Resources {}

extension Resources {
    enum Namespace {
        static let dataResource = Data(base64Encoded: "")!
    }
    static let _2001_01_01_NamedWithNumbers = String(data: Data(base64Encoded: "SGVsbG8sIHdvcmxkIQ==")!, encoding: String.Encoding.utf8)!
    static let _namedWithPunctuation = String(data: Data(base64Encoded: "SGVsbG8sIHdvcmxkIQ==")!, encoding: String.Encoding.utf8)!
    static let textResource = String(data: Data(base64Encoded: "SGVsbG8sIHdvcmxkIQ==")!, encoding: String.Encoding.utf8)!

}
