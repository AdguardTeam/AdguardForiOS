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
    var domains = Set<String>()
    let company: String?
    let key: String
    var requests: Int
    var encrypted: Int
    
    init(company: String?, key: String, requests: Int, encrypted: Int) {
        self.company = company
        self.key = key
        self.requests = requests
        self.encrypted = encrypted
    }
}

struct CompaniesInfo {
    let mostRequested: [CompanyRequestsRecord]
    let companiesNumber: Int
}

protocol ActivityStatisticsModelProtocol {
}

class ActivityStatisticsModel: ActivityStatisticsModelProtocol {
    
    private let activityStatisticsService: ActivityStatisticsServiceProtocol
    private let dnsTrackersService: DnsTrackerServiceProtocol
    private let domainsParserService: DomainsParserServiceProtocol
    
    private let workingQueue = DispatchQueue(label: "ActivityStatisticsModel queue", qos: .userInitiated)
    
    init(activityStatisticsService: ActivityStatisticsServiceProtocol, dnsTrackersService: DnsTrackerServiceProtocol, domainsParserService: DomainsParserServiceProtocol) {
        self.activityStatisticsService = activityStatisticsService
        self.dnsTrackersService = dnsTrackersService
        self.domainsParserService = domainsParserService
    }
}
