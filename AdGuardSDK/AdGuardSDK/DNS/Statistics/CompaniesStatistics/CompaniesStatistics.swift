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

import Foundation

public protocol CompaniesStatisticsProtocol: AnyObject {
    func getCompaniesStatistics(for period: StatisticsPeriod) throws -> [CompaniesStatisticsRecord]
}

final public class CompaniesStatistics: CompaniesStatisticsProtocol {

    private let activityStatistics: ActivityStatisticsProtocol
    private let dnsTrackersProvider: DnsTrackersProviderProtocol

    init(activityStatistics: ActivityStatisticsProtocol, dnsTrackersProvider: DnsTrackersProviderProtocol) {
        self.activityStatistics = activityStatistics
        self.dnsTrackersProvider = dnsTrackersProvider
    }

    /// Returns companies records sorted by requests number
    /// - Complexity: O(*n* + *n* log *n*), where *n* is the number of unique domains in DNS query log for the specified `period`
    public func getCompaniesStatistics(for period: StatisticsPeriod) throws -> [CompaniesStatisticsRecord] {
        let domainsRecords = try activityStatistics.getDomains(for: period)
        var countersByCompany: [String: CompaniesStatisticsRecord] = [:]

        domainsRecords.forEach { domainRecord in
            let company: String
            let tracker: DnsTracker?
            if let foundTracker = dnsTrackersProvider.getTracker(by: domainRecord.domain) {
                company = foundTracker.name
                tracker = foundTracker
            } else {
                company = domainRecord.domain
                tracker = nil
            }
            let companyStatisticsRecord = CompaniesStatisticsRecord(
                company: company,
                tracker: tracker,
                counters: domainRecord.counters,
                domains: Set([domainRecord.domain])
            )
    
            if let existingCompanyStatisticsRecord = countersByCompany[company] {
                countersByCompany[company] = existingCompanyStatisticsRecord + companyStatisticsRecord
            } else {
                countersByCompany[company] = companyStatisticsRecord
            }
        }

        return countersByCompany.values.sorted(by: { $0.counters.requests > $1.counters.requests })
    }
}
