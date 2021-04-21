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

protocol IBackgroundFetchNotificationHandler {}

final class BackgroundFetchNotificationHandler: IBackgroundFetchNotificationHandler {
    
    //MARK:  - Properties
    private weak var fetchPerformer: IBackgroundFetchPerformer?
    
    private let antibanner: AESAntibannerProtocol
    private let contentBlockerService: ContentBlockerServiceProtocol
    private let resources: AESharedResourcesProtocol
    
    private var updatedFilters = [ASDFilterMetadata]()
    
    //MARK: - Init
    
    init(fetchPerformer: IBackgroundFetchPerformer,
         antibanner: AESAntibannerProtocol,
         contentBlockerService: ContentBlockerServiceProtocol,
         resources: AESharedResourcesProtocol) {
        
        self.fetchPerformer = fetchPerformer
        self.antibanner = antibanner
        self.contentBlockerService = contentBlockerService
        self.resources = resources
        
//        subscribeToAntibannerNotifications()
    }
    
    //MARK: - Private methods
//    private func subscribeToAntibannerNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerFailuredUpdate, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerFinishedUpdate, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerStartedUpdate, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerDidntStartUpdate, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerUpdateFilterRules, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerUpdatePartCompleted, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: .ASAntibannerInstalled, object: nil)
//    }
    
//    @objc private func antibannerNotify(notification: Notification) {
//
//        switch notification.name {
//        case .ASAntibannerUpdateFilterRules:
//            // Update filter rules
//            antibannerUpdateFilterRules()
//        case .ASAntibannerStartedUpdate:
//            // Update started
//            antibannerStartedUpdate()
//        case .ASAntibannerDidntStartUpdate:
//            // Update did not start
//            antibannerDidntStartUpdate()
//        case .ASAntibannerFinishedUpdate:
//            // Update performed
//            antibannerFinishedUpdate(notification: notification)
//        case .ASAntibannerFailuredUpdate:
//            // Update failed
//            antibannerFailuredUpdate()
//        case .ASAntibannerUpdatePartCompleted:
//            DDLogInfo("(BackgroundFetchNotificationHandler) Antibanner update PART notification.")
//        case .ASAntibannerInstalled:
//            antibannerInstalled()
//        default:
//            break
//        }
//    }
    
    //MARK: - antibannerNotify cases
    
    //MARK: - AntibannerUpdateFilterRules
//    private func antibannerUpdateFilterRules() {
//        guard let isBackground = self.fetchPerformer?.isBackground else { return }
//        if isBackground {
//            DDLogInfo("(BackgroundFetchNotificationHandler) antibannerNotify. Skip in background")
//            return
//        }
//
//        contentBlockerService.reloadJsons(backgroundUpdate: false) { [weak self] error in
//            guard let self = self else { return }
//            if let _ = error {
//                self.contentBlockerServiceErrorHandler()
//            } else  {
//                // Success antibanner updated from backend
//                self.resources.sharedDefaults().setValue(Date(), forKey: AEDefaultsCheckFiltersLastDate)
//                DDLogInfo("(BackgroundFetchNotificationHandler) End of the Update Transaction from ASAntibannerUpdateFilterRulesNotification.")
//                self.updateFinishedNotify(filtersUpdated: false)
//            }
//        }
//    }
    
    private func contentBlockerServiceErrorHandler() {
        self.antibanner.rollbackTransaction()
        DDLogInfo("(BackgroundFetchNotificationHandler) Rollback of the Update Transaction from ASAntibannerUpdateFilterRulesNotification.")
        
        self.updateFailuredNotify()
        
        DispatchQueue.main.async {
            guard let nav = self.getNavigationController() else { return }
            if let topViewController = nav.topViewController, UIApplication.shared.applicationState != .background {
                ACSSystemUtils.showSimpleAlert(for: topViewController,
                                               withTitle: ACLocalizedString("common_error_title", "(AEUISubscriptionController) Alert title. When converting rules process finished in foreground updating."),
                                               message: ACLocalizedString("load_to_safari_error", "(BackgroundFetchNotificationHandler) Alert message. When converting rules process finished in foreground updating."))
            }
        }
    }
    
    
    //MARK: - AntibannerStartedUpdate
    
//    private func antibannerStartedUpdate() {
//        guard let isBackground = self.fetchPerformer?.isBackground else { return }
//        if !isBackground {
//            // turn on network activity indicator
//            UIApplication.shared.isNetworkActivityIndicatorVisible = true
//            self.updateStartedNotify()
//        }
//    }
//
//    //MARK: - AntibannerDidntStartUpdate
//
//    private func antibannerDidntStartUpdate() {
//        self.updateDidNotStartNotify()
//
//        if antibanner.inTransaction() {
//            antibanner.rollbackTransaction()
//            DDLogInfo("(BackgroundFetchNotificationHandler) Rollback of the Update Transaction from ASAntibannerDidntStartUpdateNotification.")
//        }
//        // Special update case.
//        self.fetchPerformer?.fetchState = .notStarted
//        self.fetchPerformer?.antibanerUpdateFinished(result: .updateFailed)
//    }
//
//    //MARK: - AntibannerFinishedUpdate
//
//    private func antibannerFinishedUpdate(notification: Notification) {
//        guard let isBackground = self.fetchPerformer?.isBackground else { return }
//        if isBackground {
//            self.fetchPerformer?.fetchState = .filtersupdated
//            antibanner.endTransaction()
//            self.fetchPerformer?.antibanerUpdateFinished(result: .updateNewData)
//            return
//        }
//
//        if let updatedFilters = notification.userInfo?[ASAntibannerUpdatedFiltersKey] as? [ASDFilterMetadata] {
//            self.updatedFilters = updatedFilters
//        }
//
//        reloadContentBlockerJson()
//        // turn off network activity indicator
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
    
    private func reloadContentBlockerJson() {
        contentBlockerService.reloadJsons(backgroundUpdate: true) { [weak self] _ in
            guard let self = self else { return }
            if self.antibanner.inTransaction() {
                // Success antibanner updated from backend
                self.resources.sharedDefaults().setValue(Date(), forKey: AEDefaultsCheckFiltersLastDate)
                self.antibanner.endTransaction()
                DDLogInfo("(BackgroundFetchNotificationHandler) End of the Update Transaction from ASAntibannerFinishedUpdateNotification.")
                self.updateFinishedNotify(filtersUpdated: true)
            }
            
            // Special update case (in background).
            self.fetchPerformer?.antibanerUpdateFinished(result: .updateNewData)
        }
    }
    
    //MARK: - AntibannerFailuredUpdate
//    private func antibannerFailuredUpdate() {
//        if antibanner.inTransaction() {
//            antibanner.rollbackTransaction()
//            DDLogInfo("(BackgroundFetchNotificationHandler) Rollback of the Update Transaction from ASAntibannerFailuredUpdateNotification.")
//        }
//
//        self.updateFailuredNotify()
//
//        // Special update case.
//        self.fetchPerformer?.fetchState = .notStarted
//        self.fetchPerformer?.antibanerUpdateFinished(result: .updateFailed)
//
//        // turn off network activity indicator
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
//
//    //MARK: - ASAntibannerInstalled
//
//    private func antibannerInstalled() {
//        contentBlockerService.reloadJsons(backgroundUpdate: true) { _ in
//            DDLogInfo("(BackgroundFetchNotificationHandler) content blocker reloaded after antibanner notification ASAntibannerInstalledNotification")
//        }
//    }
    
    
    //MARK: - UpdateNotify methods
    private func updateStartedNotify() {
        ACSSystemUtils.call {
            let appState = UIApplication.shared.applicationState
            DDLogInfo("(BackgroundFetchNotificationHandler) Started update process. AppState = \(appState.rawValue)")
            
            NotificationCenter.default.post(name: .appDelegateStartedUpdateNotification, object: self)
        }
    }
    
    private func updateDidNotStartNotify() {
        ACSSystemUtils.call { [weak self] in
            let appState = UIApplication.shared.applicationState
            DDLogInfo("(BackgroundFetchNotificationHandler) Did not started update process. AppState = \(appState.rawValue)")
            
            NotificationCenter.default.post(name: .appDelegateUpdateDidNotStartedNotification, object: self)
        }
    }
    
    private func updateFailuredNotify() {
        ACSSystemUtils.call { [weak self] in
            let appState = UIApplication.shared.applicationState
            DDLogInfo("(BackgroundFetchNotificationHandler) Failured update process. AppState = \(appState.rawValue)")
            
            NotificationCenter.default.post(name: .appDelegateFailuredUpdateNotification, object: self)
        }
    }
    
    private func updateFinishedNotify(filtersUpdated: Bool) {
        DDLogInfo("(BackgroundFetchNotificationHandler) Finished update process.")
        
        var metas = [ASDFilterMetadata]()
        
        if filtersUpdated {
            metas = updatedFilters
            updatedFilters.removeAll()
        }
        
        ACSSystemUtils.call { [weak self] in
            let appState = UIApplication.shared.applicationState
            DDLogInfo("(BackgroundFetchNotificationHandler) Finished update process, updated filters = \(metas.count). AppState = \(appState.rawValue)")
            
            let userInfo = [Notification.Name.appDelegateUpdatedFiltersKey: metas.count]
            NotificationCenter.default.post(name: .appDelegateFinishedUpdateNotification, object: self, userInfo: userInfo)
        }
    }
    
    private func getNavigationController() -> UINavigationController? {
        guard let nav = AppDelegate.topViewController() as? UINavigationController else { return nil }
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

