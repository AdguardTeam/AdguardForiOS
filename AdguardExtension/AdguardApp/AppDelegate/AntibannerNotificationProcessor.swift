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

protocol IAntibannerNotificationProcessor {
    func subscribeToAntibannerNotifications()
}

final class AntibannerNotificationProcessor: IAntibannerNotificationProcessor {
    
    //MARK:  - Properties
    private var fetchProcessor: IAppDelegateFetchProcessor
    private var appDelegateWindow: UIWindow?
    
    private let antibanner: AESAntibannerProtocol
    private let contentBlockerService: ContentBlockerServiceProtocol
    private let resources: AESharedResourcesProtocol
    
    private var updatedFilters = [ASDFilterMetadata]()
    
    //MARK: - Init
    
    init(fetchProcessor: IAppDelegateFetchProcessor,
         appDelegateWindow: UIWindow?,
         antibanner: AESAntibannerProtocol,
         contentBlockerService: ContentBlockerServiceProtocol,
         resources: AESharedResourcesProtocol) {
        
        self.fetchProcessor = fetchProcessor
        self.appDelegateWindow = appDelegateWindow
        self.antibanner = antibanner
        self.contentBlockerService = contentBlockerService
        self.resources = resources
    }
    
    //MARK: - IAntibannerNotificationProcessor methods
    
    func subscribeToAntibannerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerFailuredUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerFinishedUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerStartedUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerDidntStartUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerUpdateFilterRules, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerUpdatePartCompleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerInstalled, object: nil)
    }
    
    
    //MARK: - Private methods
    @objc private func antibannerNotify(notification: Notification) {
        // Update filter rules
        if notification.name == .ASAntibannerUpdateFilterRules {
            if self.fetchProcessor.isBackground {
                DDLogInfo("(AntibannerNotificationProcessor) antibannerNotify. Skip in background")
                return
            }
            
            contentBlockerService.reloadJsons(backgroundUpdate: false) { [weak self] error in
                guard let self = self else { return }
                if let _ = error {
                    self.antibanner.rollbackTransaction()
                    DDLogInfo("(AntibannerNotificationProcessor) Rollback of the Update Transaction from ASAntibannerUpdateFilterRulesNotification.")
                    
                    self.updateFailuredNotify()
                    
                    DispatchQueue.main.async {
                        guard let nav = self.getNavigationController() else { return }
                        if let topViewController = nav.topViewController, UIApplication.shared.applicationState != .background {
                            ACSSystemUtils.showSimpleAlert(for: topViewController,
                                                           withTitle: ACLocalizedString("common_error_title", "(AEUISubscriptionController) Alert title. When converting rules process finished in foreground updating."),
                                                           message: ACLocalizedString("load_to_safari_error", "(AntibannerNotificationProcessor) Alert message. When converting rules process finished in foreground updating."))
                        }
                    }
                } else  {
                    // Success antibanner updated from backend
                    
                    self.resources.sharedDefaults().setValue(Date(), forKey: AEDefaultsCheckFiltersLastDate)
                    DDLogInfo("(AntibannerNotificationProcessor) End of the Update Transaction from ASAntibannerUpdateFilterRulesNotification.")
                    self.updateFinishedNotify(filtersUpdated: false)
                }
            }
        }
        // Update started
        else if notification.name == .ASAntibannerStartedUpdate {
            if !self.fetchProcessor.isBackground {
                // turn on network activity indicator
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.updateStartedNotify()
            }
        }
        // Update did not start
        else if notification.name == .ASAntibannerDidntStartUpdate {
            self.updateDidNotStartNotify()
            
            if antibanner.inTransaction() {
                antibanner.rollbackTransaction()
                DDLogInfo("(AntibannerNotificationProcessor) Rollback of the Update Transaction from ASAntibannerDidntStartUpdateNotification.")
            }
            // Special update case.
            self.fetchProcessor.fetchState = .notStarted
            self.fetchProcessor.antibanerUpdateFinished(result: .updateFailed)
        }
        // Update performed
        else if notification.name == .ASAntibannerFinishedUpdate {
            if self.fetchProcessor.isBackground {
                self.fetchProcessor.fetchState = .filtersupdated
                antibanner.endTransaction()
                self.fetchProcessor.antibanerUpdateFinished(result: .updateNewData)
                return
            }
            
            if let updatedFilters = notification.userInfo?[ASAntibannerUpdatedFiltersKey] as? [ASDFilterMetadata] {
                self.updatedFilters = updatedFilters
            }
            
            contentBlockerService.reloadJsons(backgroundUpdate: true) { [weak self] _ in
                guard let self = self else { return }
                if self.antibanner.inTransaction() {
                    // Success antibanner updated from backend
                    self.resources.sharedDefaults().setValue(Date(), forKey: AEDefaultsCheckFiltersLastDate)
                    self.antibanner.endTransaction()
                    DDLogInfo("(AntibannerNotificationProcessor) End of the Update Transaction from ASAntibannerFinishedUpdateNotification.")
                    self.updateFinishedNotify(filtersUpdated: true)
                }
                
                // Special update case (in background).
                self.fetchProcessor.antibanerUpdateFinished(result: .updateNewData)
            }
            
            // turn off network activity indicator
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        // Update failed
        else if notification.name == .ASAntibannerFailuredUpdate {
            
            if antibanner.inTransaction() {
                antibanner.rollbackTransaction()
                DDLogInfo("(AntibannerNotificationProcessor) Rollback of the Update Transaction from ASAntibannerFailuredUpdateNotification.")
            }
            
            self.updateFailuredNotify()
            
            // Special update case.
            self.fetchProcessor.fetchState = .notStarted
            self.fetchProcessor.antibanerUpdateFinished(result: .updateFailed)
            
            // turn off network activity indicator
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        } else if notification.name == .ASAntibannerUpdatePartCompleted {
            DDLogInfo("(AntibannerNotificationProcessor) Antibanner update PART notification.")
            
        } else if notification.name == .ASAntibannerInstalled {
            contentBlockerService.reloadJsons(backgroundUpdate: true) { _ in
                DDLogInfo("(AntibannerNotificationProcessor) content blocker reloaded after antibanner notification ASAntibannerInstalledNotification")
            }
        }
    }
    
    private func updateStartedNotify() {
        ACSSystemUtils.call {
            let appState = UIApplication.shared.applicationState
            DDLogInfo("(AntibannerNotificationProcessor) Started update process. AppState = \(appState.rawValue)")
            
            NotificationCenter.default.post(name: .appDelegateStartedUpdateNotification, object: self)
        }
    }
    
    private func updateDidNotStartNotify() {
        ACSSystemUtils.call { [weak self] in
            let appState = UIApplication.shared.applicationState
            DDLogInfo("(AntibannerNotificationProcessor) Did not started update process. AppState = \(appState.rawValue)")
            
            NotificationCenter.default.post(name: .appDelegateUpdateDidNotStartedNotification, object: self)
        }
    }
    
    private func updateFailuredNotify() {
        ACSSystemUtils.call { [weak self] in
            let appState = UIApplication.shared.applicationState
            DDLogInfo("(AntibannerNotificationProcessor) Failured update process. AppState = \(appState.rawValue)")
            
            NotificationCenter.default.post(name: .appDelegateFailuredUpdateNotification, object: self)
        }
    }
    
    private func updateFinishedNotify(filtersUpdated: Bool) {
        DDLogInfo("(AntibannerNotificationProcessor) Finished update process.")
        
        var metas = [ASDFilterMetadata]()
        
        if filtersUpdated {
            metas = updatedFilters
            updatedFilters.removeAll()
        }
        
        ACSSystemUtils.call { [weak self] in
            let appState = UIApplication.shared.applicationState
            DDLogInfo("(AntibannerNotificationProcessor) Finished update process, updated filters = \(metas.count). AppState = \(appState.rawValue)")
            
            let userInfo = [Notification.Name.appDelegateUpdatedFiltersKey: metas.count]
            NotificationCenter.default.post(name: .appDelegateFinishedUpdateNotification, object: self, userInfo: userInfo)
        }
    }
    
    
    private func getNavigationController() -> UINavigationController? {
        guard let nav = appDelegateWindow?.rootViewController as? UINavigationController else { return nil }
        return nav
    }
}

extension Notification.Name {
    static let appDelegateStartedUpdateNotification = Notification.Name("AppDelegateStartedUpdateNotification")
    static let appDelegateUpdateDidNotStartedNotification = Notification.Name("AppDelegateUpdateDidNotStartedNotification")
    static let appDelegateFinishedUpdateNotification = Notification.Name("AppDelegateFinishedUpdateNotification")
    static let appDelegateFailuredUpdateNotification = Notification.Name("AppDelegateFailuredUpdateNotification")
    static let appDelegateUpdatedFiltersKey = Notification.Name("AppDelegateUpdatedFiltersKey")
}

