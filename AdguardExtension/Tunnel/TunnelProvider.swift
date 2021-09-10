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

import NetworkExtension
import DnsAdGuardSDK
import SafariAdGuardSDK
import Sentry

class TunnelProvider: PacketTunnelProvider {
    
    init() throws {
        // init logger
        let resources = AESharedResources()
        let debugLoggs = resources.isDebugLogs
        ACLLogger.singleton().initLogger(resources.sharedLogsURL())
        ACLLogger.singleton().logLevel = debugLoggs ? ACLLDebugLevel : ACLLDefaultLevel
        DDLogInfo("Init tunnel with loglevel: \(debugLoggs ? "DEBUG" : "NORMAL")")
        
        // start and configure Sentry
        SentrySDK.start { options in
            options.dsn = SentryConst.dsnUrl
            options.enableAutoSessionTracking = false
        }
        
        SentrySDK.configureScope { scope in
            scope.setTag(value: AGDnsProxy.libraryVersion(), key: "dnslibs.version")
            scope.setTag(value: debugLoggs ? "true" : "false" , key: "dnslibs.debuglogs")
        }
        
        let urlStorage = SharedStorageUrls()
        let filterStorageUrl = urlStorage.dnsFiltersFolderUrl
        let statisticsUrl = urlStorage.statisticsFolderUrl
        
        let currentLanguage = "\(ADLocales.lang() ?? "en")-\(ADLocales.region() ?? "US")"
        
        let configuration = DnsConfiguration(currentLanguage: currentLanguage,
                                             proStatus: true,
                                             dnsFilteringIsEnabled: resources.systemProtectionEnabled,
                                             dnsImplementation: resources.dnsImplementation,
                                             blocklistIsEnabled: true,
                                             allowlistIsEnabled: true,
                                             lowLevelConfiguration: LowLevelDnsConfiguration.fromResources(resources))
        
        try super.init(userDefaults: resources.sharedDefaults(), debugLoggs: debugLoggs, dnsConfiguration: configuration, filterStorageUrl: filterStorageUrl, statisticsDbContainerUrl: statisticsUrl)
    }

}
