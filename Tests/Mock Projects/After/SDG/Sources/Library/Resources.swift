

import Foundation

internal enum Resources {}

extension Resources {
    static let textResource = String(data: Data(base64Encoded: "SGVsbG8sIHdvcmxkIQ==")!, encoding: String.Encoding.utf8)!

}
