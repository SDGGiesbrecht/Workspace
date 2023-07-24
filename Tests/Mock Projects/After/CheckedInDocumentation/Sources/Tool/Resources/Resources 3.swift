

import Foundation

extension Resources {
  #if os(WASI)
    static var namespaced: String {
      return String(data: Data(([] as [[UInt8]]).lazy.joined()), encoding: String.Encoding.utf8)!
    }
  #else
    static var namespaced: String {
      return String(
        data: try! Data(
          contentsOf: moduleBundle.url(forResource: "Namespaced", withExtension: "txt")!,
          options: [.mappedIfSafe]
        ),
        encoding: String.Encoding.utf8
      )!
    }
  #endif
}
