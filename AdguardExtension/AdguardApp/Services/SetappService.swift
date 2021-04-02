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
import Setapp

/**
 this service is responsible for managing the setapp license activation
 it minimizes calls to the setapp framework to prevent unnecessary requests to the setapp server
 */

protocol SetappServiceProtocol {
    /* starts setapp workflow if setapp license was activated */
    func start()
    
    /* open url if needed
        returns true if request is managed by setapp
     */
    func openUrl(_ url: URL, options: [UIApplication.OpenURLOptionsKey : Any])->Bool
}

class SetappService: SetappServiceProtocol, SetappManagerDelegate {
    
    private let purchaseService: PurchaseServiceProtocol
    private let resources: AESharedResourcesProtocol
    
    private let deviceLimitErrorCode = 1703
    private var started = false
    
    init(purchaseService: PurchaseServiceProtocol, resources: AESharedResourcesProtocol) {
        self.purchaseService = purchaseService
        self.resources = resources
        
        DDLogInfo("(SetappService) - init; setappUsed  = \(resources.setappUsed )")
        if resources.setappUsed {
            purchaseService.updateSetappState(subscription: SetappManager.shared.subscription)
        }
    }
    
    func start() {
        DDLogInfo("(SetappService) - starting Setapp; Current status = \(SetappManager.shared.subscription.description); setappUsed = \(resources.setappUsed)")
        if resources.setappUsed {
            startManager()
        }
    }
    
    func openUrl(_ url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if url.scheme == Bundle.main.bundleIdentifier {
            
            startManager()
            
            if SetappManager.shared.canOpen(url: url) {
                DDLogInfo("(SetappService) - Setapp can openUrl; url: \(url)")
                
                return SetappManager.shared.open(url: url, options: options) { [weak self] result in
                    switch result {
                    case .success(let subscription):
                        DDLogInfo("Successfully logged in with setapp, current subscription: \(subscription.description)")
                        self?.resources.setappUsed = true
                    case .failure(let error):
                        DDLogError("Error while logging in with setapp: \(error)")
                        if (error as NSError).code == self?.deviceLimitErrorCode {
                            NotificationCenter.default.post(Notification(name: .setappDeviceLimitReched))
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    // MARK: -- SetAppManagerDelegate
    
    func setappManager(_ manager: SetappManager, didUpdateSubscriptionTo newSetappSubscription: SetappSubscription) {
        DDLogInfo("(SetappService) setapp subscription changed")
        DDLogInfo("(SetappService) setapp new subscription is active: \(manager.subscription.isActive)")
        
        purchaseService.updateSetappState(subscription: manager.subscription)
        resources.setappUsed = true
    }
    
    // MARK: -- private methods
    
    private func startManager() {
        DDLogInfo("(SetappService) - startManager; start = \(started)")
        
        if started {
            return
        }
        
        SetappManager.shared.start(with: .default)
        SetappManager.logLevel = .debug
        SetappManager.shared.delegate = self
        
        SetappManager.setLogHandle { (message: String, logLevel: SetappLogLevel) in
            DDLogInfo("(Setapp) [\(logLevel)], \(message)")
        }
        
        started = true
    }
}

extension Notification.Name {
    static var setappDeviceLimitReched: Notification.Name { return .init(rawValue: "setappDeviceLimitReched") }
}
