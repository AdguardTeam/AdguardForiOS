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

public struct CompaniesStatisticsRecord: Equatable {
    public let company: String // Company name that domain is attached to. If company was not found than it is domain
    public let tracker: DnsTracker? // DNS tracker information, associated with this company
    public let counters: CountersStatisticsRecord // Different counters for company
    public let domains: Set<String> // Set of domains related with company

    public static func +(left: CompaniesStatisticsRecord, right: CompaniesStatisticsRecord) -> CompaniesStatisticsRecord {
        return CompaniesStatisticsRecord(
            company: left.company,
            tracker: left.tracker,
            counters: left.counters + right.counters,
            domains: left.domains.union(right.domains)
        )
    }
}
