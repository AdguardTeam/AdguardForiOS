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

protocol IBackgroundFetchPerformer: AnyObject {
    var fetchCompletion: ((UIBackgroundFetchResult) -> Void)? { get set }
    var isBackground: Bool { get }
//    var fetchState: BackgroundFetchState { get set }
    
    func antibanerUpdateFinished(result: UpdateResult)
    func invalidateAntibannerIfNeeded()
    func setBackgroundStatusToDefault()
    func performFetch(with completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
}

enum UpdateResult: UInt {
    case updateNotStarted,
         updateStarted,
         updateNewData,
         updateFailed,
         updateNoData
    
    var stringValue: String {
        switch self {
        case .updateNotStarted:
            return "updateNotStarted"
        case .updateStarted:
            return "updateStarted"
        case .updateNewData:
            return "updateNewData"
        case .updateFailed:
            return "updateFailed"
        case .updateNoData:
            return "updateNoData"
        }
    }
}

// Perform background fetches, update dns filters, safari filters and content blockers
final class BackgroundFetchPerformer: IBackgroundFetchPerformer {
    //MARK: - Properties
    private let resources: AESharedResourcesProtocol
    private let configuration: ConfigurationService
    private let vpnManager: VpnManagerProtocol
    private let antibanner: AESAntibannerProtocol
    private let complexProtection: ComplexProtectionServiceProtocol
    private let dnsFiltersService: DnsFiltersServiceProtocol
    private let networking: ACNNetworking

    private var downloadCompletion: (() -> Void)?
    
    private var antibanerUpdateResult: UpdateResult?
    private var blockingSubscriptionsUpdateResult: UpdateResult?
        
    private let workingQueue = DispatchQueue(label: "BackgroundFetchPerformer-queue")
    
    private var shouldUpdateFilters: Bool {
        if !resources.wifiOnlyUpdates {
            return true
        }
        
        let reachability = Reachability.forInternetConnection()
        let reachable = reachability?.isReachableViaWiFi() ?? false
        if !reachable {
            DDLogInfo("(BackgroundFetchPerformer) App settings permit updates only over WiFi.")
        }
        return reachable
    }
    
    var fetchCompletion: ((UIBackgroundFetchResult) -> Void)?

    var isBackground: Bool {
        return (fetchCompletion != nil) || (downloadCompletion != nil)
    }
    
    //MARK: - Init
    init(resources: AESharedResourcesProtocol,
         configuration: ConfigurationService,
         vpnManager: VpnManagerProtocol,
         antibanner: AESAntibannerProtocol,
         complexProtection: ComplexProtectionServiceProtocol,
         dnsFiltersService: DnsFiltersServiceProtocol,
         networking: ACNNetworking) {
        
        self.resources = resources
        self.configuration = configuration
        self.vpnManager = vpnManager
        self.antibanner = antibanner
        self.complexProtection = complexProtection
        self.dnsFiltersService = dnsFiltersService
        self.networking = networking
    }
    
    //MARK: - IBackgroundFetchPerformer methods
    
    func antibanerUpdateFinished(result: UpdateResult) {
        DDLogInfo("(BackgroundFetchPerformer) antibanerUpdateFinished with result: \(result.stringValue)")
        self.antibanerUpdateResult = result
        
        updateDnsFiltersIfNeeded { [weak self] in
            self?.updateFinished()
        }
    }
    
    func invalidateAntibannerIfNeeded() {
        if shouldUpdateFilters {
            let _ = invalidateAntibanner(fromUI: false, interactive: true)
        }
    }
    
    func setBackgroundStatusToDefault() {
        fetchCompletion = nil
        downloadCompletion = nil
    }
    
    func performFetch(with completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        DDLogInfo("(BackgroundFetchPerformer) application perform Fetch.")
        
        if fetchCompletion != nil {
            // In this case we receive fetch event when previous event still not processed.
            DDLogInfo("(BackgroundFetchPerformer) Previous Fetch still not processed.")
            
            // handle new completion handler
            fetchCompletion = completionHandler
            
            return
        }
        
        let checkResult = shouldUpdateFilters
        
        //Entry point for updating of the filters
        fetchCompletion = completionHandler
    }
    
    //MARK: - Private methods
    
    private func invalidateAntibanner(fromUI: Bool, interactive: Bool) -> Bool {
        workingQueue.sync {
            guard let lastCheck = resources.sharedDefaults().object(forKey: AEDefaultsCheckFiltersLastDate) as? NSDate else { return false }
            if fromUI || (lastCheck.timeIntervalSinceNow * -1.0) >= FiltersUpdatesConstants.checkFiltersUpdatesPeriod {
                
                if fromUI {
                    DDLogInfo("(BackgroundFetchPerformer) Update process started from UI.")
                } else {
                    DDLogInfo("(BackgroundFetchPerformer) Update process started by timer.")
                }
                
                var result = false;
                
                antibanner.beginTransaction()
                DDLogInfo("(BackgroundFetchPerformer) Begin of the Update Transaction from - invalidateAntibanner.")
                
                result = antibanner.startUpdatingForced(fromUI, interactive: interactive)
                
                if !result {
                    DDLogInfo("(BackgroundFetchPerformer) Update process did not start because antibanner.startUpdatingForced return false.")
                    antibanner.rollbackTransaction()
                    DDLogInfo("(BackgroundFetchPerformer) Rollback of the Update Transaction from ASAntibannerDidntStartUpdateNotification.")
                }
                
                return result
            }
            
            DDLogInfo("(BackgroundFetchPerformer) Update process NOT started by timer. Time period from previous update too small.")
            
            antibanerUpdateFinished(result: .updateFailed)
            
            return false
        }
    }
    
    private func updateFinished() {
        
        DDLogInfo("(BackgroundFetchPerformer) updateFinished")
        
        if self.antibanerUpdateResult == .updateStarted || self.blockingSubscriptionsUpdateResult == .updateStarted {
            return
        }
        
        let result: UIBackgroundFetchResult!
        
        if self.antibanerUpdateResult == .updateNewData || self.blockingSubscriptionsUpdateResult == .updateNewData {
            result = .newData
        } else if self.antibanerUpdateResult == .updateNoData && self.blockingSubscriptionsUpdateResult == .updateNoData {
            result = .noData
        } else {
            result = .failed
        }
        
        self.callCompletionHandler(result: result)
    }
    
    private func callCompletionHandler(result: UIBackgroundFetchResult) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.fetchCompletion != nil {
                DDLogInfo("(BackgroundFetchPerformer - Background Fetch) Call fetch Completion. With result: \(UpdateResult(rawValue: result.rawValue)?.stringValue ?? "nil")")
                self.fetchCompletion?(result)
                self.fetchCompletion = nil
            } else if self.downloadCompletion != nil {
                DDLogInfo("(BackgroundFetchPerformer - Background update downloads) Call Completion.")
                self.downloadCompletion?()
                self.downloadCompletion = nil
            }
        }
    }
    
    //MARK: - Update tunnel
    private func updateDnsFiltersIfNeeded( callback: @escaping ()->Void) {
        let lastCheckTime = resources.lastDnsFiltersUpdateTime ?? Date(timeIntervalSince1970: 0)
        let interval = Date().timeIntervalSince(lastCheckTime)
        let checkResult = shouldUpdateFilters
        if !dnsFiltersService.filtersAreUpdating
            && Int(interval) > Int(FiltersUpdatesConstants.dnsFiltersCheckLimit)
            && configuration.proStatus
            && checkResult {
            resources.lastDnsFiltersUpdateTime = Date()
            
            DDLogInfo("(BackgroundFetchPerformer) updateDnsFiltersIfNeeded - update dns filters")
            dnsFiltersService.updateFilters(networking: networking) { [weak self] in
                
                DDLogInfo("(BackgroundFetchPerformer) updateDnsFiltersIfNeeded - dns filters are updeted")
                self?.updateTunnelSettingsIfAppropriate {
                    callback()
                }
            }
        }
        else {
            DDLogInfo("(BackgroundFetchPerformer) updateDnsFiltersIfNeeded - not all conditions are met")
            callback()
        }
    }
    /**
     Do not update VPN configuration if:
     1. System protection is disabled
     2. DNS implementation is native
     3. Application is in background state (we are not sure if VPN configuration is active)
     */
    
    private func updateTunnelSettingsIfAppropriate(callback: @escaping ()->Void ) {
        vpnManager.getConfigurationStatus { [weak self] (status) in
            guard let self = self else { return }
            if self.complexProtection.systemProtectionEnabled, self.resources.dnsImplementation == .vpn, status.configurationIsActive, self.dnsFiltersService.enabledFiltersCount > 0 {
                self.vpnManager.updateSettings { _ in
                    callback()
                }
            }
            else {
                callback()
            }
        }
    }
}
