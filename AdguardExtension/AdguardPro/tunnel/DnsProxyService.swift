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
import Mobile

class DnsProxyLogWriter: NSObject, MobileLogWriterProtocol {
    func write(_ message: String!) {
        if message != nil {
            DDLogInfo("(DnsProxy) \(message!)")
        }
    }
}

@objc
protocol DnsProxyServiceProtocol : NSObjectProtocol {
    
    func start(upstreams: [String], listenAddr: String, bootstrapDns: String, fallback: String, maxQueues: Int, serverName: String) -> Bool
    func stop()
    func resolve(dnsRequest:Data, callback:  @escaping (_ dnsResponse: Data)->Void);
}

class DnsProxyService : NSObject, DnsProxyServiceProtocol {
    
    private let timeout = 5000
    private var proxy: MobileDNSProxy?
    private var queues: [DispatchQueue] = []
    private var lastQueue = 0
    let dnsRecordsWriter: DnsLogRecordsWriter;
    let resources: APSharedResources
    
    @objc
    init(resources: APSharedResources) {
        self.resources = resources
        dnsRecordsWriter = DnsLogRecordsWriter(resources: resources)
        
        super.init()
        
        var error: NSError?
        MobileConfigureLogger(true, "", DnsProxyLogWriter(), &error)
        MobileConfigureDNSRequestProcessedListener(dnsRecordsWriter)
        
        if error != nil {
            DDLogError("(DnsProxyService) - configure logger error: \(error!.localizedDescription)")
        }
    }
    
    @objc func start(upstreams: [String], listenAddr: String, bootstrapDns: String, fallback: String, maxQueues: Int, serverName: String) -> Bool {
        
        queues.removeAll()
        for i in 0..<maxQueues {
            queues.append(DispatchQueue(label: "Dns Proxy resolve queue \(i)"))
        }
        
        dnsRecordsWriter.server = serverName
        
        DDLogInfo("(DnsProxyService) start with upstrams: \(upstreams) listen at: \(listenAddr) bootstrap: \(bootstrapDns) fallback: \(fallback)")
        let upstreamsStr = upstreams.joined(separator: "\n")
        
        guard let config = MobileConfig() else {
            DDLogError("(DnsProxyService) start Error - can not create MobileConfig ")
            return false
        }
        
        config.listenAddr = listenAddr
        config.listenPort = 0
        config.bootstrapDNS = bootstrapDns
        config.fallbacks = fallback
        config.upstreams = upstreamsStr
        config.timeout = timeout
        config.systemResolvers = bootstrapDns
        config.detectDNS64Prefix = true
        
        guard let proxy = MobileDNSProxy() else {
            DDLogError("(DnsProxyService) start Error - can not create MobileDNSProxy ")
            return false
        }
        
        proxy.config = config
        
        do{
            try proxy.start()
        }
        catch{
            DDLogError("(DnsProxyService) Error on start proxy: \(error) ")
            return false
        }
        
        self.proxy = proxy
        
        return true
    }
    
    @objc func stop() {
        DDLogInfo("(DnsProxyService) - stop")
        do {
            try self.proxy?.stop()
        }
        catch {
            DDLogError("(DnsProxyService) Error on stop proxy: \(error) ")
        }
        
        return
    }
    
    @objc func resolve(dnsRequest: Data, callback: @escaping (Data) -> Void) {
        
        lastQueue = (lastQueue + 1) % queues.count
        let queue = queues[lastQueue]
        queue.async {
            do {
                let dnsResponse = try self.proxy!.resolve(dnsRequest)
                callback(dnsResponse)
            }
            catch {
                DDLogError("(DnsProxy) resolve error: \(error) ")
            }
        }
    }
}
