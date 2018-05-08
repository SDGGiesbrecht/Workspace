
import SDGSwift
import SDGSwiftPackageManager

import PackageModel

extension SDGSwift.Version {

    init(_ version: PackageModel.Version) {
        self.init(version.major, version.minor, version.patch)
    }
}
