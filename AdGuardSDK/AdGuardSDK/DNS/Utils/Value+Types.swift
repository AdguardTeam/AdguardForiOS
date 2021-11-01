///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///

import Foundation
import SQLite

// MARK: - DnsUpstream + save/load from DB
extension DnsUpstream: Value {
    public static var declaredDatatype: String { Blob.declaredDatatype }

    public static func fromDatatypeValue(_ datatypeValue: Blob) -> Self {
        let decoder = JSONDecoder()
        let upstream = try! decoder.decode(DnsUpstream.self, from: Data.fromDatatypeValue(datatypeValue))
        return upstream
    }

    public var datatypeValue: Blob {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        return data.datatypeValue
    }
}

// MARK: - Array<Codable> + save/load from DB
extension Array: Value where Element: Codable {
    public static var declaredDatatype: String {
        return Blob.declaredDatatype
    }

    public static func fromDatatypeValue(_ datatypeValue: Blob) -> Self {
        let decoder = JSONDecoder()
        let array = try! decoder.decode(Self.self, from: Data.fromDatatypeValue(datatypeValue))
        return array
    }

    public var datatypeValue: Blob {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        return data.datatypeValue
    }
}

extension Array: Expressible where Element: Codable {
    public var expression: Expression<Void> {
        return Expression(value: self).expression
    }
}
