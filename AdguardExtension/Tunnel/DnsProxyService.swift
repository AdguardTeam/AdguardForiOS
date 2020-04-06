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

@objc
protocol DnsProxyServiceProtocol : NSObjectProtocol {
    func start(upstreams: [String], bootstrapDns: [String], fallbacks: [String], serverName: String, filtersJson: String,  userFilterId:Int, whitelistFilterId:Int, ipv6Available: Bool) -> Bool
    func stop(callback:@escaping ()->Void)
    func resolve(dnsRequest:Data, callback:  @escaping (_ dnsResponse: Data?)->Void);
}

class DnsProxyService : NSObject, DnsProxyServiceProtocol {
    
    // set it to 2000 to make sure we will quickly fallback if needed
    private let timeout = 2000
    private let dnsRecordsWriter: DnsLogRecordsWriterProtocol
    private let resources: AESharedResourcesProtocol
    
    private let workingQueue = DispatchQueue(label: "dns proxy service working queue")
    private let resolveQueue = DispatchQueue(label: "dns proxy resolve queue", attributes: [.concurrent])
    
    let events: AGDnsProxyEvents
    
    @objc
    init(logWriter: DnsLogRecordsWriterProtocol, resources: AESharedResourcesProtocol) {
        DDLogInfo("(DnsProxyService) initializing")
        dnsRecordsWriter = logWriter
        self.resources = resources
        events = AGDnsProxyEvents()
        
        super.init()
        
        events.onRequestProcessed = { [weak self] (event) in
            if event != nil {
                self?.dnsRecordsWriter.handleEvent(event!)
            }
        }
    }
    
    var agproxy: AGDnsProxy?
    
    @objc func start(upstreams: [String], bootstrapDns: [String], fallbacks: [String], serverName: String, filtersJson: String, userFilterId:Int, whitelistFilterId:Int, ipv6Available: Bool) -> Bool {
                
        let agUpstreams = upstreams.map { (upstream) -> AGDnsUpstream in
            return AGDnsUpstream(address: upstream, bootstrap: bootstrapDns, timeoutMs: timeout, serverIp: nil)
        }
        
        let agFallbacks = fallbacks.map { (fallback) -> AGDnsUpstream in
            return AGDnsUpstream(address: fallback, bootstrap: bootstrapDns, timeoutMs: timeout, serverIp: nil)
        }
        
        let filterFiles = (try? JSONSerialization.jsonObject(with: filtersJson.data(using: .utf8)! , options: []) as? Array<[String:Any]>) ?? Array<Dictionary<String, Any>>()
        
        var filters = [NSNumber:String]()
        
        var otherFilterIds = [Int]()
        
        for filter in filterFiles {
            
            let identifier = filter["id"] as! Int
            let path = filter["path"] as! String
            
            if identifier != userFilterId && identifier != whitelistFilterId {
                otherFilterIds.append(identifier)
            }
            
            let numId = identifier as NSNumber
            
            filters[numId] = path
        }
        
        dnsRecordsWriter.userFilterId = userFilterId as NSNumber?
        dnsRecordsWriter.whitelistFilterId = whitelistFilterId as NSNumber?
        dnsRecordsWriter.otherFilterIds = otherFilterIds as [NSNumber]
        
        /**
         Detect ipv6 addresses,
         If address contains ":", than it is ipv6 address
         We need to use system DNS in dns64Settings variable, that's why we iterate through fallbacks variable
         */
        let ipv6Addresses = fallbacks.filter({ $0.contains(":") })
        
        let ipv6Upstreams = ipv6Addresses.map { (address) -> AGDnsUpstream in
            return AGDnsUpstream(address: address, bootstrap: bootstrapDns, timeoutMs: timeout, serverIp: nil)
        }
    
        let dns64Settings = AGDns64Settings(upstreams: ipv6Upstreams, maxTries: 2, waitTimeMs: timeout)
        let config = AGDnsProxyConfig(upstreams: agUpstreams,
                                      fallbacks: agFallbacks,
                                      filters: filters,
                                      blockedResponseTtlSecs: 2,
                                      dns64Settings: dns64Settings,
                                      listeners: nil,
                                      ipv6Available: ipv6Available,
                                      blockIpv6: false,
                                      blockingMode: .AGBM_DEFAULT,
                                      customBlockingIpv4: nil,
                                      customBlockingIpv6: nil,
                                      dnsCacheSize: 128)

        var error: NSError?
        agproxy = AGDnsProxy(config: config, handler: events, error: &error)
        resources.tunnelErrorCode = error?.code
        if agproxy == nil && error != nil {
            DDLogError("(DnsProxyService) can not start dns proxy - \(error!)")
        }
        else if error != nil {
            DDLogInfo("(DnsProxyService) dns proxy started with error - \(error!)")
        }
        
        return agproxy != nil
    }
    
    @objc func stop(callback:@escaping ()->Void) {
        DDLogInfo("(DnsProxyService) - stop")
        
        resolveQueue.sync { [weak self] in
            self?.workingQueue.sync { [weak self] in
                self?.agproxy = nil
            }
        }
        
        callback()
        
        return
    }
    
    @objc func resolve(dnsRequest: Data, callback: @escaping (Data?) -> Void) {
        
        resolveQueue.async { [weak self] in
            let reply = self?.agproxy?.handlePacket(dnsRequest)
            callback(reply)
        }
    }
}
