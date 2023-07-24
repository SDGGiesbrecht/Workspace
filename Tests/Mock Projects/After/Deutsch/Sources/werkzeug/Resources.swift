

import Foundation

enum Resources {}
typealias Ressourcen = Resources

extension Resources {
  #if !os(WASI)
    static let moduleBundle: Bundle = {
      let main = Bundle.main.executableURL?.resolvingSymlinksInPath().deletingLastPathComponent()
      let module = main?.appendingPathComponent("Deutsch_werkzeug.bundle")
      return module.flatMap({ Bundle(url: $0) }) ?? Bundle.module
    }()
  #endif

}
