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

public enum CommonError: Error, CustomDebugStringConvertible {
    case missingSelf
    case missingData
    case missingFile(filename: String)
    case error(message: String)

    public var debugDescription: String {
        switch self {
        case .missingSelf: return "self object is nil"
        case .missingData: return "The required data is missing"
        case .missingFile(filename: let fileName): return "The file with name=\(fileName) is missing"
        case .error(let message): return message
        }
    }
}
