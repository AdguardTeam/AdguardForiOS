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

// MARK: - data types -
class Filter: NSObject {
    
    let filterId: Int
    
    var name: String?
    var desc: String?
    var version: String?
    var enabled: Bool = false
    var homepage: String?
    var tags:[(name: String,heighlighted: Bool)]?
    var langs:[(name: String, heighlighted: Bool)]?
    var rulesCount: Int?
    var groupId: Int
    var displayNumber: Int?
    
    init(filterId: Int, groupId: Int) {
        self.filterId = filterId
        self.groupId = groupId
        super.init()
    }
}

class Group {
    
    let groupId: Int
    
    var name: String?
    var subtitle: String?
    var enabled: Bool = false
    var iconName: String?
    var disabledIconName: String?
    var proOnly: Bool = false
    
    var filters: [Filter] = [Filter]()
    
    init(_ groupId: Int) {
        self.groupId = groupId
    }
}

// MARK: - service protocol -
/**
 FiltersService is responsible for obtaining and manage filters data and metadata
 */
protocol FiltersServiceProtocol {
    
    // MARK: - public fields
    var groups: [Group] { get }
    var filtersCount: Int { get }
    var activeFiltersCount: Int { get }
    
    /** enable/disable group of filters
     */
    func setGroup(_ group: Group, enabled: Bool)
    
    /** enable/disable filter
     */
    func setFilter(_ filter: Filter, enabled: Bool)
    
    /** add custom filter
     */
    func addCustomFilter(_ filter: AASCustomFilterParserResult, overwriteExisted: Bool)
    
    /** delete custom filter
     */
    func deleteCustomFilter(_ filter: Filter)
    
    /** load filters metadata.
     @refresh - if yes - force load metadata from server. Ignore update timeout.
     */
    func load(refresh: Bool, _ completion: @escaping () -> Void)
    
    func getGroup(_ groupId: Int)->Group?
    
    /** FiltersService sends updateNotification via NotificationCenter when filters changes */
    var updateNotification: Notification.Name { get }
}

class FiltersService: NSObject, FiltersServiceProtocol {
    
    var updateNotification: Notification.Name = Notification.Name("FiltersServiceUpdateNotification")
    
    var groups = [Group]()
    
    private var antibanner: AESAntibannerProtocol
    private var configuration: ConfigurationServiceProtocol
    private var contentBlocker: ContentBlockerServiceProtocol
    
    private var filterMetas = [ASDFilterMetadata]()
    private var proGroups: Set<Int> = [FilterGroupId.security, FilterGroupId.custom]
    
    private var notificationObserver: Any?
    private var proStatusObservation: NSKeyValueObservation?
    
    // exception languages
    private let langFlags = [
        "en":"gb",
        "zh":"cn",
        "ja":"jp",
        "ko":"kr",
        "fa":"ir",
        "vi":"vn",
        "el":"gr",
        "da":"dk",
        "he":"il",
        "cs":"cz"
    ]
    
    private let updateQueue = DispatchQueue(label: "filter_service_update")
    private let workQueue = DispatchQueue(label: "filter_service_update")
    private var needUpdate = false
    private var updateInProcess = false
    private var enabledFilters = [Int: Bool]()
    
    @objc dynamic var activeFiltersCount: Int {
        get {
            var count = 0
            for group in groups {
                if group.enabled {
                    for filter in group.filters {
                        if filter.enabled {
                            count += 1;
                        }
                    }
                }
            }
            
            return count
        }
    }
    
    @objc dynamic var filtersCount: Int  {
        get {
            var count = 0
            for group in groups {
                count += group.filters.count
            }
            
            return count
        }
    }
    
    // MARK: - initialization
    
    init(antibanner: AESAntibannerProtocol, configuration: ConfigurationServiceProtocol, contentBlocker: ContentBlockerServiceProtocol) {
        self.antibanner = antibanner
        self.configuration = configuration
        self.contentBlocker = contentBlocker
        
        super.init()
        
        self.notificationObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.ASAntibannerFilterEnabled, object: nil, queue: nil) {[weak self] (note) in
            
            if  let filter_id: Int = note.userInfo?["filter_id"] as? Int,
                let enabled: Bool = (note.userInfo?["enabled"] as? NSNumber)?.boolValue{
                DispatchQueue.main.async {
                    self?.update(filterId: filter_id, enabled: enabled)
                }
            }
        }
        
        proStatusObservation = (self.configuration as? ConfigurationService)?.observe(\.proStatus) {[weak self] (_, _) in
            self?.notifyChange()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(notificationObserver!)
    }
    
    // MARK: - public methods
    
    func load(refresh: Bool, _ completion: @escaping () -> Void){
        
        DispatchQueue(label: "load_filter_grops_queue").async { [weak self] in
            guard let strongSelf = self else { return }
            
            guard   let metadata = strongSelf.antibanner.metadata(forSubscribe: refresh),
                let i18n = strongSelf.antibanner.i18n(forSubscribe: refresh),
                var filters = metadata.filters else {
                    completion()
                    return
            }
            
            let installedFilters = strongSelf.antibanner.filters() 
            
            var groups = strongSelf.antibanner.groups()
            
            // remove user group
            groups = groups.filter({ (group) -> Bool in
                return group.groupId.intValue != FilterGroupId.user
            })
            
            var meta: ASDFilterMetadata
            for item in installedFilters {
                let index = filters.firstIndex(of: item)
                if index != nil {
                    meta = filters[index!]
                    let values = item.dictionaryWithValues(forKeys: [
                        "updateDate",
                        "updateDateString",
                        "checkDate",
                        "checkDateString",
                        "version",
                        "enabled"])
                    meta.setValuesForKeys(values)
                }
                else if item.filterId.int32Value != ASDF_USER_FILTER_ID{
                    filters.append(item)
                }
            }
            
            let installedFilterIDs = installedFilters.map { $0.filterId }
            
            let predicate = NSPredicate(format: "NOT (filterId IN %@)", installedFilterIDs)
            let disabledFilters = filters.filter(){
                predicate.evaluate(with: $0)
            }
            
            disabledFilters.forEach({$0.enabled = false})
                        
            let groupInfos = strongSelf.obtainGroupsFromMetadatas(filterMetas: filters, groupMetas: groups, i18n: i18n)
            
            // set real enabled statuses
            groupInfos?.forEach({ (group) in
                guard let storedGroup = (strongSelf.groups.first { $0.groupId == group.groupId }) else { return }
                group.enabled = storedGroup.enabled
            })
            
            if strongSelf.enabledFilters.count == 0 {
                for filterMeta in installedFilters {
                    strongSelf.enabledFilters[filterMeta.filterId.intValue] = filterMeta.enabled.boolValue
                }
            }
            else {
                groupInfos?.forEach({ (group) in
                    for filter in group.filters {
                        filter.enabled = strongSelf.enabledFilters[filter.filterId] ?? false
                    }
                    strongSelf.updateGroupSubtitle(group)
                })
            }
            
            DispatchQueue.main.async {
                strongSelf.groups = groupInfos ?? [Group]()
                strongSelf.filterMetas = filters
                strongSelf.notifyChange()
                completion()
            }
        }
    }
    
    func setGroup(_ group: Group, enabled: Bool) {
        
        group.enabled = enabled
        
        updateGroupSubtitle(group)
        
        notifyChange()
        
        processUpdate()
    }
    
    func setFilter(_ filter: Filter, enabled: Bool) {
        updateQueue.sync { [weak self] in
            filter.enabled = enabled
            self?.enabledFilters[filter.filterId] = enabled
        }
        
        guard let group = getGroup(filter.groupId) else { return }
        
        updateGroupSubtitle(group)
        notifyChange()
        processUpdate()
        
        if !group.enabled && enabled {
            for filterToDisable in group.filters {
                if (filterToDisable == filter) || !(enabledFilters[filterToDisable.filterId] ?? false) {
                    continue
                }
                
                setFilter(filterToDisable, enabled: false)
            }
            
            setGroup(group, enabled: true)
        }
        else if group.enabled {
            var allFiltersDisabled = true
            for filter in group.filters {
                if filter.enabled {
                    allFiltersDisabled = false
                    break;
                }
            }
            
            if allFiltersDisabled {
                setGroup(group, enabled: false)
            }
        }
    }
    
    func addCustomFilter(_ filter: AASCustomFilterParserResult, overwriteExisted: Bool) {
        
        let backgroundTaskID = UIApplication.shared.beginBackgroundTask { }
        
        if overwriteExisted {
            if let existedFilterId = antibanner.customFilterId(byUrl: filter.meta.subscriptionUrl) {
                deleteCustomFilterWithId(existedFilterId)
            }
        }

        filter.meta!.filterId = antibanner.nextCustomFilterId() as NSNumber
        
        for group in groups {
            if group.groupId != FilterGroupId.custom { continue }
            
            let newFilter = Filter(filterId: filter.meta!.filterId as! Int, groupId: FilterGroupId.custom)
            newFilter.name = filter.meta!.name
            newFilter.desc = filter.meta!.descr
            newFilter.homepage = filter.meta!.homepage
            newFilter.version = filter.meta!.version
            newFilter.enabled = true
            newFilter.rulesCount = filter.rules.count
            
            group.filters = [newFilter] + group.filters

            if !group.enabled {
                setGroup(group, enabled: true)
            }
            
            updateGroupSubtitle(group)
            notifyChange()
        }
       
        antibanner.subscribeCustomFilter(from: filter) {
            [weak self] in
            self?.contentBlocker.reloadJsons(backgroundUpdate: false) { (error) in
                UIApplication.shared.endBackgroundTask(backgroundTaskID)
            }
        }
    }
    
    func deleteCustomFilter(_ filter: Filter) {
        deleteCustomFilterWithId(filter.filterId as NSNumber)
    }
    
    func deleteCustomFilterWithId(_ filterId: NSNumber) {
        
        let backgroundTaskID = UIApplication.shared.beginBackgroundTask { }
        
        antibanner.unsubscribeFilter(filterId as NSNumber)
        
        for group in groups {
            if group.groupId != FilterGroupId.custom { continue }
            
            group.filters = group.filters.filter({ $0.filterId != Int(truncating: filterId) })
            
            if group.enabled && group.filters.count == 0 {
                setGroup(group, enabled: false)
            }
            
            notifyChange()
            
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
        }
    }
    
    func getGroup(_ groupId: Int)->Group? {
        return groups.first {$0.groupId == groupId }
    }
    
    // MARK: - private methods
    
    private func getDiff()->(filters: [Int: Bool], groups: [Int: Bool]) {
        var filterIds = [Int: Bool]()
        var groupIds = [Int: Bool]()
        
        let groupMetas = self.antibanner.groups()
        
        var storedGroupStatuses = [Int: Bool]()
        groupMetas.forEach { storedGroupStatuses[$0.groupId.intValue] = $0.enabled.boolValue }
        
        var storedfilterStatuses = [Int: Bool]()
        filterMetas.forEach { storedfilterStatuses[$0.filterId.intValue] = $0.enabled.boolValue }
        
        groups.forEach { (group) in
            if let storedStatus = storedGroupStatuses[group.groupId] {
                if storedStatus != group.enabled {
                    groupIds[group.groupId] = group.enabled
                }
            }
            else {
                groupIds[group.groupId] = group.enabled
            }
            
            for filter in group.filters {
                if let storedStatus = storedfilterStatuses[filter.filterId] {
                    if storedStatus != filter.enabled && storedStatus != enabledFilters[filter.filterId] {
                        filterIds[filter.filterId] = filter.enabled
                    }
                }
                else {
                    filterIds[filter.filterId] = filter.enabled
                }
            }
        }
        
        return (filterIds, groupIds)
    }
    
    private func obtainGroupsFromMetadatas(filterMetas: [ASDFilterMetadata], groupMetas: [ASDFilterGroup], i18n:ABECFilterClientLocalization) -> [Group]?{
        
        if filterMetas.count == 0 || groupMetas.count == 0 {return nil}
        
        let filterByGroupId = filterMetas.reduce(into: [Int: [ASDFilterMetadata]]()) { (dict, filter) in
            let groupId = filter.groupId.intValue
            if (dict[groupId] == nil) {
                dict[groupId] = [ASDFilterMetadata]()
            }
            (dict[groupId])?.append(filter)
        }
        
        var resultGroups = [Group]()
        
        for groupMeta in groupMetas {
            let group = Group(groupMeta.groupId.intValue)
            
            let groupLocalization = i18n.groups?.localization(for: groupMeta)
            group.name = groupLocalization?.name
            group.enabled = groupMeta.enabled.boolValue
            group.proOnly = proGroups.contains(group.groupId)
            
            let filterMetas = filterByGroupId[groupMeta.groupId.intValue] ?? []
            for filterMeta in filterMetas {
                let filter = Filter(filterId: filterMeta.filterId.intValue, groupId: group.groupId )
                
                let filterLocalization = i18n.filters?.localization(forFilter: filterMeta)
                filter.name = filterLocalization?.name
                filter.desc = filterLocalization?.descr
                filter.version = filterMeta.version
                filter.enabled = group.enabled && filterMeta.enabled.boolValue
                filter.homepage = filterMeta.homepage
                filter.displayNumber = filterMeta.displayNumber.intValue
                
                if filter.groupId == FilterGroupId.custom {
                    filter.rulesCount = Int(antibanner.rulesCount(forFilter: NSNumber(value: filter.filterId)))
                }
                
                var tags = [String]()
                var langs = [String]()
                
                let supportedTags = [ASDFilterTagTypePurpose,
                                     ASDFilterTagTypeRecommended,
                                     ASDFilterTagTypePlatform,
                                     ASDFilterTagTypeProblematic,
                                     ASDFilterTagTypeObsolete]
                
                filterMeta.tags?.forEach({ (tagId) in
                    if let tag = tagId.name, supportedTags.contains(tagId.type) {
                        tags.append(tag)
                    }
                    else if let lang = tagId.name, tagId.type == ASDFilterTagTypeLang {
                        langs.append(langFlags[lang] ?? lang)
                    }
                })
                filter.tags = tags.map({ (name) -> (String, Bool) in
                    (name, false)
                })
                group.filters.append(filter)
                filter.langs = langs.map({ (name) -> (String, Bool) in
                    (name, false)
                })
            }
            
            resultGroups.append(group)
        }
        
        return setGroupsIconAndCount(resultGroups)
    }
    
    private func setGroupsIconAndCount(_ groups: [Group])->[Group] {
        for group in groups {
            switch group.groupId {
            case FilterGroupId.ads:
                group.iconName = "ads-group-icon"
            case FilterGroupId.socialWidgets:
                group.iconName = "social-group-icon"
            case FilterGroupId.annoyances:
                group.iconName = "annoyances-group-icon"
            case FilterGroupId.languageSpecific:
                group.iconName = "language-group-icon"
            case FilterGroupId.security:
                group.iconName = "security-group-icon"
                group.disabledIconName = "security-group-icon-disabled"
            case FilterGroupId.custom:
                group.iconName = "custom-group-icon"
                group.disabledIconName = "custom-group-icon-disabled"
            case FilterGroupId.other:
                group.iconName = "other-group-icon"
            case FilterGroupId.privacy:
                group.iconName = "prvacy-group-icon"
                
            default:
                break
            }
            
            updateGroupSubtitle(group)
        }
        
        return groups
    }
    
    private func updateGroupSubtitle(_ group: Group) {
        if group.enabled {
            let enabledCount = group.filters.reduce(0) { (result, filter) -> Int in
                return filter.enabled ? result + 1 : result }
            
            group.subtitle = String(format: ACLocalizedString("filter_group_filters_count_format", nil), enabledCount, group.filters.count)
        }
        else {
            group.subtitle = ACLocalizedString("filters_group_disabled", nil)
        }
    }
    
    private func update(filterId:Int, enabled: Bool) {

        guard let filterMeta = filterMetas.first(where: { $0.filterId.intValue == filterId }) else { return }

        filterMeta.enabled = NSNumber(value: enabled)

        guard let index = groups.firstIndex(where: { $0.groupId == filterMeta.groupId.intValue}) else { return }
        let group = groups[index]

        let filter = group.filters.first(where: {$0.filterId == filterId})
        filter?.enabled = enabled
        
        let backgroundTaskID = UIApplication.shared.beginBackgroundTask { }

        if enabled {
            if !group.enabled {
                group.enabled = true
                antibanner.setFiltersGroup(group.groupId as NSNumber, enabled: enabled)
                contentBlocker.reloadJsons(backgroundUpdate: false) { (error) in
                    UIApplication.shared.endBackgroundTask(backgroundTaskID)
                }
            }
        }
        else {
            let enabledExists = group.filters.contains { $0.enabled }
            if !enabledExists {
                if group.enabled {
                    group.enabled = false

                    antibanner.setFiltersGroup(group.groupId as NSNumber, enabled: enabled)
                    contentBlocker.reloadJsons(backgroundUpdate: false)  { (error) in
                        UIApplication.shared.endBackgroundTask(backgroundTaskID)
                    }
                }
            }
        }

        updateGroupSubtitle(group)
        
        notifyChange()
    }
    
    private func processUpdate() {
        
        updateQueue.sync {
            
            if updateInProcess {
                needUpdate = true
            }
            else {
                needUpdate = false
                updateInProcess = true
            }
        }
        
        if needUpdate {
            return
        }
        
        workQueue.async { [weak self] in
            guard let sSelf = self else { return }
            
            let backgroundTaskID = UIApplication.shared.beginBackgroundTask { }
        
            let diff = sSelf.getDiff()
            
            DDLogInfo("DIFF: \(diff)")
            
            diff.filters.forEach({ (filterId: Int, enabled: Bool) in
                sSelf.antibannerSetFilter(filterId: filterId, enabled: enabled)
                DDLogInfo("Process update filter: \(filterId) enabled: \(enabled)")
            })
            
            diff.groups.forEach({ (groupId: Int, enabled: Bool) in
                sSelf.antibanner.setFiltersGroup(groupId as NSNumber, enabled: enabled)
            })
            
            sSelf.contentBlocker.reloadJsons(backgroundUpdate: false, completion: { (error) in
                sSelf.updateQueue.async {
                    
                    sSelf.updateInProcess = false
                    
                    if sSelf.needUpdate {
                        DispatchQueue.main.async {
                            sSelf.processUpdate()
                        }
                    }
                    
                    UIApplication.shared.endBackgroundTask(backgroundTaskID)
                }
            })
        }
    }
    
    private func notifyChange() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(Notification(name: self.updateNotification))
            self.willChangeValue(for: \.filtersCount)
            self.didChangeValue(for: \.filtersCount)
            self.willChangeValue(for: \.activeFiltersCount)
            self.didChangeValue(for: \.activeFiltersCount)
        }
    }
    
    private func antibannerSetFilter(filterId: Int, enabled: Bool) {
        
        if !antibanner.checkIfFilterInstalled(filterId as NSNumber) {
            guard let filterMeta = (filterMetas.first { $0.filterId.intValue == filterId }) else { return }
            filterMeta.enabled = true
            antibanner.subscribeFilters([filterMeta], jobController: nil)
        }

        antibanner.setFilter(filterId as NSNumber, enabled: enabled, fromUI: true)
    }
}
