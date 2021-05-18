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

protocol ExtendedCustomFilterMetaProtocol: FilterMetaProtocol {
    var licensePage: String? { get }
    var issuesReportPage: String? { get }
    var communityPage: String? { get }
    var rulesCount: Int { get }
}

struct CustomFilterMeta: ExtendedCustomFilterMetaProtocol {
    let name: String? // key: 'Title'
    let description: String? // key: 'Description'
    let version: String? // key: 'Version'; Filter version
    let lastUpdateDate: Date? // keys: 'Last Modified', 'TimeUpdated'; The date when the filter was last updated on the server-side
    let updateFrequency: Int? // key: 'Expires' Filter update frequency in seconds, shows how often we should update it
    let homePage: String? // key: 'Homepage'
    let licensePage: String? // keys: 'Licence', 'License'
    let issuesReportPage: String? // key: 'Reporting Issues'
    let communityPage: String? // key: 'Community'
    let filterDownloadPage: String? // key: 'Download'
    let rulesCount: Int
}
