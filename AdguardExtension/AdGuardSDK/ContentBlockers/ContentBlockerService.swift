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

protocol ContentBlockerServiceProtocol {
    /* Returns every content blocker state */
    var allContentBlockersStates: [ContentBlockerType: Bool] { get }
    
    /*
     Updates all content blockers
     Returns error if it occured during update
     Returns nil if everything is fine
     */
    func updateContentBlockers(onContentBlockersUpdated: @escaping (_ error: Error?) -> Void)
    
    /* Returns state of the specified content blocker */
    func getState(for cbType: ContentBlockerType) -> Bool
}

/* This class is responsible for updating Safari content blockers */
final class ContentBlockerService: ContentBlockerServiceProtocol {
    // MARK: - Internal properties
    
    var allContentBlockersStates: [ContentBlockerType : Bool] {
        var result: [ContentBlockerType : Bool] = [:]
        ContentBlockerType.allCases.forEach { result[$0] = getState(for: $0) }
        return result
    }
    
    // MARK: - Private properties
    
    // Queue for updating content blockers
    private let updateQueue = DispatchQueue(label: "AdGuardSDK.ContentBlockerService.updateQueue", qos: .background)
    
    // Queue for invalidating content blocking JSON
    private let invalidateQueue = DispatchQueue(label: "AdGuardSDK.ContentBlockerService.invalidateQueue", qos: .background)
    
    /* Services */
    private let configuration: ConfigurationProtocol
    private let jsonStorage: ContentBlockersInfoStorageProtocol
    private let contentBlockersManager: ContentBlockersManagerProtocol
    
    // MARK: - Initialization
    
    init(configuration: ConfigurationProtocol,
         jsonStorage: ContentBlockersInfoStorageProtocol,
         contentBlockersManager: ContentBlockersManagerProtocol = ContentBlockersManager())
    {
        self.configuration = configuration
        self.jsonStorage = jsonStorage
        self.contentBlockersManager = contentBlockersManager
    }
    
    // MARK: - Internal methods
    
    func updateContentBlockers(onContentBlockersUpdated: @escaping (_ error: Error?) -> Void) {
        updateQueue.async { [weak self] in
            NotificationCenter.default.contentBlockersUpdateStarted()
            let updateError = self?.updateContentBlockersSync()
            NotificationCenter.default.contentBlockersUpdateFinished()
            onContentBlockersUpdated(updateError)
        }
    }
    
    func getState(for cbType: ContentBlockerType) -> Bool {
        let group = DispatchGroup()
        let cbBundleId = cbType.contentBlockerBundleId(configuration.appBundleId)
        var isEnabled = false
        group.enter()
        contentBlockersManager.getStateOfContentBlocker(withId: cbBundleId) { result in
            switch result {
            case .success(let enabled):
                isEnabled = enabled
            case .error(let error):
                Logger.logError("(ContentBlockerService) - getState; Failed to reveal CB state, suppose it is disabled; Error: \(error)")
            }
            group.leave()
        }
        group.wait()
        return isEnabled
    }
    
    // MARK: - Private methods
    
    /*
     Updates all content blockers syncroniously.
     Returns error if some content blockers were failed to be updated.
     Returns nil if update successeded.
     */
    private func updateContentBlockersSync() -> Error? {
        var resultError: Error?
        let group = DispatchGroup()
        
        for cb in ContentBlockerType.allCases {
            group.enter()
            reloadContentBlocker(for: cb) { error in
                if let error = error {
                    resultError = error
                }
                group.leave()
            }
        }
        
        group.wait()
        return resultError
    }
    
    // Reloads safari content blocker. If fails for the first reload than tries to reload it once more
    private func reloadContentBlocker(for cbType: ContentBlockerType, firstTry: Bool = true, _ onContentBlockerReloaded: @escaping (_ error: Error?) -> Void) {
        invalidateQueue.async { [unowned self] in
            let cbBundleId = cbType.contentBlockerBundleId(configuration.appBundleId)
            
            // Try to reload content blocker
            contentBlockersManager.reloadContentBlocker(withId: cbBundleId) { error in
                if let error = error {
                    Logger.logError("(ContentBlockerService) - reloadContentBlocker; Error reloadind content blocker; Error: \(error)")
                    // Sometimes Safari fails to register a content blocker because of inner race conditions, so we try to reload it second time
                    if firstTry {
                        reloadContentBlocker(for: cbType, firstTry: false, onContentBlockerReloaded)
                    } else {
                        onContentBlockerReloaded(error)
                    }
                }
                else {
                    onContentBlockerReloaded(nil)
                }
            }
        }
    }
}

// MARK: - ContentBlockerType + contentBlockerBundleId

extension ContentBlockerType {
    func contentBlockerBundleId(_ mainAppBundleId: String) -> String {
        switch self {
        case .general: return "\(mainAppBundleId).extension"
        case .privacy: return "\(mainAppBundleId).extensionPrivacy"
        case .socialWidgetsAndAnnoyances: return "\(mainAppBundleId).extensionAnnoyances"
        case .other: return "\(mainAppBundleId).extensionOther"
        case .custom: return "\(mainAppBundleId).extensionCustom"
        case .security: return "\(mainAppBundleId).extensionSecurity"
        }
    }
}

// MARK: - NotificationCenter + Content blockers reload events

fileprivate extension NSNotification.Name {
    static var contentBlockersUpdateStarted: NSNotification.Name { .init(rawValue: "AdGuardSDK.contentBlockersUpdateStarted") }
    static var contentBlockersUpdateFinished: NSNotification.Name { .init(rawValue: "AdGuardSDK.contentBlockersUpdateFinished") }
}

fileprivate extension NotificationCenter {
    func contentBlockersUpdateStarted() {
        self.post(name: .contentBlockersUpdateStarted, object: self, userInfo: nil)
    }
    
    func contentBlockersUpdateFinished() {
        self.post(name: .contentBlockersUpdateFinished, object: self, userInfo: nil)
    }
}

public extension NotificationCenter {
    func contentBlockersUpdateStart(handler: @escaping () -> Void, queue: OperationQueue? = nil) -> NotificationToken {
        return self.observe(name: .contentBlockersUpdateStarted, object: nil, queue: queue) { _ in
            handler()
        }
    }
    
    func contentBlockersUpdateFinished(handler: @escaping () -> Void, queue: OperationQueue? = nil) -> NotificationToken {
        return self.observe(name: .contentBlockersUpdateFinished, object: nil, queue: queue) { _ in
            handler()
        }
    }
}
