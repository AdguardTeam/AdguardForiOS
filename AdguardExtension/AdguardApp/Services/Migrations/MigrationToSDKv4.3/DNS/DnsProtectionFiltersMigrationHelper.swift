//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import Foundation
import struct DnsAdGuardSDK.DnsFilter
import SharedAdGuardSDK

/// This object is a helper for `SDKMigrationServiceHelper`
/// It is responsible for providing DNS filters content and meta from previous storage and saving it in new storage
/// And removing obsolete data
protocol DnsProtectionFiltersMigrationHelperProtocol: AnyObject {
    /// Returns DNS filters meta from old storage
    func getDnsFiltersMeta() -> [SDKDnsMigrationObsoleteDnsFilter]

    /// Saves DNS filters objects to new storage
    func saveDnsFiltersToSDK(_ filters: [SDKDnsMigrationObsoleteDnsFilter]) throws

    /// Replaces old DNS filters files from old storage to new one
    func replaceFilesForDnsFilters(with ids: [Int]) throws

    /// Clears DNS filters objects old storage
    func removeDnsFiltersDataFromOldStorage()
}

private let LOG = ComLog_LoggerFactory.getLoggerWrapper(DnsProtectionFiltersMigrationHelper.self)

/// Implementation of `DnsProtectionFiltersMigrationHelperProtocol`
final class DnsProtectionFiltersMigrationHelper: DnsProtectionFiltersMigrationHelperProtocol {

    private let oldDnsFiltersContainerFolderUrl: URL
    private let newDnsFiltersContainerFolderUrl: URL
    private let resources: AESharedResourcesProtocol

    init(
        oldDnsFiltersContainerFolderUrl: URL,
        newDnsFiltersContainerFolderUrl: URL,
        resources: AESharedResourcesProtocol
    ) {
        self.oldDnsFiltersContainerFolderUrl = oldDnsFiltersContainerFolderUrl
        self.newDnsFiltersContainerFolderUrl = newDnsFiltersContainerFolderUrl
        self.resources = resources
        NSKeyedUnarchiver.setClass(SDKDnsMigrationObsoleteDnsFilter.self, forClassName: "DnsFilter")
    }

    func getDnsFiltersMeta() -> [SDKDnsMigrationObsoleteDnsFilter] {
        let savedDnsFiltersData = resources.sharedDefaults().object(forKey: "kSharedDefaultsDnsFiltersMetaKey") as? [Data] ?? []
        let dnsFilters: [SDKDnsMigrationObsoleteDnsFilter] = savedDnsFiltersData.compactMap {
            let obj = NSKeyedUnarchiver.unarchiveObject(with: $0)
            return obj as? SDKDnsMigrationObsoleteDnsFilter
        }

        LOG.info("Got \(dnsFilters.count) DNS filters meta")
        return dnsFilters
    }

    func saveDnsFiltersToSDK(_ filters: [SDKDnsMigrationObsoleteDnsFilter]) throws {
        LOG.info("Saving \(filters.count) DNS filters meta to new storage")

        let newDnsFilters = filters.map {
            return DnsFilter(
                filterId: $0.id,
                subscriptionUrl: $0.subscriptionUrl,
                isEnabled: $0.enabled,
                name: $0.name,
                description: $0.desc,
                version: $0.version,
                lastUpdateDate: $0.updateDate,
                homePage: $0.homepage,
                licensePage: nil,
                issuesReportPage: nil,
                communityPage: nil,
                filterDownloadPage: $0.subscriptionUrl.path,
                rulesCount: $0.rulesCount ?? 0
            )
        }

        let encoder = JSONEncoder()
        let filtersData = try encoder.encode(newDnsFilters)
        resources.sharedDefaults().setValue(filtersData, forKey: "DnsAdGuardSDK.dnsFiltersKey")

        LOG.info("Saved \(filters.count) DNS filters meta to new storage")
    }

    func removeDnsFiltersDataFromOldStorage() {
        resources.sharedDefaults().removeObject(forKey: "kSharedDefaultsDnsFiltersMetaKey")
    }

    /**
     In App version 4.2 and earlier DNS filters were stored in files with name `dns_filter_\(id).txt`
     Now they are stored as `\(id).txt`
     Besides custom DNS filters ids have changed
     It was so:
        blocklistFilterId = 1
        allowlistFilterId = 2
        customDnsFilters = 3+
     It is now:
        customFilters = 0…10000
        enabledBlocklist = 10001
        enabledAllowlist = 10002
        allRulesBlocklist = 10003
        allRulesAllowlist = 10004
     As custom DNS filters have stayed in same range, we won't change their identifiers
     */
    func replaceFilesForDnsFilters(with ids: [Int]) throws {
        LOG.info("Replacing \(ids.count) DNS filters files to new folder")

        for id in ids {
            let oldFileName = "dns_filter_\(id).txt"
            let newFileName = "\(id).txt"

            let oldFileUrl = oldDnsFiltersContainerFolderUrl.appendingPathComponent(oldFileName)
            let newFileUrl = newDnsFiltersContainerFolderUrl.appendingPathComponent(newFileName)

            guard FileManager.default.fileExists(atPath: oldFileUrl.path) else {
                throw CommonError.missingFile(filename: oldFileUrl.path)
            }

            try FileManager.default.copyOrReplace(at: oldFileUrl, to: newFileUrl)
            try FileManager.default.removeItem(at: oldFileUrl)
        }

        LOG.info("Replaced \(ids.count) DNS filters files to new folder")
    }
}

// MARK: - Object to decode data for DNS filters meta

class SDKDnsMigrationObsoleteDnsFilter: NSObject, NSCoding {
    let id: Int
    let subscriptionUrl: URL
    let name: String?
    let updateDate: Date?
    let enabled: Bool
    let desc: String?
    let version: String?
    let rulesCount: Int?
    let homepage: String?

    init(id: Int, subscriptionUrl: URL, name: String?, updateDate: Date?, enabled: Bool, desc: String?, version: String?, rulesCount: Int?, homepage: String?) {
        self.id = id
        self.subscriptionUrl = subscriptionUrl
        self.name = name
        self.updateDate = updateDate
        self.enabled = enabled
        self.desc = desc
        self.version = version
        self.rulesCount = rulesCount
        self.homepage = homepage
    }

    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(subscriptionUrl.absoluteString, forKey: "subscriptionUrl")
        coder.encode(name, forKey: "name")
        coder.encode(updateDate, forKey: "updateDate")
        coder.encode(enabled, forKey: "enabled")
        coder.encode(desc, forKey: "desc")
        coder.encode(version, forKey: "version")
        coder.encode(rulesCount, forKey: "rulesCount")
        coder.encode(homepage, forKey: "homepage")
    }

    required init?(coder: NSCoder) {
        guard
            let subscriptionUrlString = coder.decodeObject(forKey: "subscriptionUrl") as? String,
            let subscriptionUrl = URL(string: subscriptionUrlString)
        else {
            return nil
        }

        self.id = coder.decodeInteger(forKey: "id")
        self.subscriptionUrl = subscriptionUrl
        self.name = coder.decodeObject(forKey: "name") as? String
        self.updateDate = coder.decodeObject(forKey: "updateDate") as? Date
        self.enabled = coder.decodeBool(forKey: "enabled")
        self.desc = coder.decodeObject(forKey: "desc") as? String
        self.version = coder.decodeObject(forKey: "version") as? String
        self.rulesCount = coder.decodeObject(forKey: "rulesCount") as? Int
        self.homepage = coder.decodeObject(forKey: "homepage") as? String
    }
}
