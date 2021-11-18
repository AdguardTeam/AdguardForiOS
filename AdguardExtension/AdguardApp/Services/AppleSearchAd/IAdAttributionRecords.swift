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

struct IAdAttributionRecords {
    let attribution: Bool
    let orgName: String
    let orgId: String
    let campaignId: String
    let campaignName: String
    let purchaseDate: String
    let conversionDate: String
    let conversionType: String
    let clickDate: String
    let adgroupId: String
    let adgroupName: String
    let countryOrRegion: String
    let keyword: String
    let keywordId: String
    let keywordMatchtype: String
    let creativesetId: String
    let creativesetName: String

    init?(attributes: [String: Any]) {
        guard
            let attribution = attributes["iad-attribution"] as? Bool,
            let orgName = attributes["iad-org-name"] as? String,
            let orgId = attributes["iad-org-id"] as? String,
            let campaignId = attributes["iad-campaign-id"] as? String,
            let campaignName = attributes["iad-campaign-name"] as? String,
            let purchaseDate = attributes["iad-purchase-date"] as? String,
            let conversionDate = attributes["iad-conversion-date"] as? String,
            let conversionType = attributes["iad-conversion-type"] as? String,
            let clickDate = attributes["iad-click-date"] as? String,
            let adgroupId = attributes["iad-adgroup-id"] as? String,
            let adgroupName = attributes["iad-adgroup-name"] as? String,
            let countryOrRegion = attributes["iad-country-or-region"] as? String,
            let keyword = attributes["iad-keyword"] as? String,
            let keywordId = attributes["iad-keyword-id"] as? String,
            let keywordMatchtype = attributes["iad-keyword-matchtype"] as? String,
            let creativesetId = attributes["iad-creativeset-id"] as? String,
            let creativesetName = attributes["iad-creativeset-name"] as? String
        else { return nil }

        self.attribution = attribution
        self.orgName = orgName
        self.orgId = orgId
        self.campaignId = campaignId
        self.campaignName = campaignName
        self.purchaseDate = purchaseDate
        self.conversionDate = conversionDate
        self.conversionType = conversionType
        self.clickDate = clickDate
        self.adgroupId = adgroupId
        self.adgroupName = adgroupName
        self.countryOrRegion = countryOrRegion
        self.keyword = keyword
        self.keywordId = keywordId
        self.keywordMatchtype = keywordMatchtype
        self.creativesetId = creativesetId
        self.creativesetName = creativesetName
    }
}
