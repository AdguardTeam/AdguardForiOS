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

protocol DnsRequestProcessedEventHandlerProtocol {
    /// Accepts event object from DNS-libs and adds it to different statistics
    func handle(event: AGDnsRequestProcessedEventWrapper)
}

/// This object is used in Tunnel to save statistics data obtained from DNS-libs
struct DnsRequestProcessedEventHandler: DnsRequestProcessedEventHandlerProtocol {
    
    private let eventQueue = DispatchQueue(label: "DnsAdGuardSDK.DnsRequestProcessedEventHandler.eventQueue", qos: .background)
    
    /* Services */
    private let providersManager: DnsProvidersManagerProtocol
    private let dnsLibsRulesProvider: DnsLibsRulesProviderProtocol
    private let activityStatistics: ActivityStatisticsProtocol
    private let chartStatistics: ChartStatisticsProtocol
    private let dnsLogStatistics: DnsLogStatisticsProtocol
    
    init(providersManager: DnsProvidersManagerProtocol,
         dnsLibsRulesProvider: DnsLibsRulesProviderProtocol,
         activityStatistics: ActivityStatisticsProtocol,
         chartStatistics: ChartStatisticsProtocol,
         dnsLogStatistics: DnsLogStatisticsProtocol) {
        self.providersManager = providersManager
        self.dnsLibsRulesProvider = dnsLibsRulesProvider
        self.activityStatistics = activityStatistics
        self.chartStatistics = chartStatistics
        self.dnsLogStatistics = dnsLogStatistics
    }
    
    func handle(event: AGDnsRequestProcessedEventWrapper) {
        eventQueue.sync {
            guard event.error == nil else {
                Logger.logError("(DnsRequestProcessedEventHandler) - handleEvent; Error: \(event.error!)")
                return
            }
            
            // TODO: - Upstream should be selected by event.upstreamId
            // FIXME: - Fix when DNS lib wrapper is done
            let activeDnsUpstreams = providersManager.activeDnsServer.upstreams.first!
            
            let dnsFiltersIds = dnsLibsRulesProvider.enabledDnsFiltersIds
            let processedEvent = DnsRequestProcessedEvent(event: event, upstream: activeDnsUpstreams, dnsFiltersIds: dnsFiltersIds)
            
            // Add to statistics
            activityStatistics.process(record: processedEvent.activityRecord)
            chartStatistics.process(record: processedEvent.chartStatisticsRecord)
            dnsLogStatistics.process(event: processedEvent)
        }
    }
}
