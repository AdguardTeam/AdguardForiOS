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
    var encrypted: Int
    var elapsedSumm: Int
    
    init(date: Date, company: String?, key: String, requests: Int, encrypted: Int, elapsedSumm: Int) {
        self.date = date
        self.company = company
        self.key = key
        self.requests = requests
        self.encrypted = encrypted
        self.elapsedSumm = elapsedSumm
    }
}

struct CompaniesInfo {
    let mostRequested: [CompanyRequestsRecord]
    let mostEncrypted: [CompanyRequestsRecord]
    let companiesNumber: Int
}

protocol ActivityStatisticsModelProtocol {
    func getCompanies(for type: ChartDateType) -> CompaniesInfo
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
    
    func getCompanies(for type: ChartDateType) -> CompaniesInfo {
        
        let records = activityStatisticsService.getRecords(by: type)
        var recordsByCompanies: [String : CompanyRequestsRecord] = [:]
        var companiesNumber = 0
        let parser = domainsParserService.domainsParser
            
        for record in records {
            let company = dnsTrackersService.getTrackerInfo(by: record.domain)?.name
            let domain = parser?.parse(host: record.domain)?.domain ?? record.domain
            let key = company ?? domain
                
            if let existingRecord = recordsByCompanies[key] {
                existingRecord.requests += record.requests
                existingRecord.encrypted += record.encrypted
                existingRecord.elapsedSumm += record.elapsedSumm
                existingRecord.domains.insert(record.domain)
            } else {
                let requestRecord = CompanyRequestsRecord(date: record.date, company: company, key: company ?? record.domain, requests: record.requests, encrypted: record.encrypted, elapsedSumm: record.elapsedSumm)
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
        let mostEncrypted = recordsArray.sorted(by: {
            if $0.encrypted != $1.encrypted {
                return $0.encrypted > $1.encrypted
            } else {
                return $0.key < $1.key
            }
        })
            
        return CompaniesInfo(mostRequested: mostRequested, mostEncrypted: mostEncrypted, companiesNumber: companiesNumber)
    }
}
