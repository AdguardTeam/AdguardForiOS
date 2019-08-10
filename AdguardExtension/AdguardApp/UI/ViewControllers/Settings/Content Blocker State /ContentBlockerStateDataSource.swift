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
    
    private let safariService: SafariService
    private let resources: AESharedResourcesProtocol
    private let filterService: FiltersServiceProtocol
    
    var userFilterString: String?
    
    var enabled: Bool {
        get {
            guard let type = contentBlockerType else { return false }
            return safariService.getContentBlockerEnabled(type: type)
        }
    }
    
    var contentBlockerType: ContentBlockerType?

    var currentState: ContentBlockerState?
    
    var numberOfRules: Int {
        get {
            guard let key = ContentBlockerService.defaultsCountKeyByBlocker[contentBlockerType!] else { return 0}
            let number = resources.sharedDefaults().integer(forKey: key)
            return number
        }
    }
    
    var numberOfOverlimitedRules: Int {
        get {
            let number = resources.sharedDefaults().integer(forKey: ContentBlockerService.defaultsOverLimitCountKeyByBlocker[contentBlockerType!]!)
            return number
        }
    }
    
    var filters: String {
        get {
            var returnString = ""
            let groupIds = ContentBlockerService.groupsByContentBlocker[contentBlockerType!]
            let groups = filterService.groups.filter({ groupIds!.contains($0.groupId) })
            let enabledGroups = groups.filter({ $0.enabled })
            for group in enabledGroups {
                let filters = group.filters.filter({ $0.enabled == true })
                let filterNames = filters.map({ $0.name })
                filterNames.forEach({ returnString += $0! + "\n"})
            }
            
            returnString += userFilterString ?? ""
            
            if returnString.count > 0{
                returnString.removeLast(1)
            }
            return returnString
        }
    }
    
    init(contentBlockerType: ContentBlockerType?, safariService: SafariService, resources: AESharedResourcesProtocol, filterService: FiltersServiceProtocol) {
        self.contentBlockerType = contentBlockerType
        self.safariService = safariService
        self.resources = resources
        self.filterService = filterService
        self.currentState = (self.numberOfOverlimitedRules == 0) ? (enabled ? .enabled : .disabled) : .overLimited
    }

}

class ContentBlockersDataSource {
    
    private let safariService: SafariService
    private let resources: AESharedResourcesProtocol
    private let filterService: FiltersServiceProtocol
    private let antibanner: AESAntibannerProtocol
    
    var contentBlockers = [ContentBlockerType : ContentBlocker]()
    
    lazy var userFilterString: String = {
       return getUserFilterStringIfNedeed()
    }()
    
    init(safariService: SafariService, resources: AESharedResourcesProtocol, filterService: FiltersServiceProtocol, antibanner: AESAntibannerProtocol) {
        self.safariService = safariService
        self.resources = resources
        self.filterService = filterService
        self.antibanner = antibanner
        self.updateContentBlockersArray()
    }
    
    func updateContentBlockersArray(){
        for type in ContentBlockerType.allCases {
            let contentBlocker = ContentBlocker(contentBlockerType: type, safariService: safariService, resources: resources, filterService: filterService)
            contentBlocker.userFilterString = userFilterString
            self.contentBlockers[type] = contentBlocker
        }
    }
    
    private func getUserFilterStringIfNedeed() -> String {
        let userTitleString = ACLocalizedString("user_filter_title", nil)
        let rulesCount = antibanner.rulesCount(forFilter: ASDF_USER_FILTER_ID as NSNumber)
        
        if rulesCount != 0 {
            return userTitleString + "\n"
        }
        
        return ""
    }
}
