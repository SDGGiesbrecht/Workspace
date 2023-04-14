

import Foundation

extension Resources.Namespace {
  static var namespaced: String {
    return String(data: Data(([] as [[UInt8]]).lazy.joined()), encoding: String.Encoding.utf8)!
  }
}
