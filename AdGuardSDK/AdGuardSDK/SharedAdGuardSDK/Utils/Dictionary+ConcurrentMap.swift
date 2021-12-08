//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import Foundation

public extension Dictionary {
    @inlinable func concurrentMap<T>(_ transform: @escaping (_ key: Key, _ value: Value) -> T) -> [T] {
        @Atomic var result: Array<T?> = []
        let keys = Array(keys)
        DispatchQueue.concurrentPerform(iterations: count) { idx in
            let key = keys[idx]
            let element = self[key]!
            let transformed = transform(key, element)
            _result.mutate {
                $0.append(transformed)
            }
        }
        return result.map { $0! }
    }
}
