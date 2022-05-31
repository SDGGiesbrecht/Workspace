

import Foundation

internal enum Resources {}
internal typealias Ressourcen = Resources

extension Resources {
  private static let resource0: [UInt8] = [
    0x48, 0x65, 0x6C, 0x6C, 0x6F, 0x2C, 0x20,
    0x77, 0x6F, 0x72, 0x6C, 0x64, 0x21,
  ]
  internal static var resource: String {
    return String(
      data: Data(([resource0] as [[UInt8]]).lazy.joined()),
      encoding: String.Encoding.utf8
    )!
  }

}
