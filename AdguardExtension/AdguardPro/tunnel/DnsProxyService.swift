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

protocol DnsProxyServiceProtocol : NSObjectProtocol {
    
    func start(upstreams: [String], listenAddr: String, listenPort: Int, bootstrapDns: String, fallback: String) -> Bool
    func stop()
}

class DnsProxyService : NSObject, DnsProxyServiceProtocol {
    
    private let timeout = 5000
    private var proxy: MobileDNSProxy?
    
    override init() {
        super.init()
        
        var error: NSError?
        MobileConfigureLogger(false, "", DnsProxyLogWriter(), &error)
        
        if error != nil {
            DDLogError("(DnsProxyService) - configure logger error: \(error!.localizedDescription)")
        }
    }
    
    @objc func start(upstreams: [String], listenAddr: String, listenPort: Int, bootstrapDns: String, fallback: String) -> Bool {
        
        DDLogInfo("(DnsProxyService) start with upstrams: \(upstreams) listen at: \(listenAddr):\(listenPort) bootstrap: \(bootstrapDns) fallback: \(fallback)")
        let upstreamsStr = upstreams.joined(separator: "\n")
        
        guard let config = MobileConfig() else {
            DDLogError("(DnsProxyService) start Error - can not create MobileConfig ")
            return false
        }
        
        let appLogsUrl = APSharedResources.sharedAppLogsURL()
        let logsUrl = URL(string: (appLogsUrl?.absoluteString.dropLast().appending(".dnsproxy.txt"))!)
        
        do {
            try " ".write(to: logsUrl!, atomically: true, encoding: .utf8)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        config.listenAddr = listenAddr
        config.listenPort = listenPort
        config.bootstrapDNS = bootstrapDns
        config.fallbacks = fallback
        config.upstreams = upstreamsStr
        config.timeout = timeout
        
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
}
