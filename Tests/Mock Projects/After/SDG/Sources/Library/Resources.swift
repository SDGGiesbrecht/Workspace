

import Foundation

internal enum Resources {}

extension Resources {
    enum Namespace {
        static let dataResource = Data(base64Encoded: "")!
    }
    static let textResource = String(data: Data(base64Encoded: "SGVsbG8sIHdvcmxkIQ==")!, encoding: String.Encoding.utf8)!

}
