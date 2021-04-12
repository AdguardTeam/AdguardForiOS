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


// MARK: - service protocol -
/**
 FiltersService is responsible for obtaining and manage filters data and metadata
 */
protocol FiltersServiceProtocol {
    
    // MARK: - public fields
    var groups: [Group] { get }
    var activeFiltersCount: Int { get }
    
    /* enable/disable group of filters */
    func setGroup(_ groupId: Int, enabled: Bool)
    
    /* enable/disable filter */
    func setFilter(_ filter: Filter, enabled: Bool)
    
    /* disable all filters */
    func disableAllFilters()
    
    /* add custom filter */
    func addCustomFilter(_ filter: AASCustomFilterParserResult)
    
    /* delete custom filter */
    func deleteCustomFilter(_ filter: Filter)
    
    /** load filters metadata.
     @refresh - if yes - force load metadata from server. Ignore update timeout.
     */
    func load(refresh: Bool, _ completion: @escaping () -> Void)
    
    /* reser service */
    func reset()
    
    /* reads groups from database
     Sometimes we update the states of groups directly in the database.
     In this case, we must force reading of this states
     */
    func updateGroups()
    
    func getGroup(_ groupId: Int)->Group?
    
    func renameCustomFilter(_ filterId: Int, _ newName: String)
    
    /** FiltersService sends updateNotification via NotificationCenter when filters changes */
    var updateNotification: Notification.Name { get }
}

class FiltersService: NSObject, FiltersServiceProtocol {
    
    var updateNotification: Notification.Name = Notification.Name("FiltersServiceUpdateNotification")
    
    var groups = [Group]()
    
    var antibanner: AESAntibannerProtocol?
    let httpRequestService: HttpRequestServiceProtocol
    private let antibannerController: AntibannerControllerProtocol
    private var configuration: ConfigurationServiceProtocol
    private var contentBlocker: ContentBlockerServiceProtocol
    private var filtersStorage: FiltersStorageProtocol
    
    private var filterMetas = [ASDFilterMetadata]()
    private var proGroups: Set<Int> = [FilterGroupId.security, FilterGroupId.custom]
    
    private var notificationObserver: Any?
    private var proStatusObservation: NSKeyValueObservation?
    
    private let groupsQueue = DispatchQueue(label: "load_filter_grops_queue")
    
    var resources: AESharedResourcesProtocol
    
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
        "cs":"cz",
        "sv":"se",
        "ar":"sa",
        "et":"ee"
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
    
    // MARK: - initialization
    
    init(antibannerController: AntibannerControllerProtocol, configuration: ConfigurationServiceProtocol, contentBlocker: ContentBlockerServiceProtocol, resources: AESharedResourcesProtocol, httpRequestService: HttpRequestServiceProtocol, filtersStorage: FiltersStorageProtocol) {
        self.configuration = configuration
        self.contentBlocker = contentBlocker
        self.antibannerController = antibannerController
        self.resources = resources
        self.httpRequestService = httpRequestService
        self.filtersStorage = filtersStorage
        
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
            guard let self = self else { return }
            
            // enable/disable pro groups
            let proEnabled = configuration.proStatus
        
            // If we've turned off pro groups we don't need them to turn on while background fetches are checking license status
            //https://github.com/AdguardTeam/AdguardForiOS/issues/1263
            if proEnabled {
                return
            }
            
            for group in self.groups {
                if self.proGroups.contains(group.groupId) {
                    self.setGroup(group.groupId, enabled: proEnabled)
                }
            }
            
            self.processUpdate()
        }
        
        antibannerController.onReady { [weak self] (antibanner) in
            self?.antibanner = antibanner
            self?.load(refresh: false){}
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(notificationObserver!)
    }
    
    // MARK: - public methods
    
    func load(refresh: Bool, _ completion: @escaping () -> Void){
        
        antibannerController.onReady {[weak self] antibanner in
            self?.groupsQueue.async { [weak self] in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name.ShowStatusView, object: self, userInfo: [AEDefaultsShowStatusViewInfo : ACLocalizedString("loading_filters", nil)])
                }
                
                guard let metadata = self.metadata(refresh: refresh),
                      let i18n = self.filtersI18n(refresh: refresh),
                    var filters = metadata.filters else {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name.HideStatusView, object: self)
                        }
                        completion()
                        return
                }
                
                // remove "Malware Domains" filter from filters list.
                // Apple rejects binary with word 'malware' within
                filters = filters.filter { (filter) in
                    filter.filterId != 208
                }
                
                let installedFilters = antibanner.filters()
                
                var groups = antibanner.groups()
                
                // set localized name for custom group. We don't store it in database
                if let customGroup = groups.first(where: { $0.groupId.intValue == FilterGroupId.custom }) {
                    customGroup.name = ACLocalizedString("custom_group_name", nil);
                }
                
                // remove user group
                groups = groups.filter({ (group) -> Bool in
                    return group.groupId.intValue != FilterGroupId.user
                })
                
                var meta: ASDFilterMetadata
                var filtersNeededUpdate = [Int]()
                
                for item in installedFilters {
                    let index = filters.firstIndex(of: item)
                    if index != nil {
                        meta = filters[index!]
                        
                        if let oldVersion = item.version,
                           let newVersion = meta.version,
                           newVersion.compare(oldVersion, options: .numeric, range: nil, locale: nil) == .orderedDescending {
                            filtersNeededUpdate.append(meta.filterId.intValue)
                        }
                        
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
                            
                let groupInfos = self.obtainGroupsFromMetadatas(antibanner: antibanner, filterMetas: filters, groupMetas: groups, i18n: i18n)
                
                // set real enabled statuses
                groupInfos?.forEach({ (group) in
                    guard let storedGroup = (self.groups.first { $0.groupId == group.groupId }) else { return }
                    group.enabled = storedGroup.enabled
                })
                
                if self.enabledFilters.count == 0 {
                    for filterMeta in installedFilters {
                        self.enabledFilters[filterMeta.filterId.intValue] = filterMeta.enabled.boolValue
                    }
                }
                
                groupInfos?.forEach({ (group) in
                    for filter in group.filters {
                        filter.enabled = self.enabledFilters[filter.filterId] ?? false
                    }
                    self.updateGroupSubtitle(group)
                })
                
                self.removeObsoleteFilter(metadata: metadata, dbFilters: filters)
                
                // update filter rules
                if refresh {
                    self.updateFilterRulesSync(identifiers: filtersNeededUpdate)
                    
                    let customFilters = installedFilters.filter { $0.groupId.intValue == FilterGroupId.custom }
                    let filterUrls = customFilters.compactMap { (meta) -> (Int, URL)? in
                        if let url = URL(string: meta.subscriptionUrl) {
                            return (meta.filterId.intValue, url)
                        }
                        return nil
                    }
                    self.updateCustomFiltersSync(filterUrls: filterUrls)
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.groups = groupInfos ?? [Group]()
                    self.filterMetas = filters
                    self.notifyChange()
                    completion()
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name.HideStatusView, object: self)
                    }
                }
            }
        }
    }
    
    func updateGroups() {
        groupsQueue.async { [weak self] in
            guard let self = self else { return }
            
            guard let dbGroups = self.antibanner?.groups() else { return }
            
            self.groups.forEach({ (group) in
                if let dbGroup = dbGroups.first(where: { $0.groupId.intValue == group.groupId }) {
                    group.enabled = dbGroup.enabled.boolValue
                    self.updateGroupSubtitle(group)
                }
            })
        }
    }
    
    func reset() {
        groups = [Group]()
        filterMetas = [ASDFilterMetadata]()
        enabledFilters = [Int: Bool]()
    }
    
    func setGroup(_ groupId: Int, enabled: Bool) {
        
        guard let group = getGroup(groupId) else { return }
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
        
        if filter.enabled {
            group.enabled = true
        }
        
        updateGroupSubtitle(group)
        notifyChange()
        processUpdate()
    }
    
    func disableAllFilters() {
        updateQueue.sync { [weak self] in
            for group in groups {
                for filter in group.filters {
                    filter.enabled = false
                    self?.enabledFilters[filter.filterId] = false
                }
            }
        }
        
        for group in groups {
            updateGroupSubtitle(group)
        }
        
        notifyChange()
        processUpdate()
    }
    
    func addCustomFilter(_ filter: AASCustomFilterParserResult) {
        
        let backgroundTaskID = UIApplication.shared.beginBackgroundTask { }
        
        guard let antibanner = antibanner else { return }
        filter.meta.filterId = antibanner.nextCustomFilterId() as NSNumber
        
        for group in groups {
            if group.groupId != FilterGroupId.custom { continue }
            
            if let matchFilter = group.filters.first(where: { $0.subscriptionUrl == filter.meta.subscriptionUrl }) {
                update(filterId: matchFilter.filterId, enabled: true)
                setFilter(matchFilter, enabled: true)
            } else {
                let newFilter = Filter(filterId: filter.meta.filterId as! Int, groupId: FilterGroupId.custom)
                newFilter.name = filter.meta.name
                newFilter.desc = filter.meta.descr
                newFilter.homepage = filter.meta.homepage
                newFilter.subscriptionUrl = filter.meta.subscriptionUrl
                newFilter.version = filter.meta.version
                newFilter.enabled = true
                newFilter.rulesCount = filter.rules.count
                
                group.filters = [newFilter] + group.filters
                
                if !group.enabled {
                    setGroup(group.groupId, enabled: true)
                }
                
                updateGroupSubtitle(group)
                notifyChange()
                
                antibanner.subscribeCustomFilter(from: filter) { [weak self] in
                    guard let url = URL(string: newFilter.subscriptionUrl ?? "") else {
                        DDLogError("(FiltersService) error - can not get url from string: \(newFilter.subscriptionUrl ?? "nil")")
                        return
                    }
                    self?.filtersStorage.updateCustomFilter(identifier: newFilter.filterId, subscriptionUrl: url) { (error) in
                        self?.contentBlocker.reloadJsons(backgroundUpdate: false) { _ in
                            UIApplication.shared.endBackgroundTask(backgroundTaskID)
                        }
                    }
                }
            }
        }
        
        enabledFilters[filter.meta.filterId.intValue] = true
    }
    
    func renameCustomFilter(_ filterId: Int, _ newName: String) {
        for group in groups {
            if group.groupId != FilterGroupId.custom { continue }
            
            for filter in group.filters {
                if filter.filterId == filterId {
                    filter.name = newName
                    notifyChange()
                }
            }
        }
        antibanner?.renameCustomFilter(NSNumber(integerLiteral: filterId), newName: newName)
    }
    
    func deleteCustomFilter(_ filter: Filter) {
        deleteCustomFilterWithId(filter.filterId as NSNumber)
    }
    
    func deleteCustomFilterWithId(_ filterId: NSNumber) {
        guard let antibanner = self.antibanner else { return }
            
        antibanner.unsubscribeFilter(filterId as NSNumber)
        
        for group in groups {
            if group.groupId != FilterGroupId.custom { continue }
            
            group.filters = group.filters.filter({ $0.filterId != Int(truncating: filterId) })
            
            if group.enabled && group.filters.count == 0 {
                setGroup(group.groupId, enabled: false)
            }
            notifyChange()
        }
    }
    
    func getGroup(_ groupId: Int)->Group? {
        return groups.first {$0.groupId == groupId }
    }
    
    // MARK: - private methods
    
    private func getDiff()->(filters: [Int: Bool], groups: [Int: Bool]) {
        
        guard let antibanner = self.antibanner else { return ([:], [:])}
        var filterIds = [Int: Bool]()
        var groupIds = [Int: Bool]()
        
        let groupMetas = antibanner.groups()
        
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
    
    private func obtainGroupsFromMetadatas(antibanner: AESAntibannerProtocol,filterMetas: [ASDFilterMetadata], groupMetas: [ASDFilterGroup], i18n:ABECFilterClientLocalization) -> [Group]?{
        
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
                filter.updateDate = filterMeta.updateDate
                filter.enabled = group.enabled && filterMeta.enabled.boolValue
                filter.homepage = filterMeta.homepage
                filter.subscriptionUrl = filterMeta.subscriptionUrl
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
            case FilterGroupId.custom:
                group.iconName = "custom"
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
            group.subtitle = ACLocalizedString("disabled", nil)
        }
    }
    
    private func update(filterId:Int, enabled: Bool) {

        guard let filterMeta = filterMetas.first(where: { $0.filterId.intValue == filterId }) else { return }

        filterMeta.enabled = NSNumber(value: enabled)

        guard let index = groups.firstIndex(where: { $0.groupId == filterMeta.groupId.intValue}) else { return }
        let group = groups[index]

        let filter = group.filters.first(where: {$0.filterId == filterId})
        filter?.enabled = enabled
        
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
        
        let backgroundTaskID = UIApplication.shared.beginBackgroundTask { }
        
        workQueue.async { [weak self] in
            guard let self = self else { return }
        
            let diff = self.getDiff()
            
            if diff.filters.count == 0 && diff.groups.count == 0 {
                self.endUpdate(taskId: backgroundTaskID)
                return
            }
            
            DDLogInfo("DIFF: \(diff)")
            
            diff.filters.forEach({ (filterId: Int, enabled: Bool) in
                self.antibannerSetFilter(filterId: filterId, enabled: enabled)
                DDLogInfo("Process update filter: \(filterId) enabled: \(enabled)")
            })
            
            diff.groups.forEach{ (groupId: Int, enabled: Bool) in
                self.antibanner?.setFiltersGroup(groupId as NSNumber, enabled: enabled)
                DDLogInfo("Process update group: \(groupId) enabled: \(enabled)")
            }
            
            self.contentBlocker.reloadJsons(backgroundUpdate: false, completion: { (error) in
                self.endUpdate(taskId: backgroundTaskID)
            })
        }
    }
    
    private func endUpdate(taskId: UIBackgroundTaskIdentifier) {
        updateQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.updateInProcess = false
            
            if self.needUpdate {
                DispatchQueue.main.async {
                    self.processUpdate()
                }
            }
            
            UIApplication.shared.endBackgroundTask(taskId)
        }
    }
    
    private func notifyChange() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(Notification(name: self.updateNotification))
            self.willChangeValue(for: \.activeFiltersCount)
            self.didChangeValue(for: \.activeFiltersCount)
        }
    }
    
    private func antibannerSetFilter(filterId: Int, enabled: Bool) {
        
        guard let antibanner = self.antibanner else { return }
        if !antibanner.checkIfFilterInstalled(filterId as NSNumber) {
            guard let filterMeta = (filterMetas.first { $0.filterId.intValue == filterId }) else {
                DDLogInfo("Failed to find meta for filter with filterId = \(filterId)")
                return
            }
            filterMeta.enabled = true
            antibanner.subscribeFilters([filterMeta])
        } else {
            DDLogInfo("Filter with filterId = \(filterId) is not installed")
        }

        antibanner.setFilter(filterId as NSNumber, enabled: enabled, fromUI: true)
    }
    
    private func removeObsoleteFilter(metadata: ABECFilterClientMetadata, dbFilters: [ASDFilterMetadata]) {
        guard let newFilters: [ASDFilterMetadata] = metadata.filters else {
            DDLogError("(FiltersService) - metadata.filters == nil")
            return
        }
        let newFiltersIds = newFilters.map { $0.filterId }
        
        let filtersToRemove = dbFilters.filter { (filter) -> Bool in
            if newFiltersIds.contains(filter.filterId) {
                return false
            }
            
            if filter.groupId.intValue == FilterGroupId.custom || filter.groupId.intValue == FilterGroupId.user {
                return false
            }
            
            return true
        }
        
        for filter in filtersToRemove {
            antibanner?.unsubscribeFilter(filter.filterId)
        }
    }
    
    private func updateFilterRulesSync(identifiers: [Int]) {
        let group = DispatchGroup()
        for id in identifiers {
            group.enter()
            filtersStorage.updateFilter(identifier: id) { (_) in
                group.leave()
            }
        }
        group.wait()
    }
    
    private func updateCustomFiltersSync(filterUrls: [(Int, URL)]) {
        let group = DispatchGroup()
        for filter in filterUrls {
            group.enter()
            filtersStorage.updateCustomFilter(identifier: filter.0, subscriptionUrl: filter.1) { (_) in
                group.leave()
            }
        }
        group.wait()
    }
}
