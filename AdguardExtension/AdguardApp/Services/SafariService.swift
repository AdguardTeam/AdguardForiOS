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
@objc
enum ContentBlockerType: Int, CaseIterable {
    case general
    case privacy
    case socialWidgetsAndAnnoyances
    case other
    case custom
    case security
}

// Affinity lists bitmasks
struct Affinity: OptionSet {
    
    let rawValue: UInt8
    
    static let general = Affinity(rawValue: 1 << 0)
    static let privacy = Affinity(rawValue: 1 << 1)
    static let socialWidgetsAndAnnoyances = Affinity(rawValue: 1 << 2)
    static let other = Affinity(rawValue: 1 << 3)
    static let custom = Affinity(rawValue: 1 << 4)
    static let security = Affinity(rawValue: 1 << 5)
}

// MARK: - protocol -

/**
 SafariService is responsible for save/load content blocker rules files and for invalidating safari content blockers
 */
@objc
protocol SafariServiceProtocol : NSObjectProtocol {
    /** invalidates all content blockers
     */
    func invalidateBlockingJsons(completion: @escaping (Error?) -> Void)
    
    /** saves json for content blocker with @type
    */
    func save(json: Data, type: Int)
    
    /** read json for content blocker with @type
     */
    func readJson(forType type: Int)->Data?
    
    /** returns all content blockers jsons in dictionary [filename: data]
     */
    func allBlockingContentRules()->[String : Data]
    
    /** checks enabled status of all safari content blockers
     returns true in callback if all content blockers are enabled in safari settings
     */
    func checkStatus(completion: @escaping (_ enabled: [NSNumber : Bool])->Void)
    
    /** returns state of content blocker ( on / off )
     */
    func getContentBlockerEnabled(type: ContentBlockerType) -> Bool
}

// MARK: - SafariService -

class SafariService: NSObject, SafariServiceProtocol {
    
    private var resources: AESharedResourcesProtocol
    
    static private let contenBlockerBundleIdByType: [ContentBlockerType: String] =
        [.general : "com.adguard.AdguardExtension.extension",
         .privacy: "com.adguard.AdguardExtension.extensionPrivacy",
         .socialWidgetsAndAnnoyances: "com.adguard.AdguardExtension.extensionAnnoyances",
         .other: "com.adguard.AdguardExtension.extensionOther",
         .custom: "com.adguard.AdguardExtension.extensionCustom",
         .security: "com.adguard.AdguardExtension.extensionSecurity"]
    
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
    
    func invalidateBlockingJsons(completion: @escaping (Error?) -> Void) {
        workQueue.async { [weak self] in
            guard let sSelf = self else { return }
            
            let updateQueue = DispatchQueue(label: "safari_update", attributes: DispatchQueue.Attributes.concurrent)
            
            updateQueue.async {
                
                let group = DispatchGroup()
                var resultError: Error?
                
                for blocker in ContentBlockerType.allCases {
                    
                    group.enter()
                    // Notify that filter began updating
                    NotificationCenter.default.post(name: SafariService.filterBeganUpdating, object: self, userInfo: [SafariService.contentBlockerTypeString : blocker])
                    
                    sSelf.invalidateJson(contentBlockerType: blocker, completion: { (error) in
                        if error != nil {
                            let bundleId = SafariService.contenBlockerBundleIdByType[blocker]!
                            DDLogError("(SafariService) invalidateBlockingJsons - Failed to reload json for content blocker: \(bundleId)")
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
    
    func save(json: Data, type: Int) {
        if let fileName = fileNames[ContentBlockerType(rawValue: type)!] {
            resources.save(json, toFileRelativePath: fileName)
        }
    }
    
    func readJson(forType type: Int) -> Data? {
        if let fileName = fileNames[ContentBlockerType(rawValue: type)!] {
            return resources.loadData(fromFileRelativePath: fileName)
        }
        
        return nil
    }
    
    @objc
    func allBlockingContentRules()->[String : Data] {
        var datas = [String : Data]()
        ContentBlockerType.allCases.forEach { (type) in
            let data = self.readJson(forType: type.rawValue)
            datas[fileNames[type]!] = data
        }
        return datas
    }
    
    // MARK: - safari content blocker status
    
    @objc
    func checkStatus(completion:@escaping (_ enabled: [NSNumber : Bool])->Void) {
        let checkQueue = DispatchQueue(label: "safari_check", attributes: DispatchQueue.Attributes.concurrent)
        
        checkQueue.async {
            
            let group = DispatchGroup()
            
            for blocker in ContentBlockerType.allCases {
                
                group.enter()
                self.chekStatusOfContentBlocker(contentBlockerType: blocker, callback: {[weak self] (enabled) in
                    self?.contentBlockersEnabled[blocker] = enabled
                    group.leave()
                })
            }
            group.wait()
            let objcContentBlockersEnabled = ObjcToSwiftAndBackAdapter.fromSwiftToObjc(dict: self.contentBlockersEnabled)
            
            completion(objcContentBlockersEnabled)
            NotificationCenter.default.post(name: SafariService.contentBlcokersChecked, object: self)
        }
        
    }
    
    private func chekStatusOfContentBlocker(contentBlockerType: ContentBlockerType, callback: @escaping (_ enabled: Bool)->Void)->Void {
        let bundleId = SafariService.contenBlockerBundleIdByType[contentBlockerType]!
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: bundleId) { (state, _) in
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
    
    private func invalidateJson(contentBlockerType: ContentBlockerType, completion: @escaping (Error?)->Void) {
        let bundleId = SafariService.contenBlockerBundleIdByType[contentBlockerType]!
        DDLogInfo("(SafariService) Starting notify Safari - invalidateJson. BundleId = \(bundleId)");
        
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: bundleId) { (error) in
            DDLogInfo("(SafariService) Finishing notify Safari - invalidateJson.");
            if error != nil {
                DDLogError("(SafariService) \(bundleId) Error occured: \(error!.localizedDescription)")
                let errorDescription = ACLocalizedString("safari_filters_loading_error", "");
                let error =  NSError(domain: "SafariServiceDomain", code: Int(AES_ERROR_SAFARI_EXCEPTION), userInfo: [NSLocalizedDescriptionKey: errorDescription])
                
                DDLogInfo("(SafariService) Notify Safari fihished.")
                completion(error)
            }
            else {
                DDLogError("(SafariService)  \(bundleId) reload successeded")
                completion(nil)
            }
        }
    }
}

class ObjcToSwiftAndBackAdapter {
    static func fromSwiftToObjc(dict: [ContentBlockerType : Bool]) -> [NSNumber : Bool] {
        var returnDict: [NSNumber : Bool] = [:]
        for d in dict {
            let key = d.key.rawValue as NSNumber
            returnDict[key] = d.value
        }
        return returnDict
    }
    
    static func fromObjcToSwift(dict: [NSNumber : Bool]) -> [ContentBlockerType : Bool] {
        var returnDict: [ContentBlockerType : Bool] = [:]
        for d in dict {
            guard let key = ContentBlockerType(rawValue: Int(truncating: d.key)) else { return [:] }
            returnDict[key] = d.value
        }
        return returnDict
    }
}
