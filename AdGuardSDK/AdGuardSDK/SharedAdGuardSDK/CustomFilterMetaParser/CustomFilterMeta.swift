///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import Foundation

public protocol ExtendedCustomFilterMetaProtocol: FilterMetaProtocol {
    var licensePage: String? { get }
    var issuesReportPage: String? { get }
    var communityPage: String? { get }
}

public extension ExtendedCustomFilterMetaProtocol {
    static var baseCustomFilterId: Int { 10_000 }
}

public struct CustomFilterMeta: ExtendedCustomFilterMetaProtocol {
    public let name: String? // key: 'Title'
    public let description: String? // key: 'Description'
    public let version: String? // key: 'Version'; Filter version
    public let lastUpdateDate: Date? // keys: 'Last Modified', 'TimeUpdated'; The date when the filter was last updated on the server-side
    public let updateFrequency: Int? // key: 'Expires' Filter update frequency in seconds, shows how often we should update it
    public let homePage: String? // key: 'Homepage'
    public let licensePage: String? // keys: 'Licence', 'License'
    public let issuesReportPage: String? // key: 'Reporting Issues'
    public let communityPage: String? // key: 'Community'
    public let filterDownloadPage: String? // key: 'Download'
    public let rulesCount: Int

    public init(name: String?, description: String?, version: String?, lastUpdateDate: Date?, updateFrequency: Int?, homePage: String?, licensePage: String?, issuesReportPage: String?, communityPage: String?, filterDownloadPage: String?, rulesCount: Int) {
        self.name = name
        self.description = description
        self.version = version
        self.lastUpdateDate = lastUpdateDate
        self.updateFrequency = updateFrequency
        self.homePage = homePage
        self.licensePage = licensePage
        self.issuesReportPage = issuesReportPage
        self.communityPage = communityPage
        self.filterDownloadPage = filterDownloadPage
        self.rulesCount = rulesCount
    }
}
