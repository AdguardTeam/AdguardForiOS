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
import DnsAdGuardSDK

/// View model for DnsRequestDetailsContainerController
final class DnsRequestDetailsViewModel {

    let logRecord: DnsLogRecord

    private let helper: DnsLogRecordHelper
    private let dnsFilters: DnsProtectionFiltersProtocol

    init (logRecord: DnsLogRecord, helper: DnsLogRecordHelper, dnsFilters: DnsProtectionFiltersProtocol) {
        self.logRecord = logRecord
        self.helper = helper
        self.dnsFilters = dnsFilters
    }

    func addDomainToAllowlist(_ domain: String) throws {
        try helper.addDomainToAllowlist(domain)
        logRecord.userFilterStatus = helper.getUserFilterStatusForDomain(logRecord.event.domain)
    }

    func addDomainToUserRules(_ domain: String) throws {
        try helper.addDomainToUserRules(domain)
        logRecord.userFilterStatus = helper.getUserFilterStatusForDomain(logRecord.event.domain)
    }

    func addEditedBlocklistRule(_ blocklistRule: String) throws {
        try helper.addEditedBlocklistRule(blocklistRule)
        logRecord.userFilterStatus = helper.getUserFilterStatusForDomain(logRecord.event.domain)
    }

    func removeFromAllowlist() throws {
        try helper.removeDomainFromAllowlist(logRecord.event.domain)
        logRecord.userFilterStatus = helper.getUserFilterStatusForDomain(logRecord.event.domain)
    }

    func removeFromUserRules() throws {
        try helper.removeDomainFromUserRules(logRecord.event.domain)
        logRecord.userFilterStatus = helper.getUserFilterStatusForDomain(logRecord.event.domain)
    }

    func getMatchedFilters() -> String? {
        if logRecord.event.filterListIds.isEmpty {
            return nil
        }

        let filters = logRecord.event.filterListIds.compactMap { filterId -> String? in

            if filterId == dnsFilters.allowlistFilterId {
                return String.localizedString("allowlist_title")
            }
            else if filterId == dnsFilters.blocklistFilterId {
                return String.localizedString("dns_blacklist_title")
            }

            let filter = dnsFilters.filters.first { $0.filterId == filterId }
            return filter?.name
        }

        return filters.joined(separator: ",")
    }
}
