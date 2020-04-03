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

class CompanyRequestsRecord {
    let date: Date
    var domains = Set<String>()
    let company: String?
    let key: String
    var requests: Int
    var blocked: Int
    var savedData: Int
    
    init(date: Date, company: String?, key: String, requests: Int, blocked: Int, savedData: Int) {
        self.date = date
        self.company = company
        self.key = key
        self.requests = requests
        self.blocked = blocked
        self.savedData = savedData
    }
}

protocol ActivityStatisticsModelProtocol {
    func getCompanies(for type: ChartDateType, completion: @escaping (_ mostRequested: [CompanyRequestsRecord], _ mostBlocked: [CompanyRequestsRecord], _ companiesNumber: Int) -> ())
}

class ActivityStatisticsModel: ActivityStatisticsModelProtocol {
    
    private let activityStatisticsService: ActivityStatisticsServiceProtocol
    private let dnsTrackersService: DnsTrackerServiceProtocol
    private let domainsParserService: DomainsParserServiceProtocol
    
    init(activityStatisticsService: ActivityStatisticsServiceProtocol, dnsTrackersService: DnsTrackerServiceProtocol, domainsParserService: DomainsParserServiceProtocol) {
        self.activityStatisticsService = activityStatisticsService
        self.dnsTrackersService = dnsTrackersService
        self.domainsParserService = domainsParserService
    }
    
    func getCompanies(for type: ChartDateType, completion: @escaping (_ mostRequested: [CompanyRequestsRecord], _ mostBlocked: [CompanyRequestsRecord], _ companiesNumber: Int) -> ()) {
        activityStatisticsService.getRecords(by: type) {[weak self] (records) in
            var recordsByCompanies: [String : CompanyRequestsRecord] = [:]
            var companiesNumber = 0
            let parser = self?.domainsParserService.domainsParser
            
            for record in records {
                let company = self?.dnsTrackersService.getTrackerName(by: record.domain)
                let domain = parser?.parse(host: record.domain)?.domain ?? record.domain
                let key = company ?? domain
                
                if let existingRecord = recordsByCompanies[key] {
                    existingRecord.requests += record.requests
                    existingRecord.blocked += record.blocked
                    existingRecord.savedData += record.savedData
                    existingRecord.domains.insert(record.domain)
                } else {
                    let requestRecord = CompanyRequestsRecord(date: record.date, company: company, key: company ?? record.domain, requests: record.requests, blocked: record.blocked, savedData: record.savedData)
                    requestRecord.domains.insert(record.domain)
                    recordsByCompanies[key] = requestRecord
                    
                    if company != nil {
                        companiesNumber += 1
                    }
                }
            }
            
            let recordsArray = Array(recordsByCompanies.values)
            let mostRequested = recordsArray.sorted(by: {
                if $0.requests != $1.requests {
                    return $0.requests > $1.requests
                } else {
                    return $0.key < $1.key
                }
            })
            let mostBlocked = recordsArray.sorted(by: {
                if $0.blocked != $1.blocked {
                    return $0.blocked > $1.blocked
                } else {
                    return $0.key < $1.key
                }
            })
            
            completion(mostRequested, mostBlocked, companiesNumber)
        }
    }
}
