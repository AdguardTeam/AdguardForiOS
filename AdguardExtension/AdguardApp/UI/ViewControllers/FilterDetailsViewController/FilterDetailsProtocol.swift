/**
       This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
       Copyright © Adguard Software Limited. All rights reserved.

       Adguard for iOS is free software: you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation, either version 3 of the License, or
       (at your option) any later version.

       Adguard for iOS is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.

       You should have received a copy of the GNU General Public License
       along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

import SafariAdGuardSDK
import DnsAdGuardSDK

protocol FilterDetailsProtocol {
    var filterName: String { get }
    var description: String? { get }
    var filterId: Int { get }
    var groupId: Int? { get } // DNS filters do not have groups, so it can be nil
    var isEnabled: Bool { get }
    var rulesCount: Int { get }
    var homepage: String? { get }
    var filterDownloadPage: String? { get }
    var version: String? { get }
    var lastUpdateDate: Date? { get }
    var tags: [ExtendedFiltersMeta.Tag] { get }
    var editable: Bool { get }
    var removable: Bool { get }
}

// MARK: - SafariGroup.Filter + FilterDetailsProtocol

extension SafariGroup.Filter: FilterDetailsProtocol {
    var filterName: String { self.name ?? "" }
    var groupId: Int? { self.group.groupId }
    var homepage: String? { self.homePage }
}

// MARK: - DnsFilter + FilterDetailsProtocol

extension DnsAdGuardSDK.DnsFilter: FilterDetailsProtocol {
    var filterName: String { self.name ?? "" }
    var groupId: Int? { nil }
    var homepage: String? { self.homePage }
    var tags: [ExtendedFiltersMeta.Tag] { [] }
    var editable: Bool { true }
    var removable: Bool { true }
}
