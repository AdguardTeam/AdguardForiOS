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
import SharedAdGuardSDK

/// This struct represent Apple search ads attribution records JSON
struct AttributionRecords: Codable {
    let attribution: Bool
    let orgId: Int
    let campaignId: Int
    let conversionType: String
    let clickDate: String?
    let adGroupId: Int
    let countryOrRegion: String
    let keywordId: Int
    let creativeSetId: Int

    var jsonMap: [String: String] {
        var result = [String: String]()
        result["attribution"] = String(attribution)
        result["orgId"] = String(orgId)
        result["campaignId"] = String(campaignId)
        result["conversionType"] = conversionType
        result["adGroupId"] = String(adGroupId)
        result["countryOrRegion"] = countryOrRegion
        result["keywordId"] = String(keywordId)
        result["creativeSetId"] = String(creativeSetId)

        if let clickDate = clickDate {
            result["clickDate"] = clickDate
        }

        return result
    }
}

private let LOG = ComLog_LoggerFactory.getLoggerWrapper(AdServicesAttributionRecordsParser.self)

/// This object represent attribution records parser for URL response
final class AdServicesAttributionRecordsParser: ParserProtocol {
    typealias Model = [String: String]

    func parse(data: Data, response: URLResponse?) -> Model? {
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    let records = try JSONDecoder().decode(AttributionRecords.self, from: data)
                    return records.jsonMap
                } catch {
                    LOG.error("(AdServicesAttributionRecordsParser) - parse; Serialization error: \(error)")
                    return nil
                }
            }
            LOG.error("(AdServicesAttributionRecordsParser) - parse; Response status code is \(response.statusCode)")
        }
        LOG.error("(AdServicesAttributionRecordsParser) - parse; Response is nil")
        return nil
    }
}
