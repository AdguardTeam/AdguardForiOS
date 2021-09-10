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

struct DnsProxyUpstream {
    let upstream: String
    let isCrypto: Bool
}

protocol DnsProxyServiceProtocol {
    var upstreamsById: [Int: DnsProxyUpstream] { get }

    func start(upstreams: [String], bootstrapDns: [String], fallbacks: [String], serverName: String, filtersManager: DnsFiltersManagerProtocol , userFilterId:Int, whitelistFilterId:Int, ipv6Available: Bool, rulesBlockingMode: AGBlockingMode, hostsBlockingMode: AGBlockingMode, blockedResponseTtlSecs: Int, customBlockingIpv4: String?, customBlockingIpv6: String?, blockIpv6: Bool) -> Bool
    func stop(callback:@escaping ()->Void)
    func resolve(dnsRequest:Data, callback:  @escaping (_ dnsResponse: Data?)->Void);
}

class DnsProxyService : DnsProxyServiceProtocol {
    var upstreamsById: [Int : DnsProxyUpstream] = [:]

    // set it to 2000 to make sure we will quickly fallback if needed
    private let timeout = 2000

    private var nextUpstreamId: Int { upstreamsById.count }

    private let resolveQueue = DispatchQueue(label: "dns proxy resolve queue", attributes: [.concurrent])

    let events: AGDnsProxyEvents
    var agproxy: AGDnsProxy?
    
    let eventHandler: DnsRequestProcessedEventHandlerProtocol
    let dnsProvidersManager: DnsProvidersManagerProtocol
    
    init(eventHandler: DnsRequestProcessedEventHandlerProtocol, dnsProvidersManager: DnsProvidersManagerProtocol) {
        Logger.logInfo("(DnsProxyService) initializing")
        self.eventHandler = eventHandler
        self.dnsProvidersManager = dnsProvidersManager
        self.events = AGDnsProxyEvents()

        self.events.onRequestProcessed = { [weak self] (event) in
            if event != nil {
                self?.eventHandler.handle(event: AGDnsRequestProcessedEventWrapper(event: event!))
            }
        }
    }

    func start(upstreams: [String], bootstrapDns: [String], fallbacks: [String], serverName: String, filtersManager: DnsFiltersManagerProtocol , userFilterId:Int, whitelistFilterId:Int, ipv6Available: Bool, rulesBlockingMode: AGBlockingMode, hostsBlockingMode: AGBlockingMode, blockedResponseTtlSecs: Int, customBlockingIpv4: String?, customBlockingIpv6: String?, blockIpv6: Bool) -> Bool {
        resolveQueue.sync(flags: .barrier) {
            return self.startInternal(upstreams: upstreams, bootstrapDns: bootstrapDns, fallbacks: fallbacks, serverName: serverName, filtersManager: filtersManager, userFilterId: userFilterId, whitelistFilterId: whitelistFilterId, ipv6Available: ipv6Available, rulesBlockingMode: rulesBlockingMode, hostsBlockingMode: hostsBlockingMode, blockedResponseTtlSecs: blockedResponseTtlSecs, customBlockingIpv4: customBlockingIpv4, customBlockingIpv6: customBlockingIpv6, blockIpv6: blockIpv6)
        }
    }

    func stop(callback:@escaping ()->Void) {
        resolveQueue.sync(flags: .barrier) { [weak self] in
            Logger.logInfo("(DnsProxyService) - stop")
            self?.agproxy = nil
            self?.upstreamsById.removeAll()

            Logger.logInfo("(DnsProxyService) - stopped")

            callback()
        }
    }

    func resolve(dnsRequest: Data, callback: @escaping (Data?) -> Void) {
        resolveQueue.async { [weak self] in
            let reply = self?.agproxy?.handlePacket(dnsRequest)
            callback(reply)
        }
    }

    private func upstreamIsCrypto() -> Bool {
        return dnsProvidersManager.activeDnsServer.type != .dns
    }

    private func startInternal(upstreams: [String], bootstrapDns: [String], fallbacks: [String], serverName: String, filtersManager: DnsFiltersManagerProtocol , userFilterId:Int, whitelistFilterId:Int, ipv6Available: Bool, rulesBlockingMode: AGBlockingMode, hostsBlockingMode: AGBlockingMode, blockedResponseTtlSecs: Int, customBlockingIpv4: String?, customBlockingIpv6: String?, blockIpv6: Bool) -> Bool {

        let isCrypto = upstreamIsCrypto()
        let agUpstreams = upstreams.map {(upstream) -> AGDnsUpstream in
            let id = nextUpstreamId
            let dnsProxyUpstream = DnsProxyUpstream(upstream: upstream, isCrypto: isCrypto)
            upstreamsById[id] = dnsProxyUpstream

            return AGDnsUpstream(address: upstream, bootstrap: bootstrapDns, timeoutMs: timeout, serverIp: nil, id: id, outboundInterfaceName: nil)
        }

        /// If fallback is set to none than we set empty upstreams list
        let agFallbacks: [AGDnsUpstream]
        if fallbacks.first == "none" {
            agFallbacks = []
        } else {
            agFallbacks = fallbacks.map { (fallback) -> AGDnsUpstream in
                let id = nextUpstreamId
                let isCrypto = false
                let dnsProxyUpstream = DnsProxyUpstream(upstream: fallback, isCrypto: isCrypto)
                upstreamsById[id] = dnsProxyUpstream

                return AGDnsUpstream(address: fallback, bootstrap: bootstrapDns, timeoutMs: timeout, serverIp: nil, id: id, outboundInterfaceName: nil)
            }
        }

        let filters = filtersManager.getDnsLibsFilters()

        /**
         Detect ipv6 addresses,
         If address contains ":", than it is ipv6 address
         We need to use system DNS in dns64Settings variable, that's why we iterate through fallbacks variable
         */
        let ipv6Addresses = fallbacks.filter({ $0.contains(":") })

        let ipv6Upstreams = ipv6Addresses.map { (address) -> AGDnsUpstream in
            let id = nextUpstreamId
            let isCrypto = false
            let dnsProxyUpstream = DnsProxyUpstream(upstream: address, isCrypto: isCrypto)
            upstreamsById[id] = dnsProxyUpstream

            return AGDnsUpstream(address: address, bootstrap: bootstrapDns, timeoutMs: timeout, serverIp: nil, id: id, outboundInterfaceName: nil)
        }

        let agFilters = filters.compactMap { AGDnsFilterParams(id: Int($0.key), data: $0.value, inMemory: false) }

        let dns64Settings = AGDns64Settings(upstreams: ipv6Upstreams, maxTries: 2, waitTimeMs: timeout)
        let defaultConfig = AGDnsProxyConfig.getDefault()!
        let config = AGDnsProxyConfig(upstreams: agUpstreams,
                                      fallbacks: agFallbacks,
                                      fallbackDomains: defaultConfig.fallbackDomains,
                                      detectSearchDomains: defaultConfig.detectSearchDomains,
                                      filters: agFilters,
                                      blockedResponseTtlSecs: blockedResponseTtlSecs,
                                      dns64Settings: dns64Settings,
                                      listeners: nil,
                                      outboundProxy: defaultConfig.outboundProxy,
                                      ipv6Available: ipv6Available,
                                      blockIpv6: blockIpv6,
                                      adblockRulesBlockingMode: rulesBlockingMode,
                                      hostsRulesBlockingMode: hostsBlockingMode,
                                      customBlockingIpv4: customBlockingIpv4,
                                      customBlockingIpv6: customBlockingIpv6,
                                      dnsCacheSize: 128,
                                      optimisticCache: false,
                                      enableDNSSECOK: false,
                                      enableRetransmissionHandling: true,
                                      helperPath: nil)

        var error: NSError?
        agproxy = AGDnsProxy(config: config, handler: events, error: &error)
        if agproxy == nil && error != nil {
            Logger.logError("(DnsProxyService) can not start dns proxy - \(error!)")
        }
        else if error != nil {
            Logger.logInfo("(DnsProxyService) dns proxy started with error - \(error!)")
        }

        return agproxy != nil
    }
}
