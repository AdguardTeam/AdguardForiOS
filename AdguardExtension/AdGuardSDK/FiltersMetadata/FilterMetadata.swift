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

struct FilterMetadata {
    let title: String?
    let description: String?
    let version: String? // Filter version
    let lastUpdateDate: Date? // The date when the filter was last updated on the server-side
    let updateFrequency: Int? // Filter update frequency in seconds, shows how often we should update it
    let homePage: String?
    let licensePage: String?
    let issuesReportPage: String?
    let communityPage: String?
    let filterDownloadPage: String?
    let rulesCount: Int
}
