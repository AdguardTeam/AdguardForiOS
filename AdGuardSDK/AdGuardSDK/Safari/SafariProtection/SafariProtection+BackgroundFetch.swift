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
import UIKit.UIBackgroundConfiguration

public protocol SafariProtectionBackgroundFetchProtocol {
    /**
     Updates filters while background fetch is active
     The process of filters update while app is in the background is rather complex
     We have 30 seconds to download all filters content, update filters and localizations and reload all content blockers
     If that huge process of update is run at once there is a big chance to fail an update
     If we fail an update the OS can ban our background fethces and we will be unable to update filters in background
     To avoid this ban we've devided an update process into 3 sequential steps:
     1. Update filters content, meta and localizations
     2. Convert new filters to JSON files for Safari Content Blockers
     3. Reload Safari Content Blockers with newely converted rules
     With this approach, the chances of a successful background fetch increases
     */
    func updateSafariProtectionInBackground(_ onStateExecutionFinished: @escaping (_ result: UIBackgroundFetchResult) -> Void)
    
    /**
     This method is neede to finish the update process that did start in the background
     
     For example:
        The background update did complete 2 out of 3 steps.
        To provide user with the latest data we should finish the update and complete the 3rd step
     Note:
        If background update did already finished successfully this method will do nothing
     
     The method should be called on the app start in **didFinishLaunchingWithOptions**
     */
    func finishBackgroundUpdate(_ onUpdateFinished: @escaping (_ error: Error?) -> Void)
}

/* Extension is used to update filters while main app is in the background */
extension SafariProtection {
    
    fileprivate enum BackgroundFetchState: Int, CustomDebugStringConvertible {
        case loadAndSaveFilters
        case convertFilters
        case reloadContentBlockers
        case updateFinished
        
        var debugDescription: String {
            switch self {
            case .loadAndSaveFilters: return "loadAndSaveFilters"
            case .convertFilters: return "convertFilters"
            case .reloadContentBlockers: return "reloadContentBlockers"
            case .updateFinished: return "updateFinished"
            }
        }
    }
    
    private var currentBackgroundFetchState: BackgroundFetchState {
        get {
            return userDefaults.currentBackgroundFetchState
        }
        set {
            userDefaults.currentBackgroundFetchState = newValue
        }
    }
    
    // MARK: - Public methods
    
    public func updateSafariProtectionInBackground(_ onStateExecutionFinished: @escaping (_ result: UIBackgroundFetchResult) -> Void) {
        Logger.logError("(SafariProtection+BackgroundFetch) - updateSafariProtectionInBackground; Start background fetch, current state = \(currentBackgroundFetchState)")
        
        switch currentBackgroundFetchState {
        case .loadAndSaveFilters, .updateFinished:
            updateFilters(inBackground: true) { result, _ in onStateExecutionFinished(result) }
        case .convertFilters:
            let (result, _) = convertFilters(inBackground: true)
            onStateExecutionFinished(result)
        case .reloadContentBlockers:
            reloadContentBlockers(inBackground: true) { result, _ in onStateExecutionFinished(result) }
        }
    }
    
    public func finishBackgroundUpdate(_ onUpdateFinished: @escaping (_ error: Error?) -> Void) {
        Logger.logInfo("(SafariProtection+BackgroundFetch) - finishBackgroundUpdate start; Current state = \(currentBackgroundFetchState)")
        
        switch currentBackgroundFetchState {
        case .loadAndSaveFilters:
            let group = DispatchGroup()
            group.enter()
            updateFilters(inBackground: false) { _, error in
                group.leave()
            }
            group.wait()
            fallthrough
        case .convertFilters:
            let (_, error) = convertFilters(inBackground: false)
            if let error = error {
                onUpdateFinished(error)
                return
            }
            fallthrough
        case .reloadContentBlockers:
            reloadContentBlockers(inBackground: false) { _, error in
                onUpdateFinished(error)
            }
        case .updateFinished:
            onUpdateFinished(nil)
        }
    }
    
    // MARK: - Private methods
    
    // 1st step of background update
    private func updateFilters(inBackground background: Bool, _ onFiltersUpdated: @escaping (_ result: UIBackgroundFetchResult, _ error: Error?) -> Void) {
        Logger.logInfo("(SafariProtection+BackgroundFetch) - updateFiltersInBackground start; background=\(background)")
        
        workingQueue.async { [weak self] in
            self?.filters.updateAllMeta(forcibly: true) { [weak self] result in
                switch result {
                case .success(let updateResult):
                    self?.currentBackgroundFetchState = .convertFilters
                    Logger.logInfo("(SafariProtection+BackgroundFetch) - updateFiltersInBackground.updateAllMeta; background=\(background); Filters were successfully loaded and saved; Update result: \(updateResult)")
                    onFiltersUpdated(.newData, nil)
                case .error(let error):
                    Logger.logError("(SafariProtection+BackgroundFetch) - updateFiltersInBackground.updateAllMeta; background=\(background); Error: \(error)")
                    onFiltersUpdated(.noData, error)
                }
            }
        }
    }
    
    // 2nd step of background update
    private func convertFilters(inBackground background: Bool) -> (UIBackgroundFetchResult, Error?) {
        Logger.logInfo("(SafariProtection+BackgroundFetch) - convertFiltersInBackground start; background=\(background)")
        
        return workingQueue.sync {
            do {
                let convertedfilters = try converter.convertFiltersAndUserRulesToJsons()
                try cbStorage.save(cbInfos: convertedfilters)
                currentBackgroundFetchState = .reloadContentBlockers
                Logger.logInfo("(SafariProtection+BackgroundFetch) - convertFiltersInBackground; background=\(background); Successfully converted all filters to JSONs")
                return (.newData, nil)
            }
            catch {
                Logger.logError("(SafariProtection+BackgroundFetch) - convertFiltersInBackground; background=\(background); Error converting filters: \(error)")
                return (.noData, error)
            }
        }
    }
    
    // 3rd step of background update
    private func reloadContentBlockers(inBackground background: Bool, _ onCbReloaded: @escaping (_ result: UIBackgroundFetchResult, _ error: Error?) -> Void) {
        Logger.logInfo("(SafariProtection+BackgroundFetch) - reloadContentBlockersInBackground start")
        
        workingQueue.async { [weak self] in
            self?.cbService.updateContentBlockers { [weak self] error in
                if let error = error {
                    Logger.logError("(SafariProtection+BackgroundFetch) - reloadContentBlockersInBackground; background=\(background); Error reloading CBs: \(error)")
                    onCbReloaded(.noData, error)
                } else {
                    Logger.logInfo("(SafariProtection+BackgroundFetch) - reloadContentBlockersInBackground; background=\(background); Successfully reloaded all CBs")
                    self?.currentBackgroundFetchState = .updateFinished
                    onCbReloaded(.newData, nil)
                }
            }
        }
    }
}

// MARK: - UserDefaultsStorageProtocol + currentBackgroundFetchState

fileprivate extension UserDefaultsStorageProtocol {
    
    private var currentBackgroundFetchStateKey: String { "AdGuardSDK.currentBackgroundFetchStateKey" }
    
    var currentBackgroundFetchState: SafariProtection.BackgroundFetchState {
        get {
            if let intObject = storage.value(forKey: currentBackgroundFetchStateKey) as? Int {
                return SafariProtection.BackgroundFetchState(rawValue: intObject) ?? .loadAndSaveFilters
            }
            return .loadAndSaveFilters
        }
        set {
            storage.setValue(newValue.rawValue, forKey: currentBackgroundFetchStateKey)
        }
    }
}
