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

import DnsAdGuardSDK

struct CompanyRequestsRecord {
    let domains: Set<String>
    let company: String
    let requests: Int
    let encrypted: Int
}

struct CompaniesInfo {
    let mostRequested: [CompanyRequestsRecord]
    let companiesNumber: Int
}

protocol ActivityStatisticsModelProtocol: AnyObject {
    var period: StatisticsPeriod { get set }
    var counters: CountersStatisticsRecord { get }

    func getCompanies(for type: StatisticsPeriod, _ completion: @escaping (_ info: CompaniesInfo) -> Void)
}

final class ActivityStatisticsModel: ActivityStatisticsModelProtocol {

    private let dnsTrackers: DnsTrackersProviderProtocol
    private let domainParserService: DomainParserServiceProtocol
    private let activityStatistics: ActivityStatisticsProtocol
    private let companiesStatistics: CompaniesStatistics

    private let workingQueue = DispatchQueue(label: "ActivityStatisticsModel queue", qos: .userInitiated)

    var period: StatisticsPeriod = .all

    var counters: CountersStatisticsRecord {
        return (try? activityStatistics.getCounters(for: period)) ?? CountersStatisticsRecord.emptyRecord()
    }

    init(
        dnsTrackers: DnsTrackersProviderProtocol,
        domainParserService: DomainParserServiceProtocol,
        activityStatistics: ActivityStatisticsProtocol,
        companiesStatistics: CompaniesStatistics
    ) {
        self.dnsTrackers = dnsTrackers
        self.domainParserService = domainParserService
        self.activityStatistics = activityStatistics
        self.companiesStatistics = companiesStatistics
    }

    func getCompanies(for type: StatisticsPeriod, _ completion: @escaping (_ info: CompaniesInfo) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else { return }

            guard let statistics = try? self.companiesStatistics.getCompaniesStatistics(for: type) else {
                let info = CompaniesInfo(mostRequested: [], companiesNumber: 0)
                completion(info)
                return
            }
            let records: [CompanyRequestsRecord] = statistics.map {
                return CompanyRequestsRecord(
                    domains: $0.domains,
                    company: $0.company,
                    requests: $0.counters.requests,
                    encrypted: $0.counters.encrypted
                )
            }
            let info = CompaniesInfo(mostRequested: records, companiesNumber: records.count)
            completion(info)
        }
    }
}
