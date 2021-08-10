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
import SafariAdGuardSDK

enum ContentBlockerState {
    case disabled, enabled, updating, overLimited, failedUpdating
}

protocol ContentBlockerStateProtocol {
    var contentBlockerType: ContentBlockerType? { get }
    var currentState: ContentBlockerState? { get set }
    var numberOfRules: Int { get }
    var numberOfOverlimitedRules: Int { get }
    var filters: String { get }
    var enabled: Bool { get }
}

class ContentBlocker: ContentBlockerStateProtocol {
    private let safariProtection: SafariProtectionProtocol
    
    var userFilterString: String?
    
    var enabled: Bool {
        get {
            guard let type = contentBlockerType else { return false }
            return safariProtection.getState(for: type)
        }
    }
    
    var contentBlockerType: ContentBlockerType?

    var currentState: ContentBlockerState?
    
    var numberOfRules: Int {
        get {
            //todo:
//
//            guard let key = ContentBlockerService.defaultsCountKeyByBlocker[contentBlockerType!] else { return 0}
//            let number = resources.sharedDefaults().integer(forKey: key)
//            return number
            return 0
        }
    }
    
    var numberOfOverlimitedRules: Int {
        get {
            // todo:
//            let number = resources.sharedDefaults().integer(forKey: ContentBlockerService.defaultsOverLimitCountKeyByBlocker[contentBlockerType!]!)
//            return number
            return 0
        }
    }
    
    var filters: String {
        get {
            var returnString = ""
//            todo:
//            let groupIds = ContentBlockerService.groupsByContentBlocker[contentBlockerType!]
//            let groups = filterService.groups.filter({ (filter)->Bool in groupIds!.contains { (groupId) -> Bool in
//                groupId.rawValue == filter.groupId
//            }})
//            let enabledGroups = groups.filter({ $0.enabled })
//            for group in enabledGroups {
//                let filters = group.filters.filter({ $0.enabled == true })
//                let filterNames = filters.map({ $0.name })
//                filterNames.forEach({ returnString += $0! + "\n"})
//            }
//
//            returnString += userFilterString ?? ""
//
//            if returnString.count > 0{
//                returnString.removeLast(1)
//                returnString = ACLocalizedString("content_blocker_filters", nil) + "\n" + returnString
//            }
            return returnString
        }
    }
    
    init(contentBlockerType: ContentBlockerType?, safariProtection: SafariProtectionProtocol) {
        self.contentBlockerType = contentBlockerType
        self.safariProtection = safariProtection
        self.currentState = enabled ? (self.numberOfOverlimitedRules == 0 ? .enabled : .overLimited) : .disabled
    }

}

class ContentBlockersDataSource {
    
    private let resources: AESharedResourcesProtocol
    private let safariProtection: SafariProtectionProtocol
    
    var contentBlockers = [ContentBlockerType : ContentBlocker]()
    
    lazy var userFilterString: String = {
       return getUserFilterStringIfNedeed()
    }()
    
    init(resources: AESharedResourcesProtocol, safariProtection: SafariProtectionProtocol) {
        self.resources = resources
        self.safariProtection = safariProtection
        self.updateContentBlockersArray()
    }
    
    func updateContentBlockersArray(){
        for type in ContentBlockerType.allCases {
            let contentBlocker = ContentBlocker(contentBlockerType: type, safariProtection: safariProtection)
            contentBlocker.userFilterString = userFilterString
            self.contentBlockers[type] = contentBlocker
        }
    }
    
    private func getUserFilterStringIfNedeed() -> String {
        var result = ""
        let userTitleString = ACLocalizedString("user_filter_title", nil)
        let blacklistRuleObjects = safariProtection.allRules(for: .blocklist)
        let whitelistRuleObjects = safariProtection.allRules(for: .allowlist)
        let userFilterEnabled = resources.safariUserFilterEnabled
        let whitelistEnabled = resources.safariWhitelistEnabled
        
        if (userFilterEnabled && blacklistRuleObjects.count != 0) || (whitelistEnabled && !whitelistRuleObjects.isEmpty) {
            result = userTitleString + "\n"
        }
        return result
    }
}
