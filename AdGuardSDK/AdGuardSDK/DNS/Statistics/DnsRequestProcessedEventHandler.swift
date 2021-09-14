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

protocol DnsRequestProcessedEventHandlerProtocol: AnyObject {
    /// Accepts event object from DNS-libs and adds it to different statistics
    func handle(event: AGDnsRequestProcessedEventWrapper)
}

/// This object is used in Tunnel to save statistics data obtained from DNS-libs
final class DnsRequestProcessedEventHandler: DnsRequestProcessedEventHandlerProtocol {
    
    // Variable to reveal the upstream that provided the answer
    private let upstreamById: [Int: DnsProxyUpstream]
    
    private let eventQueue = DispatchQueue(label: "DnsAdGuardSDK.DnsRequestProcessedEventHandler.eventQueue", qos: .background)
    
    /* Services */
    private let dnsLibsRulesProvider: DnsLibsRulesProviderProtocol
    private let activityStatistics: ActivityStatisticsProtocol
    private let chartStatistics: ChartStatisticsProtocol
    private let dnsLogStatistics: DnsLogStatisticsProtocol
    
    init(
        upstreamById: [Int: DnsProxyUpstream],
        dnsLibsRulesProvider: DnsLibsRulesProviderProtocol,
        activityStatistics: ActivityStatisticsProtocol,
        chartStatistics: ChartStatisticsProtocol,
        dnsLogStatistics: DnsLogStatisticsProtocol
    ) {
        self.upstreamById = upstreamById
        self.dnsLibsRulesProvider = dnsLibsRulesProvider
        self.activityStatistics = activityStatistics
        self.chartStatistics = chartStatistics
        self.dnsLogStatistics = dnsLogStatistics
    }
    
    deinit {
        eventQueue.sync {
            Logger.logInfo("(DnsRequestProcessedEventHandler) - deinit; Flush to db")
        }
    }
    
    // TODO: - Add some tests
    func handle(event: AGDnsRequestProcessedEventWrapper) {
        eventQueue.async { [weak self] in
            guard let self = self, event.error == nil else {
                Logger.logError("(DnsRequestProcessedEventHandler) - handleEvent; Error: \(event.error ?? "Missing self")")
                return
            }
            
            guard let upstreamId = event.upstreamId, let activeDnsUpstream = self.upstreamById[upstreamId] else {
                Logger.logError("(DnsRequestProcessedEventHandler) - handleEvent; event.upstreamId is nil")
                return
            }
            
            let dnsFiltersIds = self.dnsLibsRulesProvider.enabledDnsFiltersIds
            let processedEvent = DnsRequestProcessedEvent(event: event, upstream: activeDnsUpstream.dnsUpstreamInfo, dnsFiltersIds: dnsFiltersIds)
            
            // Add to statistics
            self.activityStatistics.process(record: processedEvent.activityRecord)
            self.chartStatistics.process(record: processedEvent.chartStatisticsRecord)
            self.dnsLogStatistics.process(event: processedEvent)
        }
    }
}
