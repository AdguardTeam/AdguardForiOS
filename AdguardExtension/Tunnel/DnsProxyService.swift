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
    
    func start(upstreams: [String], listenAddr: String, bootstrapDns: String, fallback: String, serverName: String, maxQueues: Int) -> Bool
    func stop(callback:@escaping ()->Void)
    func resolve(dnsRequest:Data, callback:  @escaping (_ dnsResponse: Data?)->Void);
}

class DnsProxyService : NSObject, DnsProxyServiceProtocol {
    
    // set it to 2000 to make sure we will quickly fallback if needed
    private let timeout = 2000
    private var proxy: MobileDNSProxy?
    private var queues: [DispatchQueue] = []
    private var lastQueue = 0
    private var queued = 0
    private let dnsRecordsWriter: DnsLogRecordsWriterProtocol;
    
    private let workingQueue = DispatchQueue(label: "dns proxy service working queue")
    private var stopped = true
    
    var resolveGroup = DispatchGroup()
    
    @objc
    init(logWriter: DnsLogRecordsWriterProtocol) {
        DDLogInfo("(DnsProxyService) initializing")
        dnsRecordsWriter = logWriter
        
        super.init()
        
        var error: NSError?
        MobileConfigureLogger(true, "", DnsProxyLogWriter(), &error)
        MobileConfigureDNSRequestProcessedListener(dnsRecordsWriter)
        
        if error != nil {
            DDLogError("(DnsProxyService) - configure logger error: \(error!.localizedDescription)")
        }
    }
    
    @objc func start(upstreams: [String], listenAddr: String, bootstrapDns: String, fallback: String, serverName: String, maxQueues: Int) -> Bool {
        
        queues.removeAll()
        
        for i in 0..<maxQueues {
            queues.append(DispatchQueue(label: "Dns Proxy resolve queue \(i)"))
        }
        
        var result = true
        
        workingQueue.sync {
            
            dnsRecordsWriter.server = serverName
            
            DDLogInfo("(DnsProxyService) start with upstreams: \(upstreams) listen at: \(listenAddr) bootstrap: \(bootstrapDns) fallback: \(fallback)")
            let upstreamsStr = upstreams.joined(separator: "\n")
            
            guard let config = MobileConfig() else {
                DDLogError("(DnsProxyService) start Error - can not create MobileConfig ")
                result = false
                return
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
                result = false
                return
            }
            
            proxy.config = config
            
            do{
                try proxy.start()
            }
            catch{
                DDLogError("(DnsProxyService) Error on start proxy: \(error) ")
                result = false
                return
            }
            
            self.proxy = proxy
            stopped = false
        }
        
        return result
    }
    
    @objc func stop(callback:@escaping ()->Void) {
        DDLogInfo("(DnsProxyService) - stop")
        
        workingQueue.async { [weak self] in
            
            DDLogInfo("(DnsProxyService) - queue size is \(self?.queued ?? 0)")
            self?.stopped = true

            // wait until already started tasks will be ended
            self?.resolveGroup.wait()
            
            do {
                try self?.proxy?.stop()
                self?.proxy = nil
            }
            catch {
                DDLogError("(DnsProxyService) Error on stop proxy: \(error) ")
            }
            
            DispatchQueue.main.async {
                callback()
            }
        }
        
        return
    }
    
    @objc func resolve(dnsRequest: Data, callback: @escaping (Data?) -> Void) {
        
        workingQueue.async { [weak self] in
            guard let sSelf = self else {return}
            
            if sSelf.stopped {
                DispatchQueue.main.async {
                    callback(nil)
                }
                return
            }
            
            sSelf.resolveGroup.enter()
            
            sSelf.lastQueue = (sSelf.lastQueue + 1) % sSelf.queues.count
            sSelf.queued += 1
            let queue = sSelf.queues[sSelf.lastQueue]

            queue.async {
                defer {
                    sSelf.resolveGroup.leave()
                    sSelf.queued -= 1
                }
                
                do {
                    if sSelf.stopped {
                        callback(nil)
                    }
                    else {
                        let dnsResponse = try sSelf.proxy?.resolve(dnsRequest)
                        callback(dnsResponse)
                    }
                }
                catch {
                    DDLogError("(DnsProxyService) resolve error: \(error) ")
                    DDLogInfo("(DnsProxyService) - queue size is \(sSelf.queued)")
                }
            }
        }
    }
}
