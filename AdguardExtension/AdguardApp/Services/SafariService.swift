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
import SafariServices

// MARK: - data types -
enum ContentBlockerType: Int, CaseIterable {
    case general
    case privacy
    case socialWidgetsAndAnnoyances
    case other
    case custom
    case security
}

// MARK: - protocol -

/**
 SafariService is responsible for save/load content blocker rules files and for invalidating safari content blockers
 */
protocol SafariServiceProtocol : NSObjectProtocol {
    /** invalidates all content blockers
     */
    func invalidateBlockingJsons(completion: @escaping (Error?) -> Void)
    
    /** invalidates all content blockers
     */
    func invalidateBlockingJson(type: ContentBlockerType,completion: @escaping (Error?) -> Void)
    
    /** saves json for content blocker with @type
    */
    func save(json: Data, type: ContentBlockerType)
    
    /** read json for content blocker with @type
     */
    func readJson(forType type: ContentBlockerType)->Data?
    
    /** returns all content blockers jsons in dictionary [filename: data]
     */
    func allBlockingContentRules()->[String : Data]
    
    /** checks enabled status of all safari content blockers
     returns true in callback if all content blockers are enabled in safari settings
     */
    func checkStatus(completion: @escaping (_ enabled: [ContentBlockerType : Bool])->Void)
    
    /** returns state of content blocker ( on / off )
     */
    func getContentBlockerEnabled(type: ContentBlockerType) -> Bool
    
    /** SFContentBlockerManager wrapper
        it is used for testing
     */
    var contentBlockerManager: SFContentBlockerManagerProtocol { get set }
}

/**
 this protocol is used for testing
 */
protocol SFContentBlockerManagerProtocol {
    func reloadContentBlocker(withIdentifier identifier: String, completionHandler: ((Error?) -> Void)?)
    func getStateOfContentBlocker(withIdentifier identifier: String, completionHandler: @escaping (SFContentBlockerState?, Error?) -> Void)
}

// MARK: - SafariService -

class SafariService: NSObject, SafariServiceProtocol {
    
    static let safariServiceErrorDomain = "SafariServiceErrorDomain"
    static let safariServiceErrorCode = -1
    
    /** SFContentBlockerManager wrapper
       it is used for testing
    */
    var contentBlockerManager: SFContentBlockerManagerProtocol = {
        class Manager: SFContentBlockerManagerProtocol {
            func getStateOfContentBlocker(withIdentifier identifier: String, completionHandler: @escaping (SFContentBlockerState?, Error?) -> Void) {
                SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: identifier, completionHandler: completionHandler)
            }
            
            func reloadContentBlocker(withIdentifier identifier: String, completionHandler: ((Error?) -> Void)?) {
                SFContentBlockerManager.reloadContentBlocker(withIdentifier: identifier, completionHandler: completionHandler)
            }
        }
        
        return Manager()
    }()
    
    private var resources: AESharedResourcesProtocol
    
    static var contenBlockerBundleIdByType: [ContentBlockerType: String] {
        if Bundle.main.isPro {
            return [.general : "com.adguard.AdguardPro.extension",
            .privacy: "com.adguard.AdguardPro.extensionPrivacy",
            .socialWidgetsAndAnnoyances: "com.adguard.AdguardPro.extensionAnnoyances",
            .other: "com.adguard.AdguardPro.extensionOther",
            .custom: "com.adguard.AdguardPro.extensionCustom",
            .security: "com.adguard.AdguardPro.extensionSecurity"]
        }
        else {
            return [.general : "com.adguard.AdguardExtension.extension",
             .privacy: "com.adguard.AdguardExtension.extensionPrivacy",
             .socialWidgetsAndAnnoyances: "com.adguard.AdguardExtension.extensionAnnoyances",
             .other: "com.adguard.AdguardExtension.extensionOther",
             .custom: "com.adguard.AdguardExtension.extensionCustom",
             .security: "com.adguard.AdguardExtension.extensionSecurity"]
        }
    }
    
    private let fileNames: [ContentBlockerType: String] = [
        .general: "cb_general.json",
        .privacy: "cb_privacy.json",
        .socialWidgetsAndAnnoyances: "cb_annoyances.json",
        .other: "cb_other.json",
        .custom: "cb_custom.json",
        .security: "cb_security.json"
    ]
    
    private let workQueue = DispatchQueue(label: "safari_service")
    
    static let filterBeganUpdating = Notification.Name("filterBeganUpdating")
    static let filterFinishedUpdating = Notification.Name("filterFinishedUpdating")
    static let contentBlcokersChecked = Notification.Name("contentBlcokersChecked")
    static let contentBlockerTypeString = "contentBlockerType"
    static let successString = "success"
    
    private var contentBlockersEnabled = [ContentBlockerType : Bool]()
    
    // MARK: - initializers
    @objc
    init(resources: AESharedResourcesProtocol) {
        self.resources = resources
    }
    
    // MARK: public methods
    
    let updateQueue = DispatchQueue(label: "safari_update", attributes: .concurrent)
    
    @objc func invalidateBlockingJsons(completion: @escaping (Error?) -> Void) {
    
        updateQueue.async { [weak self] in
            guard let self = self else { return }
            
            DDLogInfo("(SafariService) invalidateBlockingJsons")
                
            let group = DispatchGroup()
            var resultError: Error?

            for blocker in ContentBlockerType.allCases {
                
                group.enter()
                
                DDLogInfo("(SafariService) invalidateBlockingJsons - \(blocker)")

                // Notify that filter began updating
                NotificationCenter.default.post(name: SafariService.filterBeganUpdating, object: self, userInfo: [SafariService.contentBlockerTypeString : blocker])

                self.invalidateBlockingJson(type: blocker, completion: { (error) in
                    if error != nil {
                        DDLogError("(SafariService) invalidateBlockingJsons - Failed to reload json for content blocker: \(blocker)")
                        resultError = error
                    }
                    let sError = (error != nil) ? false : true
                    
                    // Notify that filter finished updating
                    NotificationCenter.default.post(name: SafariService.filterFinishedUpdating, object: self, userInfo: [SafariService.successString : sError, SafariService.contentBlockerTypeString : blocker])

                    group.leave()
                })
            }
            
            group.wait()
            
            completion(resultError)
        }
    }

    @objc
    func filenameById(_ contentBlockerId: String) -> String? {
        
        for (type, blockerId) in SafariService.contenBlockerBundleIdByType {
            if blockerId == contentBlockerId {
                return fileNames[type]
            }
        }
        
        return nil
    }
    
    // MARK: save/load files
    
    func save(json: Data, type: ContentBlockerType) {
        DDLogInfo("(SafariService) save \(json.count) bytes to \(contentBlockersEnabled) )")
        if let fileName = fileNames[type] {
            resources.save(json, toFileRelativePath: fileName)
        }
    }
    
    func readJson(forType type: ContentBlockerType) -> Data? {
        if let fileName = fileNames[type] {
            return resources.loadData(fromFileRelativePath: fileName)
        }
        
        return nil
    }
    
    @objc
    func allBlockingContentRules()->[String : Data] {
        var datas = [String : Data]()
        ContentBlockerType.allCases.forEach { (type) in
            let data = self.readJson(forType: type)
            datas[fileNames[type]!] = data
        }
        return datas
    }
    
    // MARK: - safari content blocker status
    
    func checkStatus(completion:@escaping (_ enabled: [ContentBlockerType : Bool])->Void) {
        let checkQueue = DispatchQueue(label: "safari_check", attributes: DispatchQueue.Attributes.concurrent)
        
        checkQueue.async {
            
            let group = DispatchGroup()
            
            for blocker in ContentBlockerType.allCases {
                
                group.enter()
                self.checkStatusOfContentBlocker(contentBlockerType: blocker, callback: {[weak self] (enabled) in
                    self?.contentBlockersEnabled[blocker] = enabled
                    group.leave()
                })
            }
            group.wait()
            
            completion(self.contentBlockersEnabled)
            NotificationCenter.default.post(name: SafariService.contentBlcokersChecked, object: self)
        }
        
    }
    
    private func checkStatusOfContentBlocker(contentBlockerType: ContentBlockerType, callback: @escaping (_ enabled: Bool)->Void)->Void {
        let bundleId = SafariService.contenBlockerBundleIdByType[contentBlockerType]!
        contentBlockerManager.getStateOfContentBlocker(withIdentifier: bundleId) { (state, _) in
            callback(state?.isEnabled ?? false)
        }
    }
    
    func getContentBlockerEnabled(type: ContentBlockerType) -> Bool {
        if let enabled = contentBlockersEnabled[type] {
            return enabled
        } else {
            return false
        }
    }
    
    // MARK: - private methods
    
    private let invalidateQueue = DispatchQueue(label: "invalidate queue")
    
    func invalidateBlockingJson(type: ContentBlockerType, completion: @escaping (Error?)->Void) {
        
        invalidateQueue.async { [weak self] in
            guard let self = self else { return }
            
            NotificationCenter.default.post(name: NSNotification.Name.ShowStatusView, object: self, userInfo: [AEDefaultsShowStatusViewInfo : ACLocalizedString("loading_content_blockers", nil)])
            
            // Notify that filter began updating
            NotificationCenter.default.post(name: SafariService.filterBeganUpdating, object: self, userInfo: [SafariService.contentBlockerTypeString : type])
            
            let group = DispatchGroup()
            group.enter()
            
            let bundleId = SafariService.contenBlockerBundleIdByType[type]!
            DDLogInfo("(SafariService) Starting notify Safari - invalidateJson. BundleId = \(bundleId)");
            
            self.contentBlockerManager.reloadContentBlocker(withIdentifier: bundleId) {[weak self] (error) in
                guard let sSelf = self else { return }
                
                DDLogInfo("(SafariService) Finishing notify Safari - invalidateJson.");
                if error != nil {
                    DDLogError("(SafariService) \(bundleId) Error occured: \(error!.localizedDescription)")
                    if let userInfo = (error as NSError?)?.userInfo {
                        DDLogError("(SafariService) userInfo: \(userInfo)")
                    }
                    
                    DDLogInfo("(SafariService) Notify Safari fihished.")
                    
                    // If content blocker failed to load in safari - we try to reload it second time
                    sSelf.tryToReload(contentBlockerWith: bundleId) { (error) in
                        if error != nil {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                    group.leave()
                }
                else {
                    DDLogInfo("(SafariService)  \(bundleId) reload successeded")
                    completion(nil)
                    group.leave()
                }
                
                // Notify that filter finished updating
                NotificationCenter.default.post(name: SafariService.filterFinishedUpdating,
                                                object: self,
                                                userInfo: [SafariService.successString : error == nil, SafariService.contentBlockerTypeString : type])
            }
            
            group.wait()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                NotificationCenter.default.post(name: NSNotification.Name.HideStatusView, object: self)
            }
        }
    }
    
    // Sometimes Safari fails to register a content blocker because of inner race conditions, so we try to reload it second time
    private func tryToReload(contentBlockerWith bundleId: String, completion: @escaping (Error?) -> Void) {
        invalidateQueue.async {
            
            let group = DispatchGroup()
            group.enter()
            
            self.contentBlockerManager.reloadContentBlocker(withIdentifier: bundleId) { (error) in
                DDLogInfo("(SafariService) Finishing notify Safari - invalidateJson. ( 2-nd try )");
                if error != nil {
                    DDLogError("(SafariService) \(bundleId) Error occured twice: \(error!.localizedDescription)")
                    if let userInfo = (error as NSError?)?.userInfo {
                        DDLogError("(SafariService) userInfo for 2-nd try: \(userInfo)")
                    }
                    let errorDescription = ACLocalizedString("safari_filters_loading_error", "");
                    let error =  NSError(domain: SafariService.safariServiceErrorDomain, code: SafariService.safariServiceErrorCode, userInfo: [NSLocalizedDescriptionKey: errorDescription])
                    
                    DDLogInfo("(SafariService) Notify Safari fihished. ( 2-nd try )")
                    completion(error)
                }
                else {
                    DDLogError("(SafariService)  \(bundleId) reload successeded with 2-nd try.")
                    completion(nil)
                }
                
                group.leave()
            }
            
            group.wait()
        }
    }
}
